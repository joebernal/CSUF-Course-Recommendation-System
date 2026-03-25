from flask import Blueprint, request, jsonify
from routes.db_operations import query_db

user_bp = Blueprint("user_bp", __name__)


@user_bp.route("/", methods=["POST", "OPTIONS"])
def add_user():
    data = request.get_json()

    existing_user = query_db(
        "SELECT * FROM users WHERE google_uid = %s", (data["google_uid"],), one=True
    )

    if existing_user:
        return jsonify({"error": "User with this Google UID already exists"}), 400

    query_db(
        "INSERT INTO users (email, google_uid, full_name) VALUES (%s, %s, %s)",
        (data["email"], data["google_uid"], data["full_name"]),
    )
    query_db(
        "INSERT INTO user_preferences (user_id) VALUES ((SELECT id FROM users WHERE google_uid = %s))",
        (data["google_uid"],),
    )

    return jsonify({"message": "User added"}), 201


@user_bp.route("/updateProfile", methods=["POST", "OPTIONS"])
def update_profile():
    data = request.get_json()

    enrollment_status = data.get("enrollmentStatus")
    preferred_terms = data.get("preferredTerms")
    preferred_language = data.get("preferredLanguage")
    career_interest = data.get("careerInterest")
    query_db(
        "UPDATE users SET enrollment_status = %s, available_winter = %s, available_summer = %s WHERE google_uid = %s",
        (
            enrollment_status,
            preferred_terms.get("winter", False),
            preferred_terms.get("summer", False),
            data["google_uid"],
        ),
    )
    query_db(
        "UPDATE user_preferences SET preferred_language = %s, career_interest = %s WHERE user_id = (SELECT id FROM users WHERE google_uid = %s)",
        (
            preferred_language,
            career_interest,
            data["google_uid"],
        ),
    )

    return jsonify({"message": "User profile updated"}), 200
