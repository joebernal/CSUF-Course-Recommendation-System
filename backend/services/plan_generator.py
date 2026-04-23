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

    course_to_major_requirement_map = debug_step(
        "build_course_to_major_requirement_map",
        build_course_to_major_requirement_map,
        major_requirements_by_id
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

    all_course_ids = debug_step(
        "collect_all_relevant_course_ids",
        collect_all_relevant_course_ids,
        major_requirements_by_id,
        ge_courses_by_requirement
    )

    prerequisite_data_by_course = debug_step(
        "get_prerequisite_data_for_courses",
        get_prerequisite_data_for_courses,
        all_course_ids
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
            prerequisite_data_by_course=prerequisite_data_by_course,
            course_to_major_requirement_map=course_to_major_requirement_map,
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
            prerequisite_data_by_course=prerequisite_data_by_course,
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
            prerequisite_data_by_course=prerequisite_data_by_course,
            course_to_major_requirement_map=course_to_major_requirement_map,
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

    print("\n[PLAN DEBUG] FINAL MAJOR PROGRESS")
    for req_id, progress in major_progress.items():
        print(
            f"  {req_id} | {progress['requirement_name']} | "
            f"{progress['completed_units']} / {progress['required_units_max']}"
        )

    print("\n[PLAN DEBUG] FINAL GE PROGRESS")
    for req_id, progress in ge_progress.items():
        print(
            f"  {req_id} | GE {progress['area_code']} | "
            f"{progress['completed_units']} / {progress['required_units_max']}"
        )

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


def build_course_to_major_requirement_map(major_requirements_by_id):
    course_to_requirements = defaultdict(list)

    for req_id, requirement in major_requirements_by_id.items():
        for course in requirement["courses"]:
            course_to_requirements[course["course_id"]].append({
                "major_requirement_id": req_id,
                "requirement_name": requirement["requirement_name"],
                "requirement_type": requirement["requirement_type"],
                "required_units_max": requirement["required_units_max"],
                "choice_group": course["choice_group"],
            })

    return dict(course_to_requirements)


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


def collect_all_relevant_course_ids(major_requirements_by_id, ge_courses_by_requirement):
    course_ids = set()

    for requirement in major_requirements_by_id.values():
        for course in requirement["courses"]:
            course_ids.add(course["course_id"])

    for courses in ge_courses_by_requirement.values():
        for course in courses:
            course_ids.add(course["course_id"])

    return course_ids


def get_prerequisite_data_for_courses(course_ids):
    if not course_ids:
        return {}

    placeholders = ",".join(["%s"] * len(course_ids))

    rows = query_db(
        f"""
        SELECT
            cr.course_id,
            cr.requirement_type,
            cr.note AS requirement_note,
            cri.group_number,
            cri.item_type,
            cri.required_course_id,
            cri.exam_name,
            cri.item_text,
            c.course_code AS required_course_code,
            c.course_name AS required_course_name,
            c.units_min AS required_course_units_min,
            c.units_max AS required_course_units_max
        FROM course_requirements cr
        JOIN course_requirement_items cri
            ON cri.course_requirement_id = cr.id
        LEFT JOIN courses c
            ON cri.required_course_id = c.id
        WHERE cr.course_id IN ({placeholders})
        ORDER BY cr.course_id, cr.requirement_type, cri.group_number, cri.id
        """,
        tuple(course_ids),
    ) or []

    result = defaultdict(lambda: {
        "prerequisite": defaultdict(list),
        "corequisite": defaultdict(list),
        "restriction": defaultdict(list),
    })

    for row in rows:
        requirement_type = row["requirement_type"]
        if requirement_type not in {"prerequisite", "corequisite", "restriction"}:
            continue

        result[row["course_id"]][requirement_type][row["group_number"]].append({
            "item_type": row["item_type"],
            "required_course_id": row["required_course_id"],
            "required_course_code": row["required_course_code"],
            "required_course_name": row["required_course_name"],
            "required_course_units_min": row["required_course_units_min"],
            "required_course_units_max": row["required_course_units_max"],
            "exam_name": row["exam_name"],
            "item_text": row["item_text"],
            "requirement_note": row["requirement_note"],
        })

    return result


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
    prerequisite_data_by_course,
    course_to_major_requirement_map,
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
            prerequisite_data_by_course=prerequisite_data_by_course,
            course_to_major_requirement_map=course_to_major_requirement_map,
            major_progress=major_progress,
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
    prerequisite_data_by_course,
    course_to_major_requirement_map,
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
            prerequisite_data_by_course=prerequisite_data_by_course,
            course_to_major_requirement_map=course_to_major_requirement_map,
            major_progress=major_progress,
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
    prerequisite_data_by_course,
    course_to_major_requirement_map,
    major_progress,
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

        current_units = try_add_major_course_or_prerequisite(
            course=course,
            current_units=current_units,
            max_units=max_units,
            target_major_units=target_major_units,
            semester_courses=semester_courses,
            selected_course_ids=selected_course_ids,
            completed_course_ids=completed_course_ids,
            prerequisite_data_by_course=prerequisite_data_by_course,
            course_to_major_requirement_map=course_to_major_requirement_map,
            major_progress=major_progress,
        )

        if required_units_max > 0 and progress["completed_units"] >= required_units_max:
            return current_units

    # choice_group = 1 -> choose one
    if not progress["choice_group_1_satisfied"]:
        one_choice_courses = [c for c in courses if c["choice_group"] == 1]

        for candidate in one_choice_courses:
            if current_units >= target_major_units:
                break

            before_ids = set(progress["selected_course_ids"])
            before_units = progress["completed_units"]

            current_units = try_add_major_course_or_prerequisite(
                course=candidate,
                current_units=current_units,
                max_units=max_units,
                target_major_units=target_major_units,
                semester_courses=semester_courses,
                selected_course_ids=selected_course_ids,
                completed_course_ids=completed_course_ids,
                prerequisite_data_by_course=prerequisite_data_by_course,
                course_to_major_requirement_map=course_to_major_requirement_map,
                major_progress=major_progress,
            )

            if progress["selected_course_ids"] != before_ids or progress["completed_units"] != before_units:
                progress["choice_group_1_satisfied"] = True
                break

            if required_units_max > 0 and progress["completed_units"] >= required_units_max:
                return current_units

    # choice_group = 99 -> keep selecting until required_units_max is hit
    repeatable_courses = [c for c in courses if c["choice_group"] == 99]

    safety_counter = 0
    while (
        repeatable_courses
        and current_units < target_major_units
        and (required_units_max == 0 or progress["completed_units"] < required_units_max)
    ):
        safety_counter += 1
        if safety_counter > 100:
            raise RuntimeError(f"choice_group 99 loop exceeded safety limit for {requirement['requirement_name']}")

        candidate = random.choice(repeatable_courses)

        before_ids = set(progress["selected_course_ids"])
        before_units = progress["completed_units"]
        before_semester_count = len(semester_courses)

        current_units = try_add_major_course_or_prerequisite(
            course=candidate,
            current_units=current_units,
            max_units=max_units,
            target_major_units=target_major_units,
            semester_courses=semester_courses,
            selected_course_ids=selected_course_ids,
            completed_course_ids=completed_course_ids,
            prerequisite_data_by_course=prerequisite_data_by_course,
            course_to_major_requirement_map=course_to_major_requirement_map,
            major_progress=major_progress,
        )

        # If nothing changed, remove this candidate from the repeatable pool for this pass
        if (
            progress["selected_course_ids"] == before_ids
            and progress["completed_units"] == before_units
            and len(semester_courses) == before_semester_count
        ):
            repeatable_courses = [c for c in repeatable_courses if c["course_id"] != candidate["course_id"]]

        if required_units_max > 0 and progress["completed_units"] >= required_units_max:
            return current_units

    return current_units


def try_add_major_course_or_prerequisite(
    course,
    current_units,
    max_units,
    target_major_units,
    semester_courses,
    selected_course_ids,
    completed_course_ids,
    prerequisite_data_by_course,
    course_to_major_requirement_map,
    major_progress,
):
    if current_units >= target_major_units:
        return current_units

    if is_course_eligible(
        course=course,
        current_units=current_units,
        max_units=max_units,
        selected_course_ids=selected_course_ids,
        completed_course_ids=completed_course_ids,
        prerequisite_data_by_course=prerequisite_data_by_course,
    ):
        return add_major_course_to_semester(
            course=course,
            current_units=current_units,
            semester_courses=semester_courses,
            selected_course_ids=selected_course_ids,
            course_to_major_requirement_map=course_to_major_requirement_map,
            major_progress=major_progress,
        )

    prerequisite_course = resolve_deepest_unmet_major_prerequisite(
        target_course=course,
        completed_course_ids=completed_course_ids,
        selected_course_ids=selected_course_ids,
        prerequisite_data_by_course=prerequisite_data_by_course,
        visited=None,
    )

    if not prerequisite_course:
        return current_units

    if is_course_eligible(
        course=prerequisite_course,
        current_units=current_units,
        max_units=max_units,
        selected_course_ids=selected_course_ids,
        completed_course_ids=completed_course_ids,
        prerequisite_data_by_course=prerequisite_data_by_course,
    ):
        print(
            f"[PLAN DEBUG] Adding prerequisite {prerequisite_course['course_code']} "
            f"before target {course['course_code']}"
        )
        return add_major_course_to_semester(
            course=prerequisite_course,
            current_units=current_units,
            semester_courses=semester_courses,
            selected_course_ids=selected_course_ids,
            course_to_major_requirement_map=course_to_major_requirement_map,
            major_progress=major_progress,
        )

    return current_units


def resolve_deepest_unmet_major_prerequisite(
    target_course,
    completed_course_ids,
    selected_course_ids,
    prerequisite_data_by_course,
    visited=None,
):
    if visited is None:
        visited = set()

    course_id = target_course["course_id"]

    if course_id in visited:
        print(f"[PLAN DEBUG] Prerequisite cycle detected at course_id={course_id}")
        return None

    visited.add(course_id)

    prerequisite_groups = prerequisite_data_by_course.get(course_id, {}).get("prerequisite", {})

    if not prerequisite_groups:
        return None

    for group_number in sorted(prerequisite_groups.keys()):
        group_items = prerequisite_groups[group_number]

        # If any item in the group is already satisfied, this group is satisfied
        if is_prerequisite_group_satisfied(group_items, completed_course_ids, selected_course_ids):
            continue

        course_items = [item for item in group_items if item["item_type"] == "course" and item["required_course_id"]]
        exam_items = [item for item in group_items if item["item_type"] == "exam"]
        text_items = [item for item in group_items if item["item_type"] == "text"]

        # for item in exam_items:
        #     print(
        #         f"[PLAN DEBUG] Exam prerequisite logged but not enforced for course_id={course_id}: "
        #         f"{item['exam_name']}"
        #     )

        # for item in text_items:
        #     print(
        #         f"[PLAN DEBUG] Text prerequisite logged but not enforced for course_id={course_id}: "
        #         f"{item['item_text']}"
        #     )

        if not course_items:
            return None

        # Deterministic choice for now: first course option in the OR group
        chosen_item = course_items[0]
        prereq_course = {
            "course_id": chosen_item["required_course_id"],
            "course_code": chosen_item["required_course_code"],
            "course_name": chosen_item["required_course_name"],
            "units_min": chosen_item["required_course_units_min"],
            "units_max": chosen_item["required_course_units_max"],
        }

        deeper = resolve_deepest_unmet_major_prerequisite(
            target_course=prereq_course,
            completed_course_ids=completed_course_ids,
            selected_course_ids=selected_course_ids,
            prerequisite_data_by_course=prerequisite_data_by_course,
            visited=visited,
        )

        if deeper:
            return deeper

        if prereq_course["course_id"] not in completed_course_ids and prereq_course["course_id"] not in selected_course_ids:
            return prereq_course

    return None


def is_prerequisite_group_satisfied(group_items, completed_course_ids, selected_course_ids):
    for item in group_items:
        if item["item_type"] == "course" and item["required_course_id"]:
            if item["required_course_id"] in completed_course_ids or item["required_course_id"] in selected_course_ids:
                return True
        # elif item["item_type"] == "exam":
        #     print(f"[PLAN DEBUG] Exam prerequisite encountered but not enforced: {item['exam_name']}")
        # elif item["item_type"] == "text":
        #     print(f"[PLAN DEBUG] Text prerequisite encountered but not enforced: {item['item_text']}")

    return False


def resolve_major_requirement_for_course(course_id, course_to_major_requirement_map, major_progress):
    options = course_to_major_requirement_map.get(course_id, [])

    if not options:
        return None

    best_option = None
    best_remaining_units = -1

    for option in options:
        req_id = option["major_requirement_id"]
        progress = major_progress[req_id]
        remaining_units = progress["required_units_max"] - progress["completed_units"]

        if remaining_units > 0 and remaining_units > best_remaining_units:
            best_option = option
            best_remaining_units = remaining_units

    if best_option:
        return best_option

    return options[0]


def add_major_course_to_semester(
    course,
    current_units,
    semester_courses,
    selected_course_ids,
    course_to_major_requirement_map,
    major_progress,
):
    resolved_requirement = resolve_major_requirement_for_course(
        course_id=course["course_id"],
        course_to_major_requirement_map=course_to_major_requirement_map,
        major_progress=major_progress,
    )

    if resolved_requirement is None:
        applied_to = "Prerequisite Support"
        print(
            f"[PLAN DEBUG] No major requirement mapping found for {course['course_code']}. "
            f"Using applied_to='{applied_to}'"
        )
    else:
        req_id = resolved_requirement["major_requirement_id"]
        applied_to = resolved_requirement["requirement_name"]

        major_progress[req_id]["completed_units"] += get_course_units(course)
        major_progress[req_id]["selected_course_ids"].add(course["course_id"])

        if resolved_requirement["choice_group"] == 1:
            major_progress[req_id]["choice_group_1_satisfied"] = True

        print(
            f"[PLAN DEBUG] Counting {course['course_code']} toward '{applied_to}'"
        )

    add_course_to_semester(
        semester_courses,
        course,
        selected_course_ids,
        applied_to=applied_to
    )

    current_units += get_course_units(course)
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
    prerequisite_data_by_course,
):
    while current_units < max_units:
        valid_options = []

        for req in ge_requirements:
            requirement_id = req["id"]

            if ge_progress[requirement_id]["completed_units"] >= ge_progress[requirement_id]["required_units_max"]:
                continue

            for course in ge_courses_by_requirement.get(requirement_id, []):
                if not is_course_eligible(
                    course=course,
                    current_units=current_units,
                    max_units=max_units,
                    selected_course_ids=selected_course_ids,
                    completed_course_ids=completed_course_ids,
                    prerequisite_data_by_course=prerequisite_data_by_course,
                ):
                    continue

                if (
                    ge_progress[requirement_id]["completed_units"] + get_course_units(course)
                    > ge_progress[requirement_id]["required_units_max"]
                ):
                    continue

                valid_options.append((requirement_id, course))

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


def course_prerequisites_satisfied(course_id, completed_course_ids, selected_course_ids, prerequisite_data_by_course):
    prerequisite_groups = prerequisite_data_by_course.get(course_id, {}).get("prerequisite", {})

    if not prerequisite_groups:
        return True

    for group_number in sorted(prerequisite_groups.keys()):
        group_items = prerequisite_groups[group_number]

        if not is_prerequisite_group_satisfied(group_items, completed_course_ids, selected_course_ids):
            return False

    return True


# def log_non_prerequisite_requirements(course_id, prerequisite_data_by_course):
#     course_data = prerequisite_data_by_course.get(course_id, {})

#     for group_items in course_data.get("corequisite", {}).values():
#         for item in group_items:
#             print(f"[PLAN DEBUG] Corequisite logged but not enforced for course_id={course_id}: {item}")

#     for group_items in course_data.get("restriction", {}).values():
#         for item in group_items:
#             print(f"[PLAN DEBUG] Restriction logged but not enforced for course_id={course_id}: {item}")


def is_course_eligible(
    course,
    current_units,
    max_units,
    selected_course_ids,
    completed_course_ids,
    prerequisite_data_by_course,
):
    course_id = course["course_id"]
    units = get_course_units(course)

    if course_id in completed_course_ids:
        return False

    if course_id in selected_course_ids:
        return False

    if current_units + units > max_units:
        return False

    # log_non_prerequisite_requirements(course_id, prerequisite_data_by_course)

    if not course_prerequisites_satisfied(
        course_id=course_id,
        completed_course_ids=completed_course_ids,
        selected_course_ids=selected_course_ids,
        prerequisite_data_by_course=prerequisite_data_by_course,
    ):
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
#
#         TEST_USER_ID = 1
#         TEST_MAJOR_ID = 1
#         TEST_CATALOG_YEAR_ID = 1
#         TEST_START_TERM = "Fall"
#         TEST_START_YEAR = 2025
#
#         result = generate_plan_for_user(
#             user_id=TEST_USER_ID,
#             major_id=TEST_MAJOR_ID,
#             catalog_year_id=TEST_CATALOG_YEAR_ID,
#             starting_term=TEST_START_TERM,
#             starting_year=TEST_START_YEAR,
#         )
#
#         print("\n=== GENERATED PLAN SUCCESS ===\n")
#         print(result)
#
#     except Exception as e:
#         print("\n=== PLAN GENERATION FAILED ===\n")
#         print(e)