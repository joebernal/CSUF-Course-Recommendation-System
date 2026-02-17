from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.common.by import By
from bs4 import BeautifulSoup
import sqlite3
import time
import re

URL = "https://catalog.fullerton.edu/preview_program.php?catoid=70&poid=32659"

# -----------------------------
# Remove only UI junk
# -----------------------------
def clean_text(text):
    junk_phrases = [
        "Add to Portfolio",
        "Add to My Favorites",
        "Share",
        "Facebook",
        "Tweet",
        "Print",
        "opens a new window",
        "this Page",
        "Close"
    ]
    for j in junk_phrases:
        text = text.replace(j, "")
    return " ".join(text.split())

# -----------------------------
# Extract prereqs / coreqs
# -----------------------------
def extract_prereqs(text):
    match = re.search(r"(Prerequisite[s]*:.*?|Corequisite[s]*:.*?)(?:\.|$)", text)
    return match.group(1).strip() if match else "None"

# -----------------------------
# Main scraper
# -----------------------------
def main():
    options = Options()
    options.add_argument("--width=1200")
    options.add_argument("--height=900")

    driver = webdriver.Firefox(options=options)
    driver.get(URL)
    time.sleep(3)

    links = driver.find_elements(By.CSS_SELECTOR, "li.acalog-course > span > a")
    print(f"Found {len(links)} courses")

    conn = sqlite3.connect("csuf_courses.db")
    conn.execute("""
        CREATE TABLE IF NOT EXISTS courses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            course_name TEXT,
            units TEXT,
            description TEXT,
            prereqs TEXT
        );
    """)

    for i in range(len(links)):
        # Page mutates after each click → re-find
        links = driver.find_elements(By.CSS_SELECTOR, "li.acalog-course > span > a")
        link = links[i]

        driver.execute_script("arguments[0].scrollIntoView(true);", link)
        time.sleep(0.4)
        link.click()
        time.sleep(1.2)

        soup = BeautifulSoup(driver.page_source, "html.parser")

        # Last opened course block
        expanded = soup.select("li.acalog-course-open table.td_dark")
        if not expanded:
            continue

        block = expanded[-1]

        # 🔑 EXACT MATCH TO YOUR HTML
        # td.coursepadding
        #   ├─ div (toolbar)
        #   └─ div (REAL content)
        content_divs = block.select("td.coursepadding > div")
        if len(content_divs) < 2:
            continue

        content_div = content_divs[1]  # second div = real content

        title_tag = content_div.select_one("h3")
        if not title_tag:
            continue

        title = title_tag.get_text(" ", strip=True)
        course_name = title.split("(")[0].strip()
        units = title.split("(")[-1].replace(")", "").strip()

        raw_text = content_div.get_text(" ", strip=True)
        cleaned_text = clean_text(raw_text)

        prereqs = extract_prereqs(cleaned_text)

        # Remove title + prereqs from description
        description = cleaned_text.replace(title, "").strip()
        if prereqs != "None":
            description = description.replace(prereqs, "").strip()

        conn.execute(
            "INSERT INTO courses (course_name, units, description, prereqs) VALUES (?, ?, ?, ?)",
            (course_name, units, description, prereqs)
        )

        print(f"✔ {course_name}")

    conn.commit()
    conn.close()
    driver.quit()

    print("\n✅ DONE — csuf_courses.db created")

# -----------------------------
if __name__ == "__main__":
    main()
