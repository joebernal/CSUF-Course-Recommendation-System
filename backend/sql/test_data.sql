-- ============================================================
-- TUFFYPLAN: DUMMY DATA SEED SCRIPT
-- Paste/run AFTER your schema (CREATE TABLE...) has been created
-- ============================================================

USE tuffyplan;

SET FOREIGN_KEY_CHECKS = 0;

-- Optional: clear existing data (safe order)
DELETE FROM completed_courses;
DELETE FROM plan_courses;
DELETE FROM course_plans;

DELETE FROM course_requirement_items;
DELETE FROM course_requirements;

DELETE FROM major_ge_courses;
DELETE FROM major_ge_requirements;
DELETE FROM ge_areas;

DELETE FROM major_requirement_courses;
DELETE FROM major_rules;
DELETE FROM major_requirements;

DELETE FROM course_pairs;

DELETE FROM user_exams;
DELETE FROM user_preferences;
DELETE FROM users;

DELETE FROM courses;
DELETE FROM majors;
DELETE FROM catalog_years;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- 1) Catalog + Major
-- ============================================================

INSERT INTO catalog_years (catalog_name, start_term, start_year)
VALUES ('Fall 2025 & Beyond', 'Fall', 2025);

INSERT INTO majors (major_name, major_acronym)
VALUES ('Computer Science', 'CS');

-- ============================================================
-- 2) GE Areas
-- ============================================================

INSERT INTO ge_areas (area_code, area_name)
VALUES
('2A', 'Written Communication'),
('4',  'Social Sciences'),
('B.1','Physical Science'),
('B.2','Life Science'),
('C.1','Arts'),
('C.2','Humanities');

-- ============================================================
-- 3) Courses (CS core + Math/Science + GE)
-- ============================================================

INSERT INTO courses (course_code, course_name, course_description, units_min, units_max, has_lab, includes_lab)
VALUES
('CPSC 120', 'Introduction to Programming', 'Intro programming fundamentals.', 3, 3, FALSE, FALSE),
('CPSC 121', 'Object-Oriented Programming', 'Objects, classes, and OOP design.', 3, 3, FALSE, FALSE),
('CPSC 131', 'Data Structures', 'Classic data structures and implementation.', 3, 3, FALSE, FALSE),
('CPSC 240', 'Computer Organization', 'Machine-level representation and systems.', 3, 3, FALSE, FALSE),
('CPSC 335', 'Algorithms', 'Algorithm design and analysis.', 3, 3, FALSE, FALSE),

('MATH 150A', 'Calculus I', 'Differential calculus.', 4, 4, FALSE, FALSE),
('MATH 150B', 'Calculus II', 'Integral calculus and applications.', 4, 4, FALSE, FALSE),

('PHYS 225',  'Physics for Scientists and Engineers I', 'Mechanics, waves, thermodynamics.', 3, 3, FALSE, FALSE),
('PHYS 225L', 'Physics Lab I', 'Lab companion for PHYS 225.', 1, 1, TRUE,  FALSE),

('ENGL 101', 'College Writing', 'Academic writing and rhetoric.', 3, 3, FALSE, FALSE),
('HIST 170A', 'United States History', 'Survey of U.S. history.', 3, 3, FALSE, FALSE),
('ART 101',   'Introduction to Art', 'Foundations of visual art.', 3, 3, FALSE, FALSE),
('PHIL 101',  'Introduction to Philosophy', 'Intro to philosophical thinking.', 3, 3, FALSE, FALSE);

-- ============================================================
-- 4) Lecture/Lab Pair (PHYS 225 + PHYS 225L)
-- ============================================================

INSERT INTO course_pairs (course_id, paired_course_id, pair_type)
VALUES (
    (SELECT id FROM courses WHERE course_code='PHYS 225'),
    (SELECT id FROM courses WHERE course_code='PHYS 225L'),
    'lecture_lab'
);

-- ============================================================
-- 5) Major Requirements (sample)
-- ============================================================

INSERT INTO major_requirements
(major_id, catalog_year_id, requirement_name, requirement_type, required_units_min, required_units_max, note)
VALUES
(
 (SELECT id FROM majors WHERE major_acronym='CS'),
 (SELECT id FROM catalog_years WHERE catalog_name='Fall 2025 & Beyond'),
 'Lower Division Core',
 'core',
 12,
 12,
 'Seed data: basic lower-division core bucket.'
),
(
 (SELECT id FROM majors WHERE major_acronym='CS'),
 (SELECT id FROM catalog_years WHERE catalog_name='Fall 2025 & Beyond'),
 'Math Requirements',
 'math',
 8,
 8,
 'Seed data: two calculus courses.'
);

-- Required courses for Lower Division Core
INSERT INTO major_requirement_courses (major_requirement_id, course_id, choice_group, note)
SELECT mr.id, c.id, 0, 'Required'
FROM major_requirements mr
JOIN courses c
WHERE mr.requirement_name='Lower Division Core'
  AND c.course_code IN ('CPSC 120','CPSC 121','CPSC 131','CPSC 240');

-- Required courses for Math Requirements
INSERT INTO major_requirement_courses (major_requirement_id, course_id, choice_group, note)
SELECT mr.id, c.id, 0, 'Required'
FROM major_requirements mr
JOIN courses c
WHERE mr.requirement_name='Math Requirements'
  AND c.course_code IN ('MATH 150A','MATH 150B');

-- ============================================================
-- 6) Major Rules (sample)
-- ============================================================

INSERT INTO major_rules
(major_id, catalog_year_id, rule_name, rule_value_int, rule_value_text, is_enforced)
VALUES
(
 (SELECT id FROM majors WHERE major_acronym='CS'),
 (SELECT id FROM catalog_years WHERE catalog_name='Fall 2025 & Beyond'),
 'Max units per term',
 16,
 'Planner should not exceed 16 units in Fall/Spring by default.',
 TRUE
),
(
 (SELECT id FROM majors WHERE major_acronym='CS'),
 (SELECT id FROM catalog_years WHERE catalog_name='Fall 2025 & Beyond'),
 'Max winter units',
 3,
 'Planner should not exceed 3 units in Winter by default.',
 TRUE
);

-- ============================================================
-- 7) Major GE Requirements + Allowed Courses
-- ============================================================

-- Require 3 units in GE 2A and 3 units in GE 4 (for seed/testing)
INSERT INTO major_ge_requirements
(major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES
(
 (SELECT id FROM majors WHERE major_acronym='CS'),
 (SELECT id FROM catalog_years WHERE catalog_name='Fall 2025 & Beyond'),
 (SELECT id FROM ge_areas WHERE area_code='2A'),
 3, 3,
 'Seed data: written communication.'
),
(
 (SELECT id FROM majors WHERE major_acronym='CS'),
 (SELECT id FROM catalog_years WHERE catalog_name='Fall 2025 & Beyond'),
 (SELECT id FROM ge_areas WHERE area_code='4'),
 3, 3,
 'Seed data: social sciences.'
);

-- Courses that satisfy GE 2A
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES
(
 (SELECT mgr.id
  FROM major_ge_requirements mgr
  JOIN ge_areas ga ON ga.id = mgr.ge_area_id
  WHERE ga.area_code='2A'
    AND mgr.major_id=(SELECT id FROM majors WHERE major_acronym='CS')
    AND mgr.catalog_year_id=(SELECT id FROM catalog_years WHERE catalog_name='Fall 2025 & Beyond')
 ),
 (SELECT id FROM courses WHERE course_code='ENGL 101'),
 FALSE,
 'Seed data GE 2A course.'
);

-- Courses that satisfy GE 4
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES
(
 (SELECT mgr.id
  FROM major_ge_requirements mgr
  JOIN ge_areas ga ON ga.id = mgr.ge_area_id
  WHERE ga.area_code='4'
    AND mgr.major_id=(SELECT id FROM majors WHERE major_acronym='CS')
    AND mgr.catalog_year_id=(SELECT id FROM catalog_years WHERE catalog_name='Fall 2025 & Beyond')
 ),
 (SELECT id FROM courses WHERE course_code='HIST 170A'),
 FALSE,
 'Seed data GE 4 course.'
);

-- ============================================================
-- 8) Prerequisites / Corequisites (seed examples)
-- ============================================================

-- CPSC 121 prerequisite: CPSC 120
INSERT INTO course_requirements (course_id, requirement_type, note)
VALUES (
    (SELECT id FROM courses WHERE course_code='CPSC 121'),
    'prerequisite',
    'Must complete CPSC 120.'
);
SET @req_cpsc121 := LAST_INSERT_ID();

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text)
VALUES
(@req_cpsc121, 1, 'course', (SELECT id FROM courses WHERE course_code='CPSC 120'), NULL, NULL);

-- CPSC 131 prerequisite: CPSC 121
INSERT INTO course_requirements (course_id, requirement_type, note)
VALUES (
    (SELECT id FROM courses WHERE course_code='CPSC 131'),
    'prerequisite',
    'Must complete CPSC 121.'
);
SET @req_cpsc131 := LAST_INSERT_ID();

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text)
VALUES
(@req_cpsc131, 1, 'course', (SELECT id FROM courses WHERE course_code='CPSC 121'), NULL, NULL);

-- CPSC 335 prerequisites (AND): CPSC 131 AND MATH 150A (different group_number => AND)
INSERT INTO course_requirements (course_id, requirement_type, note)
VALUES (
    (SELECT id FROM courses WHERE course_code='CPSC 335'),
    'prerequisite',
    'Must complete CPSC 131 and MATH 150A.'
);
SET @req_cpsc335 := LAST_INSERT_ID();

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text)
VALUES
(@req_cpsc335, 1, 'course', (SELECT id FROM courses WHERE course_code='CPSC 131'), NULL, NULL),
(@req_cpsc335, 2, 'course', (SELECT id FROM courses WHERE course_code='MATH 150A'), NULL, NULL);

-- PHYS 225 corequisite example: PHYS 225L (same term allowed)
INSERT INTO course_requirements (course_id, requirement_type, note)
VALUES (
    (SELECT id FROM courses WHERE course_code='PHYS 225'),
    'corequisite',
    'Must take PHYS 225L concurrently.'
);
SET @req_phys225_coreq := LAST_INSERT_ID();

INSERT INTO course_requirement_items (course_requirement_id, group_number, item_type, required_course_id)
VALUES
(@req_phys225_coreq, 1, 'course', (SELECT id FROM courses WHERE course_code='PHYS 225L'));

-- ============================================================
-- 9) Users + Preferences + Exams
-- ============================================================

INSERT INTO users (email, password_hash, google_uid, full_name, enrollment_status, available_winter, available_summer)
VALUES
('joe@test.com', NULL, NULL, 'Joe Test', 'fulltime', TRUE, TRUE),
('student2@test.com', NULL, NULL, 'Student Two', 'parttime', FALSE, TRUE);

INSERT INTO user_preferences (user_id, preferred_language, career_interest)
VALUES
((SELECT id FROM users WHERE email='joe@test.com'), 'Python', 'Web'),
((SELECT id FROM users WHERE email='student2@test.com'), 'Java', 'Data');

INSERT INTO user_exams (user_id, exam_name, passed, date_taken)
VALUES
((SELECT id FROM users WHERE email='joe@test.com'), 'CS Placement Exam', TRUE,  '2025-08-15'),
((SELECT id FROM users WHERE email='student2@test.com'), 'CS Placement Exam', FALSE, NULL);

-- ============================================================
-- 10) Course Plans + Plan Courses + Completed Courses
-- ============================================================

-- Plan for Joe
INSERT INTO course_plans (user_id, major_id, catalog_year_id, plan_name, is_active)
VALUES
(
 (SELECT id FROM users WHERE email='joe@test.com'),
 (SELECT id FROM majors WHERE major_acronym='CS'),
 (SELECT id FROM catalog_years WHERE catalog_name='Fall 2025 & Beyond'),
 'My First Plan',
 TRUE
);

SET @plan_joe := LAST_INSERT_ID();

-- Add planned courses (Spring 2026)
INSERT INTO plan_courses (plan_id, course_id, term, year, applied_to, note)
VALUES
(@plan_joe, (SELECT id FROM courses WHERE course_code='CPSC 121'), 'Spring', 2026, 'CS Core', NULL),
(@plan_joe, (SELECT id FROM courses WHERE course_code='MATH 150A'), 'Spring', 2026, 'Math',    NULL),
(@plan_joe, (SELECT id FROM courses WHERE course_code='ENGL 101'), 'Spring', 2026, 'GE 2A',   NULL);

-- Completed courses for Joe
INSERT INTO completed_courses (user_id, course_id, term, year, grade)
VALUES
((SELECT id FROM users WHERE email='joe@test.com'), (SELECT id FROM courses WHERE course_code='CPSC 120'), 'Fall', 2025, 'A'),
((SELECT id FROM users WHERE email='joe@test.com'), (SELECT id FROM courses WHERE course_code='HIST 170A'), 'Fall', 2025, 'B');

-- Plan for Student Two
INSERT INTO course_plans (user_id, major_id, catalog_year_id, plan_name, is_active)
VALUES
(
 (SELECT id FROM users WHERE email='student2@test.com'),
 (SELECT id FROM majors WHERE major_acronym='CS'),
 (SELECT id FROM catalog_years WHERE catalog_name='Fall 2025 & Beyond'),
 'Student Two Plan',
 TRUE
);

SET @plan_s2 := LAST_INSERT_ID();

INSERT INTO plan_courses (plan_id, course_id, term, year, applied_to)
VALUES
(@plan_s2, (SELECT id FROM courses WHERE course_code='CPSC 120'), 'Fall', 2025, 'CS Core'),
(@plan_s2, (SELECT id FROM courses WHERE course_code='MATH 150A'), 'Fall', 2025, 'Math');

-- ============================================================
-- Done
-- ============================================================