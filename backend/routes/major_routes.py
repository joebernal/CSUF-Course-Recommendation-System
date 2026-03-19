from flask import Blueprint, jsonify
from routes.db_operations import query_db

major_bp = Blueprint("major_bp", __name__)

# available majors
@major_bp.route("/", methods=["GET"])
def get_majors():
	majors = query_db("SELECT major_name,major_acronym FROM `majors`;")
	return jsonify(majors), 200
