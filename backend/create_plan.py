import random
from routes.db_operations import query_db

# -----------------------------
# HELPERS
# -----------------------------

ALLOWED_ELECTIVES = [
    "BIOL 101", "BIOL 101L",
    "BIOL 151", "BIOL 152",
    "CHEM 120A", "CHEM 120B",
    "CHEM 123", "CHEM 125",
    "GEOL 101", "GEOL 101L",
    "GEOL 201", "GEOL 201L",
    "MATH 250A", "MATH 250B",
    "PHYS 225", "PHYS 225L",
    "PHYS 226", "PHYS 226L",
    "PHYS 227", "PHYS 227L"
]

def get_ge_units_completed(plan_id, ge_area_code):

    result = query_db(
        """
        SELECT COUNT(*) as count
        FROM plan_courses
        WHERE plan_id = %s AND applied_to = %s
        """,
        (plan_id, f"GE {ge_area_code}"),
        one=True
    )

    return result["count"] if result else 0

def get_paired_course(course_id):

    pair = query_db(
        """
        SELECT paired_course_id
        FROM course_pairs
        WHERE course_id = %s
        """,
        (course_id,),
        one=True
    )

    if pair:
        return pair["paired_course_id"]

    reverse = query_db(
        """
        SELECT course_id
        FROM course_pairs
        WHERE paired_course_id = %s
        """,
        (course_id,),
        one=True
    )

    if reverse:
        return reverse["course_id"]

    return None


# -----------------------------
# USER INFORMATION
# -----------------------------

def get_user_full_name(user_id):
    return query_db(
        """
        SELECT full_name
        FROM users
        WHERE id = %s
        """,
        (user_id,),
        one=True
    )


def get_user_preferences(user_id):
    return query_db(
        """
        SELECT 
            enrollment_status,
            available_winter,
            available_summer
        FROM users
        WHERE id = %s
        """,
        (user_id,),
        one=True
    )


def get_enrollment_status(user_id):

    row = query_db(
        """
        SELECT enrollment_status
        FROM users
        WHERE id = %s
        """,
        (user_id,),
        one=True
    )

    if row is None:
        raise ValueError("User not found")

    status = row["enrollment_status"]

    if status == "fulltime":
        return {"status": "fulltime", "max_units": 15, "min_units": 12}

    if status == "parttime":
        return {"status": "parttime", "max_units": 9, "min_units": 3}

    raise ValueError("Invalid enrollment status")


def get_available_terms(user_id):

    row = query_db(
        """
        SELECT available_winter, available_summer
        FROM users
        WHERE id = %s
        """,
        (user_id,),
        one=True
    )

    if row is None:
        raise ValueError("User not found")

    terms = ["Fall", "Spring"]

    if row["available_winter"]:
        terms.append("Winter")

    if row["available_summer"]:
        terms.append("Summer")

    return terms


# -----------------------------
# USER PREFERENCES
# -----------------------------

def get_preferred_language(user_id):

    row = query_db(
        """
        SELECT preferred_language
        FROM user_preferences
        WHERE user_id = %s
        """,
        (user_id,),
        one=True
    )

    if row is None or row["preferred_language"] is None:
        return None

    return row["preferred_language"].strip().lower()


def get_career_interest(user_id):
    return query_db(
        """
        SELECT career_interest
        FROM user_preferences
        WHERE user_id = %s
        """,
        (user_id,),
        one=True
    )


# -----------------------------
# COURSE PROGRESS
# -----------------------------

def get_completed_courses(user_id):

    return query_db(
        """
        SELECT course_id
        FROM completed_courses
        WHERE user_id = %s
        """,
        (user_id,)
    )


def add_completed_course(user_id, course_id, term, year, grade):

    # Check if already exists
    existing = query_db(
        """
        SELECT id
        FROM completed_courses
        WHERE user_id = %s AND course_id = %s
        """,
        (user_id, course_id),
        one=True
    )

    if existing:
        print("Course already completed, skipping insert")
        return

    # Insert if not exists
    query_db(
        """
        INSERT INTO completed_courses (user_id, course_id, term, year, grade)
        VALUES (%s, %s, %s, %s, %s)
        """,
        (user_id, course_id, term, year, grade)
    )

    print("Course added successfully")


def remove_completed_course(user_id, course_id):

    query_db(
        """
        DELETE FROM completed_courses
        WHERE user_id = %s AND course_id = %s
        """,
        (user_id, course_id)
    )


# -----------------------------
# COURSE PLANNING
# -----------------------------

def add_course_to_plan(plan_id, course_id, term, year, applied_to=None, note=None):
    existing = query_db(
        """
        SELECT id
        FROM plan_courses
        WHERE plan_id = %s AND course_id = %s AND term = %s AND year = %s
        """,
        (plan_id, course_id, term, year),
        one=True
    )

    if existing:
        print(f"Skipping duplicate course {course_id}")
        return

    query_db(
        """
        INSERT INTO plan_courses (plan_id, course_id, term, year, applied_to, note)
        VALUES (%s, %s, %s, %s, %s, %s)
        """,
        (plan_id, course_id, term, year, applied_to, note)
    )



def add_random_ge_course_to_plan(plan_id, user_id, term, year):

    # Get GE area
    ge_areas = query_db(
        """
        SELECT DISTINCT ga.id, ga.area_code, ga.area_name
        FROM ge_areas ga
        JOIN major_ge_requirements mgr ON ga.id = mgr.ge_area_id
        JOIN major_ge_courses mgc ON mgr.id = mgc.major_ge_requirement_id
        """
    )

    if not ge_areas:
        raise ValueError("No GE areas found")
    
    print("DEBUG GE AREAS:", [a["area_code"] for a in ge_areas])

    # Random GE area
    selected_area = random.choice(ge_areas)
    ge_area_id = selected_area["id"]
    ge_code = selected_area["area_code"]

    units = get_ge_units_completed(plan_id, ge_code)

    #required_units_per_ge = {
    #"2A": ,
    #"4": ,
    #"B1": 
    #}

    # Prefer courses wo prereqs
    courses = query_db(
        """
        SELECT c.id, c.course_code
        FROM major_ge_courses mgc
        JOIN courses c ON mgc.course_id = c.id
        JOIN major_ge_requirements mgr 
            ON mgc.major_ge_requirement_id = mgr.id
        WHERE mgr.ge_area_id = %s
        AND c.id NOT IN (
            SELECT course_id
            FROM completed_courses
            WHERE user_id = %s
        )
        AND c.id NOT IN (
            SELECT DISTINCT cr.course_id
            FROM course_requirements cr
        )
        """,
        (ge_area_id, user_id)
    )

    if not courses:
        courses = query_db(
            """
            SELECT c.id, c.course_code
            FROM major_ge_courses mgc
            JOIN courses c ON mgc.course_id = c.id
            JOIN major_ge_requirements mgr 
                ON mgc.major_ge_requirement_id = mgr.id
            WHERE mgr.ge_area_id = %s
            AND c.id NOT IN (
                SELECT course_id
                FROM completed_courses
                WHERE user_id = %s
            )
            """,
            (ge_area_id, user_id)
        )

    if not courses:
        raise ValueError("No available courses for this GE area")

    # Pick random course
    selected_course = random.choice(courses)

    # Add main course
    add_course_to_plan(
        plan_id,
        selected_course["id"],
        term,
        year,
        applied_to=f"GE {ge_code}",
        note=f"GE selection from {selected_area['area_name']}"
    )

    # Handle pairs
    paired = get_paired_course(selected_course["id"])

    if paired:
        add_course_to_plan(
            plan_id,
            paired,
            term,
            year,
            applied_to=f"GE {ge_code}",
            note="Paired lab course"
        )

    return {
        "ge_area": ge_code,
        "ge_area_name": selected_area["area_name"],
        "course_code": selected_course["course_code"],
        "paired_added": bool(paired)
    }


def add_math_and_science_requirements(plan_id, user_id, term, year, max_units_per_term=6):

    # Math Courses
    math_sequence = [
        "MATH 150A",
        "MATH 150B",
        "MATH 250A",
        "MATH 250B",
        "MATH 338",
    ]

    completed = {
        c["course_id"] for c in query_db(
            "SELECT course_id FROM completed_courses WHERE user_id = %s",
            (user_id,)
        )
    }

    planned = {
        c["course_id"] for c in query_db(
            "SELECT course_id FROM plan_courses WHERE plan_id = %s",
            (plan_id,)
        )
    }

    taken_or_planned = completed.union(planned)

    math_added = None

    for course_code in math_sequence:
        course = query_db(
            "SELECT id, course_code FROM courses WHERE course_code = %s",
            (course_code,),
            one=True
        )

        if not course:
            continue

        if course["id"] in taken_or_planned:
            continue

        if not check_prerequisites(user_id, course["id"]):
            continue

        add_course_to_plan(
            plan_id,
            course["id"],
            term,
            year,
            applied_to="Math Requirement",
            note="Sequential math requirement"
        )

        math_added = course["course_code"]
        taken_or_planned.add(course["id"])
        break

    #Math/Science Electives

    elective_courses = query_db(
        f"""
        SELECT id, course_code, units_max, has_lab, includes_lab
        FROM courses
        WHERE course_code IN ({','.join(['%s'] * len(ALLOWED_ELECTIVES))})
        """,
        tuple(ALLOWED_ELECTIVES)
    )
    
    #elective_courses = query_db(
    #"""
    #SELECT id, course_code, units_max, has_lab, includes_lab
    #FROM courses
    #WHERE course_code = 'BIOL 101'
    #"""
    #)

    selected_units = 0
    electives_added = []

    random.shuffle(elective_courses)

    for course in elective_courses:

        if selected_units >= max_units_per_term:
            break

        # Only pick lectures first
        if course["course_code"].endswith("L"):
            continue

        if course["id"] in taken_or_planned:

            paired_id = get_paired_course(course["id"])

            if paired_id and paired_id not in taken_or_planned:

                print("FIXING MISSING LAB FOR:", course["course_code"])

                lab = query_db(
                    "SELECT id, course_code, units_max FROM courses WHERE id = %s",
                    (paired_id,),
                    one=True
                )

                if lab:
                    add_course_to_plan(
                        plan_id,
                        lab["id"],
                        term,
                        year,
                        applied_to="Science/Math Elective",
                        note="Auto-added missing lab"
                    )

                    taken_or_planned.add(lab["id"])
                    electives_added.append(lab["course_code"])

            continue

        if not check_prerequisites(user_id, course["id"]):
            continue

        course_units = float(course["units_max"])

        paired_id = get_paired_course(course["id"])
        print("PAIR RESULT:", course["course_code"], "->", paired_id)

        if paired_id:

        # non-lab
            if selected_units + course_units > max_units_per_term:
                continue

        existing = query_db(
            """
            SELECT id FROM plan_courses
            WHERE plan_id = %s AND course_id = %s AND term = %s AND year = %s
            """,
            (plan_id, course["id"], term, year),
            one=True
        )

        if existing:
            continue

        add_course_to_plan(
            plan_id,
            course["id"],
            term,
            year,
            applied_to="Science/Math Elective",
            note="Random elective selection"
        )

        selected_units += course_units
        electives_added.append(course["course_code"])

        taken_or_planned.add(course["id"])

    return {
        "status": "success",
        "math_added": math_added,
        "electives_added": electives_added,
        "elective_units": selected_units
    }

# -----------------------------
# PREREQUISITE VALIDATION
# -----------------------------

def check_prerequisites(user_id, course_id):

    course_info = query_db(
    "SELECT course_code FROM courses WHERE id = %s",
    (course_id,),
    one=True
    )

    course_code = course_info["course_code"]

    # allow intro courses (100-level)
    if any(char.isdigit() for char in course_code):
        number = int(''.join(filter(str.isdigit, course_code)))
        if number < 200:
            return True

    prereqs = query_db(
        """
        SELECT item_type, required_course_id
        FROM course_requirement_items
        WHERE course_requirement_id IN (
            SELECT id FROM course_requirements WHERE course_id = %s
        )
        """,
        (course_id,)
    )

    course_prereqs = [
        p["required_course_id"]
        for p in prereqs
        if p["item_type"] == "course" and p["required_course_id"] is not None
    ]

    if not course_prereqs:
        print("NO REAL PREREQS → ALLOW")
        return True

    completed = {
        c["course_id"] for c in query_db(
            "SELECT course_id FROM completed_courses WHERE user_id = %s",
            (user_id,)
        )
    }

    print("COMPLETED:", completed)

    for prereq_id in course_prereqs:
        if prereq_id not in completed:
            print("MISSING PREREQ:", prereq_id)
            return False

    print("ALL PREREQS MET")
    return True