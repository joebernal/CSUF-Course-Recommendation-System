import random

from routes.db_operations import query_db


# setup variables
major_id = 1
catalog_id = 1


def get_major(major_id):
    major = query_db("SELECT * FROM majors WHERE id = %s", (major_id,), one=True)
    return major


def get_catalog(catalog_id):
    catalog = query_db(
        "SELECT * FROM catalog_years WHERE id = %s", (catalog_id,), one=True
    )
    return catalog


def get_major_requirements(major_id, catalog_id):
    requirements = query_db(
        "SELECT * FROM major_requirements WHERE major_id = %s AND catalog_year_id = %s",
        (major_id, catalog_id),
    )
    return requirements


#
#
# Full texts
# 	id 	major_requirement_id 	course_id 	choice_group 	note
# 	Edit Edit 	Copy Copy 	Delete Delete 	1 	1 	1825 	0 	Required lower-division core course
#
def get_courses_for_requirement(requirement_id):
    courses = query_db(
        "SELECT c.id AS course_id, c.course_name, c.course_code, c.units_max, mrc.choice_group FROM courses c JOIN major_requirement_courses mrc ON c.id = mrc.course_id WHERE mrc.major_requirement_id = %s",
        (requirement_id,),
    )
    if not courses:
        return courses

    selected = [c for c in courses if c["choice_group"] == 0]
    grouped_choices = {}
    for course in courses:
        if course["choice_group"] > 0:
            grouped_choices.setdefault(course["choice_group"], []).append(course)
    for group in grouped_choices.values():
        selected.append(random.choice(group))
    courses = selected

    course_ids = [c["course_id"] for c in courses]
    placeholders = ",".join(["%s"] * len(course_ids))
    prereq_rows = query_db(
        f"SELECT cr.course_id, cri.required_course_id FROM course_requirements cr JOIN course_requirement_items cri ON cri.course_requirement_id = cr.id WHERE cr.requirement_type = 'prerequisite' AND cri.item_type = 'course' AND cr.course_id IN ({placeholders}) AND cri.required_course_id IN ({placeholders})",
        tuple(course_ids + course_ids),
    )

    prereqs = {cid: set() for cid in course_ids}
    for row in prereq_rows:
        prereqs[row["course_id"]].add(row["required_course_id"])

    pending = {c["course_id"]: c for c in courses}
    ordered, done = [], set()
    while pending:
        moved = False
        for cid, course in list(pending.items()):
            if prereqs.get(cid, set()) <= done:
                ordered.append(course)
                done.add(cid)
                del pending[cid]
                moved = True
        if not moved:
            ordered.extend(sorted(pending.values(), key=lambda c: c["course_code"]))
            break
    return ordered


def choose_courses_for_requirement(requirement_id, max_units):
    courses = get_courses_for_requirement(requirement_id)
    requirement = query_db(
        "SELECT * FROM major_requirements WHERE id = %s LIMIT 1",
        (requirement_id,),
        one=True,
    )
    units_required = requirement.get("required_units")
    current_units = 0
    chosen_courses = []
    for course in courses:
        if (
            current_units + course.get("units_max") <= max_units
            and current_units + course.get("units_max") <= units_required
        ):
            chosen_courses.append(course)
            current_units += course.get("units_max")
    return chosen_courses


print("Major Name:")
print(get_major(major_id).get("major_name"))
print("Catalog Year:")
print(get_catalog(catalog_id).get("catalog_name"))
requirements = get_major_requirements(major_id, catalog_id)
print("Major Requirements:")
for req in requirements:
    if req.get("requirement_type") == "core":
        print(f"Requirement: {req.get('requirement_name')}")
        courses = get_courses_for_requirement(req.get("id"))
        for course in courses:
            print(
                f"  Course: {course.get('course_code')} - {course.get('course_name')} ({course.get('units_max')} units)"
            )
