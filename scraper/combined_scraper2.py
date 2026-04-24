import os
import re
import time
import sqlite3
import requests
from bs4 import BeautifulSoup

from selenium import webdriver
from selenium.webdriver.support.ui import Select
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


###################################
# CONFIG
###################################

GE_URL = "https://www.fullerton.edu/general-education/student-info/approved-courses.html"

# ✅ CORRECT ID (WITH DASH)
GE_DROPDOWN_ID = "list-div-13"

CATALOG_BASE_URL = (
    "https://catalog.fullerton.edu/content.php?"
    "catoid=95&navoid=14518"
    "&filter%5Bitem_type%5D=3"
    "&filter%5Bonly_active%5D=1"
    "&filter%5B3%5D=1"
    "&filter%5Bcpage%5D={}"
)

CATALOG_ROOT = "https://catalog.fullerton.edu/"
DB_NAME = "ge_matched_courses.db"
TOTAL_PAGES = 39


###################################
# HELPER FUNCTION
###################################

def normalize(code: str) -> str:
    return re.sub(r"\s+", "", code.strip().upper())


###################################
# RESET DATABASE (so only THIS run is saved)
###################################

if os.path.exists(DB_NAME):
    os.remove(DB_NAME)
    print(f"Deleted old database: {DB_NAME}")

conn = sqlite3.connect(DB_NAME)
cur = conn.cursor()

cur.execute("""
CREATE TABLE IF NOT EXISTS ge_courses (
    ge_category TEXT NOT NULL,
    course_code TEXT NOT NULL,
    title TEXT,
    description TEXT,
    prereqs TEXT,
    PRIMARY KEY (ge_category, course_code)
)
""")

conn.commit()


###################################
# STEP 1 — SCRAPE GE COURSES
###################################

print("Opening GE website...")

driver = webdriver.Firefox()
driver.get(GE_URL)

wait = WebDriverWait(driver, 30)

# ✅ Correct dropdown selection
dropdown = wait.until(
    EC.presence_of_element_located((By.ID, GE_DROPDOWN_ID))
)

select = Select(dropdown)

ge_set = set()
course_to_categories = {}

for option in select.options:
    category = option.text.strip()

    if category == "Choose any topic" or not category:
        continue

    print(f"Scraping GE category: {category}")

    select.select_by_visible_text(category)
    time.sleep(2)

    rows = driver.find_elements(By.XPATH, "//table//tbody//tr")

    for row in rows:
        cols = row.find_elements(By.TAG_NAME, "td")
        if not cols:
            continue

        course_code = cols[0].text.strip()
        if not course_code:
            continue

        norm = normalize(course_code)
        ge_set.add(norm)

        course_to_categories.setdefault(norm, []).append(category)

driver.quit()

print(f"\nTotal unique GE courses found: {len(ge_set)}")


###################################
# STEP 2 — SCRAPE CATALOG (GE ONLY)
###################################

print(f"\nScraping catalog pages 1–{TOTAL_PAGES} (GE-only)...")

catalog_data = {}

session = requests.Session()
session.headers.update({"User-Agent": "Mozilla/5.0"})

for page in range(1, TOTAL_PAGES + 1):
    print(f"Scanning catalog page {page}...")

    url = CATALOG_BASE_URL.format(page)
    resp = session.get(url, timeout=30)
    resp.raise_for_status()

    soup = BeautifulSoup(resp.text, "html.parser")

    course_links = soup.find_all("a", href=re.compile("preview_course_nopop"))

    for link in course_links:
        title_text = link.get_text(strip=True)

        code_match = re.search(r"\b[A-Z]{2,5}\s?\d{3}[A-Z]?\b", title_text)
        if not code_match:
            continue

        display_code = re.sub(r"\s+", " ", code_match.group().strip().upper())
        norm_code = normalize(display_code)

        # ✅ Only process GE courses
        if norm_code not in ge_set:
            continue

        # Avoid duplicate requests
        if norm_code in catalog_data:
            continue

        course_url = CATALOG_ROOT + link["href"]

        try:
            course_resp = session.get(course_url, timeout=30)
            course_resp.raise_for_status()
        except:
            continue

        course_soup = BeautifulSoup(course_resp.text, "html.parser")

        desc_block = course_soup.find("td", class_="block_content")
        if not desc_block:
            continue

        description = desc_block.get_text(" ", strip=True)

        prereq_match = re.search(r"Prerequisite[s]?:.*?(?=\.)", description)
        prereqs = prereq_match.group().strip() if prereq_match else "None"

        catalog_data[norm_code] = {
            "display_code": display_code,
            "title": title_text,
            "description": description,
            "prereqs": prereqs,
        }

print(f"\nCatalog GE matches scraped: {len(catalog_data)}")


###################################
# STEP 3 — SAVE MATCHED COURSES
###################################

print("\nSaving matched courses to SQLite...")

saved = 0

for norm_code, data in catalog_data.items():
    categories = course_to_categories.get(norm_code, [])
    if not categories:
        continue

    for category in categories:
        cur.execute("""
            INSERT OR REPLACE INTO ge_courses
            (ge_category, course_code, title, description, prereqs)
            VALUES (?, ?, ?, ?, ?)
        """, (
            category,
            data["display_code"],
            data["title"],
            data["description"],
            data["prereqs"]
        ))
        saved += 1

conn.commit()
conn.close()

print(f"\nDONE ✅ Saved {saved} matched GE courses into {DB_NAME}")
