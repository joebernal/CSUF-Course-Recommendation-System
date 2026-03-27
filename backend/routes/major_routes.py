from flask import Blueprint, jsonify
from routes.db_operations import query_db

major_bp = Blueprint("major_bp", __name__)

@major_bp.route("/", methods=["GET"])
def get_majors():
    try:
        majors = query_db(
            """
            SELECT id, major_name
            FROM majors
            ORDER BY major_name ASC
            """
        ) or []

        return jsonify(majors), 200
    except Exception as e:
        print("GET MAJORS ERROR:", e)
        return jsonify({"error": str(e)}), 500
