from collections import defaultdict
import random
import traceback

from routes.db_operations import query_db


FULL_TIME_MAX_UNITS = 12
PART_TIME_MAX_UNITS = 6
MAX_GENERATED_TERMS = 20


def debug_step(step_name, fn, *args, **kwargs):
    try:
        print(f"[PLAN DEBUG] START: {step_name}")
        result = fn(*args, **kwargs)
        print(f"[PLAN DEBUG] END: {step_name}")
        return result
    except Exception as e:
        print(f"[PLAN DEBUG] ERROR IN: {step_name}")
        print(f"[PLAN DEBUG] MESSAGE: {e}")
        traceback.print_exc()
        raise RuntimeError(f"{step_name} failed: {e}") from e


def generate_plan_for_user(user_id, major_id, catalog_year_id, starting_term, starting_year):
    user = debug_step("get_user_profile", get_user_profile, user_id)
    if not user:
        raise ValueError("User not found.")

    max_semester_units = debug_step(
        "get_max_semester_units",
        get_max_semester_units,
        user["enrollment_status"]
    )

    completed_course_ids = debug_step(
        "get_completed_course_ids",
        get_completed_course_ids,
        user_id
    )

    major_requirements_by_id = debug_step(
        "get_major_requirement_courses",
        get_major_requirement_courses,
        major_id,
        catalog_year_id
    )

    major_progress = debug_step(
        "initialize_major_progress",
        initialize_major_progress,
        major_requirements_by_id,
        completed_course_ids
    )

    ge_requirements = debug_step(
        "get_major_ge_requirements",
        get_major_ge_requirements,
        major_id,
        catalog_year_id
    )

    ge_courses_by_requirement = debug_step(
        "get_major_ge_courses",
        get_major_ge_courses,
        major_id,
        catalog_year_id
    )

    ge_progress = debug_step(
        "initialize_ge_progress",
        initialize_ge_progress,
        ge_requirements
    )

    debug_step(
        "apply_completed_courses_to_ge_progress",
        apply_completed_courses_to_ge_progress,
        completed_course_ids,
        ge_courses_by_requirement,
        ge_progress
    )

    semester_sequence = debug_step(
        "build_semester_sequence",
        build_semester_sequence,
        starting_term,
        starting_year,
        bool(user["available_winter"]),
        bool(user["available_summer"]),
        MAX_GENERATED_TERMS
    )

    selected_course_ids = set()
    semesters_output = []

    for term, year in semester_sequence:
        print(f"[PLAN DEBUG] BUILDING TERM: {term} {year}")

        semester_courses = []
        current_units = 0
        major_unit_target = max_semester_units / 2

        current_units = debug_step(
            f"fill_semester_with_major_courses ({term} {year})",
            fill_semester_with_major_courses,
            current_units=current_units,
            max_units=max_semester_units,
            target_major_units=major_unit_target,
            semester_courses=semester_courses,
            selected_course_ids=selected_course_ids,
            completed_course_ids=completed_course_ids,
            major_requirements_by_id=major_requirements_by_id,
            major_progress=major_progress,
        )

        current_units = debug_step(
            f"fill_semester_with_ge_courses ({term} {year})",
            fill_semester_with_ge_courses,
            current_units=current_units,
            max_units=max_semester_units,
            semester_courses=semester_courses,
            selected_course_ids=selected_course_ids,
            completed_course_ids=completed_course_ids,
            ge_requirements=ge_requirements,
            ge_courses_by_requirement=ge_courses_by_requirement,
            ge_progress=ge_progress,
        )

        current_units = debug_step(
            f"fill_remaining_with_major_courses ({term} {year})",
            fill_remaining_with_major_courses,
            current_units=current_units,
            max_units=max_semester_units,
            semester_courses=semester_courses,
            selected_course_ids=selected_course_ids,
            completed_course_ids=completed_course_ids,
            major_requirements_by_id=major_requirements_by_id,
            major_progress=major_progress,
        )

        if semester_courses:
            semesters_output.append({
                "term": term,
                "year": year,
                "courses": semester_courses,
            })

        if debug_step(
            "is_generation_complete",
            is_generation_complete,
            major_progress,
            ge_progress,
        ):
            print("[PLAN DEBUG] Generation complete.")
            break

        if not semester_courses:
            print("[PLAN DEBUG] No courses added this term. Stopping generation.")
            break

    if not semesters_output:
        raise ValueError("No eligible courses could be generated for this user.")

    plan_name = debug_step("build_default_plan_name", build_default_plan_name, user_id)

    plan_id = debug_step(
        "save_generated_plan",
        save_generated_plan,
        user_id,
        major_id,
        catalog_year_id,
        plan_name,
        semesters_output,
    )

    return {
        "plan_id": plan_id,
        "plan_name": plan_name,
        "semesters": semesters_output,
    }


def get_user_profile(user_id):
    return query_db(
        """
        SELECT
            id,
            enrollment_status,
            available_winter,
            available_summer
        FROM users
        WHERE id = %s
        """,
        (user_id,),
        one=True,
    )


def get_max_semester_units(enrollment_status):
    return FULL_TIME_MAX_UNITS if enrollment_status == "fulltime" else PART_TIME_MAX_UNITS


def get_completed_course_ids(user_id):
    rows = query_db(
        """
        SELECT course_id
        FROM completed_courses
        WHERE user_id = %s
        """,
        (user_id,),
    ) or []
    return {row["course_id"] for row in rows}


def get_major_requirement_courses(major_id, catalog_year_id):
    rows = query_db(
        """
        SELECT
            mr.id AS major_requirement_id,
            mr.requirement_name,
            mr.requirement_type,
            mr.required_units_min,
            mr.required_units_max,
            mrc.id AS mrc_id,
            mrc.choice_group,
            c.id AS course_id,
            c.course_code,
            c.course_name,
            c.units_min,
            c.units_max
        FROM major_requirement_courses mrc
        JOIN major_requirements mr
            ON mrc.major_requirement_id = mr.id
        JOIN courses c
            ON mrc.course_id = c.id
        WHERE mr.major_id = %s
          AND mr.catalog_year_id = %s
        ORDER BY mr.id ASC, mrc.id ASC
        """,
        (major_id, catalog_year_id),
    ) or []

    grouped = {}

    for row in rows:
        req_id = row["major_requirement_id"]

        if req_id not in grouped:
            grouped[req_id] = {
                "major_requirement_id": req_id,
                "requirement_name": row["requirement_name"],
                "requirement_type": row["requirement_type"],
                "required_units_min": float(row["required_units_min"] or 0),
                "required_units_max": float(row["required_units_max"] or 0),
                "courses": [],
            }

        grouped[req_id]["courses"].append({
            "mrc_id": row["mrc_id"],
            "choice_group": row["choice_group"],
            "course_id": row["course_id"],
            "course_code": row["course_code"],
            "course_name": row["course_name"],
            "units_min": row["units_min"],
            "units_max": row["units_max"],
        })

    return grouped


def initialize_major_progress(major_requirements_by_id, completed_course_ids):
    progress = {}

    for req_id, req in major_requirements_by_id.items():
        progress[req_id] = {
            "requirement_name": req["requirement_name"],
            "required_units_max": req["required_units_max"],
            "completed_units": 0.0,
            "selected_course_ids": set(),
            "choice_group_1_satisfied": False,
        }

        for course in req["courses"]:
            if course["course_id"] in completed_course_ids:
                units = get_course_units(course)
                progress[req_id]["completed_units"] += units
                progress[req_id]["selected_course_ids"].add(course["course_id"])

                if course["choice_group"] == 1:
                    progress[req_id]["choice_group_1_satisfied"] = True

    return progress


def get_major_ge_requirements(major_id, catalog_year_id):
    rows = query_db(
        """
        SELECT
            mgr.id,
            mgr.required_units_min,
            mgr.required_units_max,
            ga.area_code,
            ga.area_name
        FROM major_ge_requirements mgr
        JOIN ge_areas ga
            ON mgr.ge_area_id = ga.id
        WHERE mgr.major_id = %s
          AND mgr.catalog_year_id = %s
        ORDER BY mgr.id ASC
        """,
        (major_id, catalog_year_id),
    ) or []
    return rows


def get_major_ge_courses(major_id, catalog_year_id):
    rows = query_db(
        """
        SELECT
            mgc.major_ge_requirement_id,
            c.id AS course_id,
            c.course_code,
            c.course_name,
            c.units_min,
            c.units_max
        FROM major_ge_courses mgc
        JOIN major_ge_requirements mgr
            ON mgc.major_ge_requirement_id = mgr.id
        JOIN courses c
            ON mgc.course_id = c.id
        WHERE mgr.major_id = %s
          AND mgr.catalog_year_id = %s
        ORDER BY mgc.major_ge_requirement_id ASC, mgc.id ASC
        """,
        (major_id, catalog_year_id),
    ) or []

    grouped = defaultdict(list)
    for row in rows:
        grouped[row["major_ge_requirement_id"]].append(row)

    return grouped


def initialize_ge_progress(ge_requirements):
    progress = {}
    for req in ge_requirements:
        progress[req["id"]] = {
            "required_units_max": float(req["required_units_max"] or 0),
            "completed_units": 0.0,
            "area_code": req["area_code"],
            "area_name": req["area_name"],
        }
    return progress


def apply_completed_courses_to_ge_progress(completed_course_ids, ge_courses_by_requirement, ge_progress):
    for requirement_id, courses in ge_courses_by_requirement.items():
        for course in courses:
            if course["course_id"] in completed_course_ids:
                ge_progress[requirement_id]["completed_units"] += get_course_units(course)


def build_semester_sequence(starting_term, starting_year, available_winter, available_summer, max_terms):
    base_order = ["Winter", "Spring", "Summer", "Fall"]

    allowed_terms = []
    for term in base_order:
        if term == "Winter" and not available_winter:
            continue
        if term == "Summer" and not available_summer:
            continue
        allowed_terms.append(term)

    if starting_term not in allowed_terms:
        raise ValueError(f"Starting term '{starting_term}' is not allowed for this user.")

    start_index = allowed_terms.index(starting_term)

    sequence = []
    current_year = starting_year
    idx = start_index

    while len(sequence) < max_terms:
        term = allowed_terms[idx]
        sequence.append((term, current_year))

        idx += 1
        if idx >= len(allowed_terms):
            idx = 0
            current_year += 1

    return sequence


def fill_semester_with_major_courses(
    current_units,
    max_units,
    target_major_units,
    semester_courses,
    selected_course_ids,
    completed_course_ids,
    major_requirements_by_id,
    major_progress,
):
    for req_id, requirement in major_requirements_by_id.items():
        if current_units >= target_major_units:
            break

        current_units = try_fill_major_requirement(
            requirement=requirement,
            progress=major_progress[req_id],
            current_units=current_units,
            max_units=max_units,
            target_major_units=target_major_units,
            semester_courses=semester_courses,
            selected_course_ids=selected_course_ids,
            completed_course_ids=completed_course_ids,
        )

    return current_units


def fill_remaining_with_major_courses(
    current_units,
    max_units,
    semester_courses,
    selected_course_ids,
    completed_course_ids,
    major_requirements_by_id,
    major_progress,
):
    for req_id, requirement in major_requirements_by_id.items():
        if current_units >= max_units:
            break

        current_units = try_fill_major_requirement(
            requirement=requirement,
            progress=major_progress[req_id],
            current_units=current_units,
            max_units=max_units,
            target_major_units=max_units,
            semester_courses=semester_courses,
            selected_course_ids=selected_course_ids,
            completed_course_ids=completed_course_ids,
        )

    return current_units


def try_fill_major_requirement(
    requirement,
    progress,
    current_units,
    max_units,
    target_major_units,
    semester_courses,
    selected_course_ids,
    completed_course_ids,
):
    required_units_max = progress["required_units_max"]

    if required_units_max > 0 and progress["completed_units"] >= required_units_max:
        return current_units

    courses = requirement["courses"]

    # choice_group = 0 -> all required
    required_courses = [c for c in courses if c["choice_group"] == 0]
    for course in required_courses:
        if current_units >= target_major_units:
            return current_units

        if not is_course_eligible(
            course,
            current_units,
            max_units,
            selected_course_ids,
            completed_course_ids,
        ):
            continue

        add_course_to_semester(
            semester_courses,
            course,
            selected_course_ids,
            applied_to=requirement["requirement_name"]
        )
        units = get_course_units(course)
        current_units += units
        progress["completed_units"] += units
        progress["selected_course_ids"].add(course["course_id"])

        if required_units_max > 0 and progress["completed_units"] >= required_units_max:
            return current_units

    # choice_group = 1 -> choose one
    if not progress["choice_group_1_satisfied"]:
        one_choice_courses = [c for c in courses if c["choice_group"] == 1]
        eligible_one_choice = [
            c for c in one_choice_courses
            if is_course_eligible(
                c,
                current_units,
                max_units,
                selected_course_ids,
                completed_course_ids,
            )
        ]

        if eligible_one_choice and current_units < target_major_units:
            chosen = random.choice(eligible_one_choice)
            add_course_to_semester(
                semester_courses,
                chosen,
                selected_course_ids,
                applied_to=requirement["requirement_name"]
            )
            units = get_course_units(chosen)
            current_units += units
            progress["completed_units"] += units
            progress["selected_course_ids"].add(chosen["course_id"])
            progress["choice_group_1_satisfied"] = True

            if required_units_max > 0 and progress["completed_units"] >= required_units_max:
                return current_units

    # choice_group = 99 -> keep selecting until required_units_max is hit
    repeatable_courses = [c for c in courses if c["choice_group"] == 99]

    while (
        repeatable_courses
        and current_units < target_major_units
        and (required_units_max == 0 or progress["completed_units"] < required_units_max)
    ):
        eligible_repeatable = [
            c for c in repeatable_courses
            if is_course_eligible(
                c,
                current_units,
                max_units,
                selected_course_ids,
                completed_course_ids,
            )
        ]

        if not eligible_repeatable:
            break

        fitting_repeatable = eligible_repeatable
        if required_units_max > 0:
            fitting_repeatable = [
                c for c in eligible_repeatable
                if progress["completed_units"] + get_course_units(c) <= required_units_max
            ]

        if not fitting_repeatable:
            break

        chosen = random.choice(fitting_repeatable)
        units = get_course_units(chosen)

        add_course_to_semester(
            semester_courses,
            chosen,
            selected_course_ids,
            applied_to=requirement["requirement_name"]
        )
        current_units += units
        progress["completed_units"] += units
        progress["selected_course_ids"].add(chosen["course_id"])

    return current_units


def fill_semester_with_ge_courses(
    current_units,
    max_units,
    semester_courses,
    selected_course_ids,
    completed_course_ids,
    ge_requirements,
    ge_courses_by_requirement,
    ge_progress,
):
    while current_units < max_units:
        valid_options = []

        for req in ge_requirements:
            requirement_id = req["id"]

            # Skip already satisfied GE requirements
            if ge_progress[requirement_id]["completed_units"] >= ge_progress[requirement_id]["required_units_max"]:
                continue

            for course in ge_courses_by_requirement.get(requirement_id, []):
                if not is_course_eligible(
                    course,
                    current_units,
                    max_units,
                    selected_course_ids,
                    completed_course_ids,
                ):
                    continue

                # Do not overshoot the GE unit cap for that requirement
                if (
                    ge_progress[requirement_id]["completed_units"] + get_course_units(course)
                    > ge_progress[requirement_id]["required_units_max"]
                ):
                    continue

                valid_options.append((requirement_id, course))

        # If nothing valid can be added, stop the GE fill loop
        if not valid_options:
            break

        requirement_id, course = random.choice(valid_options)

        add_course_to_semester(
            semester_courses,
            course,
            selected_course_ids,
            applied_to=f"GE {ge_progress[requirement_id]['area_code']}"
        )

        units = get_course_units(course)
        current_units += units
        ge_progress[requirement_id]["completed_units"] += units

    return current_units


def get_course_units(course):
    return float(course["units_max"])


def is_course_eligible(course, current_units, max_units, selected_course_ids, completed_course_ids):
    course_id = course["course_id"]
    units = get_course_units(course)

    if course_id in completed_course_ids:
        return False

    if course_id in selected_course_ids:
        return False

    if current_units + units > max_units:
        return False

    return True


def add_course_to_semester(semester_courses, course, selected_course_ids, applied_to=None):
    semester_courses.append({
        "course_id": course["course_id"],
        "code": course["course_code"],
        "title": course["course_name"],
        "units": get_course_units(course),
        "applied_to": applied_to,
    })
    selected_course_ids.add(course["course_id"])


def are_major_requirements_complete(major_progress):
    for progress in major_progress.values():
        required_units_max = progress["required_units_max"]

        if required_units_max > 0 and progress["completed_units"] < required_units_max:
            return False

    return True


def is_generation_complete(major_progress, ge_progress):
    satisfied_major = are_major_requirements_complete(major_progress)

    satisfied_ge = all(
        info["completed_units"] >= info["required_units_max"]
        for info in ge_progress.values()
    )

    return satisfied_major and satisfied_ge


def build_default_plan_name(user_id):
    row = query_db(
        """
        SELECT COUNT(*) AS total
        FROM course_plans
        WHERE user_id = %s
        """,
        (user_id,),
        one=True,
    )
    next_number = (row["total"] if row else 0) + 1
    return f"Generated Plan {next_number}"


def save_generated_plan(user_id, major_id, catalog_year_id, plan_name, semesters_output):
    query_db(
        """
        INSERT INTO course_plans (user_id, major_id, catalog_year_id, plan_name)
        VALUES (%s, %s, %s, %s)
        """,
        (user_id, major_id, catalog_year_id, plan_name),
    )

    new_plan = query_db(
        """
        SELECT id
        FROM course_plans
        WHERE user_id = %s AND plan_name = %s
        ORDER BY id DESC
        LIMIT 1
        """,
        (user_id, plan_name),
        one=True,
    )

    if not new_plan:
        raise ValueError("Plan inserted, but could not retrieve its ID.")

    plan_id = new_plan["id"]

    for semester in semesters_output:
        for course in semester["courses"]:
            query_db(
                """
                INSERT INTO plan_courses (plan_id, course_id, term, year, applied_to)
                VALUES (%s, %s, %s, %s, %s)
                """,
                (
                    plan_id,
                    course["course_id"],
                    semester["term"],
                    semester["year"],
                    course["applied_to"],
                ),
            )

    return plan_id


# if __name__ == "__main__":
#     try:
#         print("\n=== RUNNING PLAN GENERATOR TEST ===\n")

#         TEST_USER_ID = 1
#         TEST_MAJOR_ID = 1
#         TEST_CATALOG_YEAR_ID = 1
#         TEST_START_TERM = "Fall"
#         TEST_START_YEAR = 2026

#         result = generate_plan_for_user(
#             user_id=TEST_USER_ID,
#             major_id=TEST_MAJOR_ID,
#             catalog_year_id=TEST_CATALOG_YEAR_ID,
#             starting_term=TEST_START_TERM,
#             starting_year=TEST_START_YEAR,
#         )

#         print("\n=== GENERATED PLAN SUCCESS ===\n")
#         print(result)

#     except Exception as e:
#         print("\n=== PLAN GENERATION FAILED ===\n")
#         print(e)