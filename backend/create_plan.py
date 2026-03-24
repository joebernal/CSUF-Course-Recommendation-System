import random
from routes.db_operations import query_db


# -----------------------------
# HELPERS
# -----------------------------

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
        SELECT paired_course_id AS paired_id
        FROM course_pairs
        WHERE course_id = %s

        UNION

        SELECT course_id AS paired_id
        FROM course_pairs
        WHERE paired_course_id = %s
        """,
        (course_id, course_id),
        one=True
    )

    return pair["paired_id"] if pair else None

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

# -----------------------------
# PREREQUISITE VALIDATION
# -----------------------------

def check_prerequisites(user_id, course_id):

    prereqs = query_db(
        """
        SELECT cri.required_course_id
        FROM course_requirements cr
        JOIN course_requirement_items cri
            ON cr.id = cri.requirement_id
        WHERE cr.course_id = %s
        """,
        (course_id,)
    )

    completed = get_completed_courses(user_id)

    completed_set = {c["course_id"] for c in completed}

    for prereq in prereqs:
        if prereq["required_course_id"] not in completed_set:
            return False

    return True