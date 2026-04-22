from flask import Blueprint, request, jsonify
from routes.db_operations import query_db
import mysql.connector

user_bp = Blueprint("user_bp", __name__)


def _normalize_enrollment_status(value):
    raw = (value or "").strip().lower().replace("_", "")
    if raw in {"fulltime", "parttime"}:
        return raw
    return None

@user_bp.route("/", methods=["POST", "OPTIONS"])
def add_user():
    try:
        data = request.get_json()

        print("ADD USER request data:", data)

        if not data:
            return jsonify({"error": "Missing JSON body"}), 400

        email = (data.get("email") or "").strip()
        google_uid = (data.get("google_uid") or "").strip()
        full_name = (data.get("full_name") or "").strip()

        if not email:
            return jsonify({"error": "email is required"}), 400

        if not google_uid:
            return jsonify({"error": "google_uid is required"}), 400

        if not full_name:
            return jsonify({"error": "full_name is required"}), 400

        existing_google_user = query_db(
            "SELECT id FROM users WHERE google_uid = %s",
            (google_uid,),
            one=True
        )
        if existing_google_user:
            return jsonify({"error": "User with this Google UID already exists"}), 400

        existing_email_user = query_db(
            "SELECT id FROM users WHERE email = %s",
            (email,),
            one=True
        )
        if existing_email_user:
            return jsonify({"error": "User with this email already exists"}), 400

        query_db(
            "INSERT INTO users (email, google_uid, full_name) VALUES (%s, %s, %s)",
            (email, google_uid, full_name),
        )

        user_row = query_db(
            "SELECT id FROM users WHERE google_uid = %s",
            (google_uid,),
            one=True
        )

        if not user_row:
            return jsonify({"error": "User inserted, but could not retrieve user ID"}), 500

        query_db(
            "INSERT INTO user_preferences (user_id) VALUES (%s)",
            (user_row["id"],),
        )

        return jsonify({"message": "User added"}), 201

    except mysql.connector.Error as e:
        print("MYSQL ERROR:", e)
        return jsonify({"error": f"MySQL error: {e.msg}"}), 500
    except Exception as e:
        print("ADD USER ERROR:", str(e))
        return jsonify({"error": str(e)}), 500


@user_bp.route("/updateProfile", methods=["POST"])
def update_profile():
    try:
        data = request.get_json()

        if not data:
            return jsonify({"error": "Missing JSON body"}), 400

        google_uid = (data.get("google_uid") or "").strip()
        full_name = (data.get("full_name") or "").strip()
        enrollment_status = _normalize_enrollment_status(data.get("enrollmentStatus"))
        preferred_terms = data.get("preferredTerms") or {}
        preferred_language = (data.get("preferredLanguage") or "").strip() or None
        career_interest = (data.get("careerInterest") or "").strip() or None

        if not google_uid:
            return jsonify({"error": "google_uid is required"}), 400

        user = query_db(
            "SELECT id, full_name FROM users WHERE google_uid = %s",
            (google_uid,),
            one=True,
        )

        if not user:
            return jsonify({"error": "User not found"}), 404

        # Keep existing values when optional sections are not provided.
        if full_name:
            query_db(
                "UPDATE users SET full_name = %s WHERE id = %s",
                (full_name, user["id"]),
            )

        if enrollment_status:
            available_winter = bool(preferred_terms.get("winter", False))
            available_summer = bool(preferred_terms.get("summer", False))
            query_db(
                """
                UPDATE users
                SET enrollment_status = %s,
                    available_winter = %s,
                    available_summer = %s
                WHERE id = %s
                """,
                (enrollment_status, available_winter, available_summer, user["id"]),
            )

        query_db(
            """
            INSERT INTO user_preferences (user_id, preferred_language, career_interest)
            VALUES (%s, %s, %s)
            ON DUPLICATE KEY UPDATE
                preferred_language = VALUES(preferred_language),
                career_interest = VALUES(career_interest)
            """,
            (user["id"], preferred_language, career_interest),
        )

        return jsonify({"message": "Profile updated successfully."}), 200

    except mysql.connector.Error as e:
        print("MYSQL ERROR:", e)
        return jsonify({"error": f"MySQL error: {e.msg}"}), 500
    except Exception as e:
        print("UPDATE PROFILE ERROR:", str(e))
        return jsonify({"error": str(e)}), 500