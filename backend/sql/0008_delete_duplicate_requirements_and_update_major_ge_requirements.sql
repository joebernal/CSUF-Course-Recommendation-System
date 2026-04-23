DELETE FROM course_requirements
WHERE id IN (638, 639, 640, 641, 649, 652);

DELETE FROM course_requirements
WHERE id = 7;

DELETE FROM course_requirement_items
WHERE id = 1304;

DELETE FROM course_requirements WHERE id = 5;

DELETE FROM course_requirement_items
WHERE id = 51;

UPDATE major_ge_requirements
SET required_units_min = 0,
    required_units_max = 0
WHERE id IN (4, 5, 12, 13, 14, 15);