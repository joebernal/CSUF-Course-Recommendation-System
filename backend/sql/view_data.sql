USE tuffyplan;
-- =========================
-- 1) Users + Preferences
-- =========================
SELECT * FROM users;
SELECT * FROM user_preferences;
SELECT * FROM user_exams;

-- =========================
-- 2) Catalog Years + Majors
-- =========================
SELECT * FROM catalog_years;
SELECT * FROM majors;

-- =========================
-- 3) Courses + Pairing
-- =========================
SELECT * FROM courses;
SELECT * FROM course_pairs;

-- =========================
-- 4) Major Requirements
-- =========================
SELECT * FROM major_requirements;
SELECT * FROM major_requirement_courses;
SELECT * FROM major_rules;

-- =========================
-- 5) GE Areas
-- =========================
SELECT * FROM ge_areas;
SELECT * FROM major_ge_requirements;
SELECT * FROM major_ge_courses;

-- =========================
-- 6) Course Requirements (Prereqs/Coreqs)
-- =========================
SELECT * FROM course_requirements;
SELECT * FROM course_requirement_items;

-- =========================
-- 7) Plans + Completed Courses
-- =========================
SELECT * FROM course_plans;
SELECT * FROM plan_courses;
SELECT * FROM completed_courses;