# -----------------------------
# DATABASE HELPER
# -----------------------------

def query_db(query, args=(), one=False):
    db = get_db()
    cur = db.execute(query, args)
    db.commit()
    rv = cur.fetchall()
    cur.close()
    return (rv[0] if rv else None) if one else rv


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

    query_db(
        """
        INSERT INTO completed_courses (user_id, course_id, term, year, grade)
        VALUES (%s, %s, %s, %s, %s)
        """,
        (user_id, course_id, term, year, grade)
    )


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

def add_course_to_plan(plan_id, course_id, semester, year):

    query_db(
        """
        INSERT INTO plan_courses (plan_id, course_id, semester, year)
        VALUES (%s, %s, %s, %s)
        """,
        (plan_id, course_id, semester, year)
    )


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