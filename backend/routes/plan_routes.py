from flask import Blueprint, request, jsonify
from routes.db_operations import query_db


plan_bp = Blueprint("plan_bp", __name__)


@plan_bp.route("/", methods=["POST"])
def add_plan():

    data = request.get_json() or {}

    major = (data.get("major") or "").strip()
    enrollment_raw = (
        (data.get("enrollment") or data.get("enrollment_status") or "").strip().lower()
    )
    catalog_year = (data.get("catalog_year") or data.get("catalogYear") or "").strip()
    start_semester_raw = (
        data.get("start_semester") or data.get("startSeason") or ""
    ).strip()
    semester_year_raw = data.get(
        "semester_year", data.get("semesteryear", data.get("start_year"))
    )

    enrollment_map = {
        "fulltime": "fulltime",
        "full time": "fulltime",
        "full_time": "fulltime",
        "parttime": "parttime",
        "part time": "parttime",
        "part_time": "parttime",
    }
    enrollment = enrollment_map.get(enrollment_raw)

    start_semester = start_semester_raw.capitalize()
    allowed_semesters = {"Fall", "Spring", "Winter", "Summer"}

    errors = []

    if not major:
        errors.append("major is required")
    if not enrollment:
        errors.append("enrollment must be fulltime or parttime")
    if not catalog_year:
        errors.append("catalog_year is required")
    if start_semester not in allowed_semesters:
        errors.append("start_semester must be one of: Fall, Spring, Winter, Summer")

    semester_year = None
    try:
        semester_year = int(semester_year_raw)
        #if not valid year, (need to implement)
        #    errors.append("invalid year or not in database")
    except (TypeError, ValueError):
        errors.append("semester_year must be a valid year")

    if errors:
        return jsonify({"errors": errors}), 400

    plan_request = {
        "major": major,
        "enrollment": enrollment,
        "catalog_year": catalog_year,
        "start_semester": start_semester,
        "semester_year": semester_year,
    }

    return (
        jsonify(
            {"message": "Plan request data received", "plan_request": plan_request}
        ),
        200,
    )


@plan_bp.route("/catalogs", methods=["GET"])
def get_catalogs():
    catalogs = query_db(
        "SELECT DISTINCT catalog_name FROM catalog_years ORDER BY catalog_year DESC;"
    )
    return jsonify(catalogs), 200
