from flask import Blueprint, request, jsonify
import traceback
from routes.db_operations import query_db
from services.plan_generator import generate_plan_for_user

plan_bp = Blueprint("plan_bp", __name__)

@plan_bp.route("/", methods=["POST"])
def get_user_plans():
    try:
        data = request.get_json()

        if not data:
            return jsonify({"error": "Missing JSON body"}), 400

        google_uid = data.get("google_uid")

        if not google_uid:
            return jsonify({"error": "google_uid is required"}), 400

        user = query_db(
            "SELECT id FROM users WHERE google_uid = %s",
            (google_uid,),
            one=True
        )

        if not user:
            return jsonify({"error": "User not found"}), 404

        plans = query_db(
            """
            SELECT
                cp.id,
                cp.plan_name,
                cy.catalog_name,
                cp.created_at
            FROM course_plans cp
            JOIN catalog_years cy
                ON cp.catalog_year_id = cy.id
            WHERE cp.user_id = %s
            ORDER BY cp.created_at DESC
            """,
            (user["id"],)
        )

        formatted_plans = [
            {
                "id": str(plan["id"]),
                "planName": plan["plan_name"],
                "catalogYear": plan["catalog_name"],
                "dateRequested": str(plan["created_at"]).split(" ")[0],
            }
            for plan in plans
        ]

        return jsonify({"plans": formatted_plans}), 200

    except Exception as e:
        print("GET USER PLANS ERROR:", e)
        return jsonify({"error": str(e)}), 500

@plan_bp.route("/generate", methods=["POST"])
def generate_plan():
    try:
        data = request.get_json()

        if not data:
            return jsonify({"error": "Missing JSON body"}), 400

        google_uid = data.get("google_uid")
        major_id = data.get("major_id")
        catalog_year_id = data.get("catalog_year_id")
        starting_term = data.get("starting_term")
        starting_year = data.get("starting_year")

        if not google_uid:
            return jsonify({"error": "google_uid is required"}), 400

        if not major_id:
            return jsonify({"error": "major_id is required"}), 400

        if not catalog_year_id:
            return jsonify({"error": "catalog_year_id is required"}), 400

        if not starting_term:
            return jsonify({"error": "starting_term is required"}), 400

        if not starting_year:
            return jsonify({"error": "starting_year is required"}), 400

        user = query_db(
            "SELECT id FROM users WHERE google_uid = %s",
            (google_uid,),
            one=True
        )

        if not user:
            return jsonify({"error": "User not found"}), 404

        result = generate_plan_for_user(
            user_id=user["id"],
            major_id=int(major_id),
            catalog_year_id=int(catalog_year_id),
            starting_term=starting_term,
            starting_year=int(starting_year),
        )

        return jsonify({
            "message": "Plan generated successfully.",
            "plan_id": result["plan_id"],
            "plan_name": result["plan_name"],
            "semesters": result["semesters"],
        }), 201

    except Exception as e:
        print("[PLAN ROUTE ERROR]", e)
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500

@plan_bp.route("/<int:plan_id>", methods=["GET"])
def get_plan_details(plan_id):
    try:
        google_uid = (request.args.get("google_uid") or "").strip()

        plan = query_db(
            """
            SELECT
                cp.id,
                cp.plan_name,
                cp.created_at,
                cp.major_id,
                cp.catalog_year_id,
                u.enrollment_status,
                m.major_name,
                cy.catalog_name
            FROM course_plans cp
            JOIN users u
                ON cp.user_id = u.id
            JOIN majors m
                ON cp.major_id = m.id
            JOIN catalog_years cy
                ON cp.catalog_year_id = cy.id
            WHERE cp.id = %s
            """,
            (plan_id,),
            one=True,
        )

        if not plan:
            return jsonify({"error": "Plan not found"}), 404

        completed_course_ids = set()
        if google_uid:
            user = query_db(
                "SELECT id FROM users WHERE google_uid = %s",
                (google_uid,),
                one=True,
            )

            if user:
                completed_rows = query_db(
                    "SELECT course_id FROM completed_courses WHERE user_id = %s",
                    (user["id"],),
                ) or []
                completed_course_ids = {
                    int(row["course_id"]) for row in completed_rows
                }

        courses = query_db(
            """
            SELECT
                pc.term,
                pc.year,
                pc.applied_to,
                pc.course_id,
                c.course_code,
                c.course_name,
                c.units_max
            FROM plan_courses pc
            JOIN courses c
                ON pc.course_id = c.id
            WHERE pc.plan_id = %s
            ORDER BY pc.year ASC,
                FIELD(pc.term, 'Winter', 'Spring', 'Summer', 'Fall'),
                pc.id ASC
            """,
            (plan_id,),
        ) or []

        semesters_map = {}

        for row in courses:
            semester_label = f"{row['term']} {row['year']}"

            if semester_label not in semesters_map:
                semesters_map[semester_label] = []

            semesters_map[semester_label].append({
                "code": row["course_code"],
                "title": row["course_name"],
                "units": float(row["units_max"]),
                "isCompleted": int(row["course_id"]) in completed_course_ids,
                "appliedTo": row["applied_to"],
            })

        semesters = [
            {
                "semester": semester_label,
                "courses": semester_courses,
            }
            for semester_label, semester_courses in semesters_map.items()
        ]

        enrollment_status = (
            "Full Time" if plan["enrollment_status"] == "fulltime" else "Part Time"
        )

        return jsonify({
            "id": str(plan["id"]),
            "planName": plan["plan_name"],
            "catalogYear": plan["catalog_name"],
            "dateRequested": str(plan["created_at"]).split(" ")[0],
            "enrollmentStatus": enrollment_status,
            "major": plan["major_name"],
            "semesters": semesters,
        }), 200

    except Exception as e:
        print("GET PLAN DETAILS ERROR:", e)
        return jsonify({"error": str(e)}), 500

@plan_bp.route("/<int:plan_id>/degree-requirements", methods=["GET"])
def get_degree_requirements(plan_id):
    try:
        # 1) get the plan's major + catalog year
        plan = query_db(
            "SELECT major_id, catalog_year_id FROM course_plans WHERE id = %s",
            (plan_id,),
            one=True
        )

        if not plan:
            return jsonify({"error": "Plan not found"}), 404

        # 2) get degree requirements for that major/year (filter out seed/test rows)
        requirements = query_db(
            """
            SELECT
                requirement_name,
                required_units_min,
                note
            FROM major_requirements
            WHERE major_id = %s
              AND catalog_year_id = %s
              AND note NOT LIKE 'Seed data:%'
            ORDER BY id
            """,
            (plan["major_id"], plan["catalog_year_id"])
        ) or []

        # 3) format response cleanly
        formatted = [
            {
                "requirementName": r["requirement_name"],
                "requiredUnitsMin": float(r["required_units_min"]) if r["required_units_min"] is not None else None,
                "note": r["note"],
            }
            for r in requirements
        ]

        return jsonify({"requirements": formatted}), 200

    except Exception as e:
        print("GET DEGREE REQUIREMENTS ERROR:", e)
        traceback.print_exc()
        return jsonify({"error": str(e)}), 500

@plan_bp.route("/catalogs", methods=["GET"])
def get_catalogs():
    try:
        catalogs = query_db(
            """
            SELECT
                id,
                catalog_name,
                start_term,
                start_year
            FROM catalog_years
            ORDER BY start_year DESC,
                FIELD(start_term, 'Winter', 'Spring', 'Summer', 'Fall')
            """
        ) or []

        return jsonify(catalogs), 200
    except Exception as e:
        print("GET CATALOGS ERROR:", e)
        return jsonify({"error": str(e)}), 500
    
def _delete_plan_for_user(plan_id, google_uid):
    if not google_uid:
        return jsonify({"error": "google_uid is required"}), 400

    user = query_db(
        "SELECT id FROM users WHERE google_uid = %s",
        (google_uid,),
        one=True,
    )

    if not user:
        return jsonify({"error": "User not found"}), 404

    plan = query_db(
        "SELECT id FROM course_plans WHERE id = %s AND user_id = %s",
        (plan_id, user["id"]),
        one=True,
    )

    if not plan:
        return jsonify({"error": "Plan not found or does not belong to user"}), 404

    query_db(
        "DELETE FROM course_plans WHERE id = %s",
        (plan_id,)
    )

    return jsonify({"message": "Plan deleted successfully."}), 200


@plan_bp.route("/<int:plan_id>", methods=["DELETE"])
def delete_plan_rest(plan_id):
    try:
        google_uid = (request.args.get("google_uid") or "").strip()
        return _delete_plan_for_user(plan_id, google_uid)

    except Exception as e:
        print("DELETE PLAN ERROR:", e)
        return jsonify({"error": str(e)}), 500


@plan_bp.route("/delete/<plan_id>", methods=["GET"])
def delete_plan(plan_id):
    try:
        google_uid = (request.args.get("google_uid") or "").strip()
        return _delete_plan_for_user(plan_id, google_uid)

    except Exception as e:
        print("DELETE PLAN ERROR:", e)
        return jsonify({"error": str(e)}), 500
