from flask import Blueprint, request, jsonify
from routes.db_operations import query_db


plan_bp = Blueprint("plan_bp", __name__)


@plan_bp.route("/", methods=["POST"])
def create_plan():
    pass  # Implementation for creating a plan goes here

@plan_bp.route("/catalogs", methods=["GET"])
def get_catalogs():
    catalogs = query_db(
        "SELECT DISTINCT catalog_name FROM catalog_years ORDER BY catalog_year DESC;"
    )
    return jsonify(catalogs), 200
