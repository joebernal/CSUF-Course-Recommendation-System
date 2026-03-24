import os
import random
import mysql.connector
from dotenv import load_dotenv
from routes.db_operations import query_db, DB_CONFIG
from create_plan import add_random_ge_course_to_plan
from create_plan import add_completed_course

load_dotenv()


# ----------------------------
# ACTUAL FUNCTIONS
# ----------------------------

def get_completed_courses(user_id):

    query = """
    SELECT *
    FROM completed_courses
    WHERE user_id = %s
    """

    return query_db(query, (user_id,))

# ----------------------------
# TEST FUNCTIONS
# ----------------------------

def test_get_completed_courses():

    results = get_completed_courses(1)

    print("\nCompleted Courses:")
    for row in results:
        print(row)


def test_random_ge():

    result = add_random_ge_course_to_plan(1, 1, "Fall", 2026)

    print("\nRandom GE Result:")
    print(result)


# ----------------------------
# RUN TESTS
# ----------------------------

if __name__ == "__main__":
    test_get_completed_courses()
    test_random_ge()