from flask import Blueprint, jsonify, request
from routes.db_operations import query_db

course_bp = Blueprint("course_bp", __name__)


def _get_user_id_by_google_uid(google_uid):
	if not google_uid:
		return None

	user = query_db(
		"SELECT id FROM users WHERE google_uid = %s",
		(google_uid,),
		one=True,
	)

	return user["id"] if user else None


@course_bp.route("/search", methods=["GET"])
def search_courses():
	try:
		query = (request.args.get("q") or "").strip()

		if len(query) < 2:
			return jsonify({"courses": []}), 200

		like_query = f"%{query}%"
		courses = query_db(
			"""
			SELECT
				id,
				course_code,
				course_name,
				units_min,
				units_max
			FROM courses
			WHERE course_code LIKE %s
				OR course_name LIKE %s
			ORDER BY course_code ASC
			LIMIT 25
			""",
			(like_query, like_query),
		) or []

		formatted_courses = [
			{
				"id": row["id"],
				"courseCode": row["course_code"],
				"courseName": row["course_name"],
				"unitsMin": float(row["units_min"]),
				"unitsMax": float(row["units_max"]),
			}
			for row in courses
		]

		return jsonify({"courses": formatted_courses}), 200
	except Exception as e:
		print("SEARCH COURSES ERROR:", e)
		return jsonify({"error": str(e)}), 500


@course_bp.route("/description", methods=["GET"])
def get_course_description():
	try:
		course_code = (request.args.get("course_code") or "").strip()

		if not course_code:
			return jsonify({"error": "course_code is required"}), 400

		course = query_db(
			"""
			SELECT
				course_code,
				course_name,
				course_description
			FROM courses
			WHERE course_code = %s
			LIMIT 1
			""",
			(course_code,),
			one=True,
		)

		if not course:
			return jsonify({"error": "Course not found"}), 404

		return jsonify(
			{
				"courseCode": course["course_code"],
				"courseName": course["course_name"],
				"courseDescription": course["course_description"] or "No course description available.",
			}
		), 200
	except Exception as e:
		print("GET COURSE DESCRIPTION ERROR:", e)
		return jsonify({"error": str(e)}), 500


@course_bp.route("/completed", methods=["GET"])
def get_completed_courses():
	try:
		google_uid = (request.args.get("google_uid") or "").strip()

		if not google_uid:
			return jsonify({"error": "google_uid is required"}), 400

		user_id = _get_user_id_by_google_uid(google_uid)
		if not user_id:
			return jsonify({"error": "User not found"}), 404

		completed_courses = query_db(
			"""
			SELECT
				cc.course_id,
				c.course_code,
				c.course_name,
				c.units_min,
				c.units_max,
				cc.term,
				cc.year,
				cc.grade
			FROM completed_courses cc
			JOIN courses c
				ON cc.course_id = c.id
			WHERE cc.user_id = %s
			ORDER BY c.course_code ASC
			""",
			(user_id,),
		) or []

		formatted = [
			{
				"courseId": row["course_id"],
				"courseCode": row["course_code"],
				"courseName": row["course_name"],
				"unitsMin": float(row["units_min"]),
				"unitsMax": float(row["units_max"]),
				"term": row["term"],
				"year": row["year"],
				"grade": row["grade"],
			}
			for row in completed_courses
		]

		return jsonify({"completedCourses": formatted}), 200
	except Exception as e:
		print("GET COMPLETED COURSES ERROR:", e)
		return jsonify({"error": str(e)}), 500


@course_bp.route("/completed", methods=["POST"])
def add_completed_course():
	try:
		data = request.get_json()
		if not data:
			return jsonify({"error": "Missing JSON body"}), 400

		google_uid = (data.get("google_uid") or "").strip()
		course_id = data.get("course_id")
		term = (data.get("term") or "").strip() or "Spring"
		year = data.get("year")
		grade = (data.get("grade") or "").strip() or None

		if not google_uid:
			return jsonify({"error": "google_uid is required"}), 400

		if not course_id:
			return jsonify({"error": "course_id is required"}), 400

		if not year:
			return jsonify({"error": "year is required"}), 400

		user_id = _get_user_id_by_google_uid(google_uid)
		if not user_id:
			return jsonify({"error": "User not found"}), 404

		course = query_db(
			"SELECT id FROM courses WHERE id = %s",
			(course_id,),
			one=True,
		)
		if not course:
			return jsonify({"error": "Course not found"}), 404

		existing = query_db(
			"SELECT id FROM completed_courses WHERE user_id = %s AND course_id = %s",
			(user_id, course_id),
			one=True,
		)
		if existing:
			return jsonify({"error": "Course already in completed list"}), 409

		query_db(
			"""
			INSERT INTO completed_courses (user_id, course_id, term, year, grade)
			VALUES (%s, %s, %s, %s, %s)
			""",
			(user_id, course_id, term, int(year), grade),
		)

		return jsonify({"message": "Completed course added"}), 201
	except Exception as e:
		print("ADD COMPLETED COURSE ERROR:", e)
		return jsonify({"error": str(e)}), 500


@course_bp.route("/completed/<int:course_id>", methods=["DELETE"])
def remove_completed_course(course_id):
	try:
		google_uid = (request.args.get("google_uid") or "").strip()

		if not google_uid:
			return jsonify({"error": "google_uid is required"}), 400

		user_id = _get_user_id_by_google_uid(google_uid)
		if not user_id:
			return jsonify({"error": "User not found"}), 404

		existing = query_db(
			"SELECT id FROM completed_courses WHERE user_id = %s AND course_id = %s",
			(user_id, course_id),
			one=True,
		)
		if not existing:
			return jsonify({"error": "Completed course not found"}), 404

		query_db(
			"DELETE FROM completed_courses WHERE user_id = %s AND course_id = %s",
			(user_id, course_id),
		)

		return jsonify({"message": "Completed course removed"}), 200
	except Exception as e:
		print("REMOVE COMPLETED COURSE ERROR:", e)
		return jsonify({"error": str(e)}), 500

