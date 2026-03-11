import os
import random
import mysql.connector
from dotenv import load_dotenv
from routes.db_operations import query_db, DB_CONFIG

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


def add_completed_course(user_id, course_id, term, year, grade):

    query = """
    INSERT INTO completed_courses (user_id, course_id, term, year, grade)
    VALUES (%s, %s, %s, %s, %s)
    """

    query_db(query, (user_id, course_id, term, year, grade))


# ----------------------------
# TEST FUNCTIONS
# ----------------------------

def test_get_completed_courses():

    results = get_completed_courses(1)

    print("\nCompleted Courses:")
    for row in results:
        print(row)


def test_add_completed_course():

    add_completed_course(1, 5, "Spring", 2026, "A")

    results = get_completed_courses(1)

    print("\nAfter Insert:")
    for row in results:
        print(row)


# ----------------------------
# RUN TESTS
# ----------------------------

if __name__ == "__main__":
    test_get_completed_courses()
    test_add_completed_course()