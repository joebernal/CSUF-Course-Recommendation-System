USE tuffyplan;

-- CS major GE requirement inserts
-- Area 1A
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 1, 3, 3, 'A grade of "C-" (1.7) or better is required in Areas 1A, 1B, and 1C. A "D+" (1.3) or below is not sufficient to satisfy these requirements.')
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 1), (SELECT id FROM courses WHERE course_code = 'ESE 100'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 1), (SELECT id FROM courses WHERE course_code = 'ESE 100W'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 1), (SELECT id FROM courses WHERE course_code = 'ENGL 101'), FALSE, NULL);

-- Area 1B
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 2, 3, 3, 'A grade of "C-" (1.7) or better is required in Areas 1A, 1B, and 1C. A "D+" (1.3) or below is not sufficient to satisfy these requirements.')
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 2), (SELECT id FROM courses WHERE course_code = 'BIOL 133'), FALSE, 'If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 2), (SELECT id FROM courses WHERE course_code = 'CNSM 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 2), (SELECT id FROM courses WHERE course_code = 'HONR 101A'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 2), (SELECT id FROM courses WHERE course_code = 'HCOM 235'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 2), (SELECT id FROM courses WHERE course_code = 'LBST 133'), FALSE, 'If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 2), (SELECT id FROM courses WHERE course_code = 'PHIL 105'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 2), (SELECT id FROM courses WHERE course_code = 'PHIL 106'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 2), (SELECT id FROM courses WHERE course_code = 'PHIL 133'), FALSE, 'If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 2), (SELECT id FROM courses WHERE course_code = 'PSYC 110'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 2), (SELECT id FROM courses WHERE course_code = 'READ 290A'), FALSE, 'Formerly READ 290');

-- Area 1C
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 3, 3, 3, 'A grade of "C-" (1.7) or better is required in Areas 1A, 1B, and 1C. A "D+" (1.3) or below is not sufficient to satisfy these requirements.')
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 3), (SELECT id FROM courses WHERE course_code = 'CHIC 102'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 3), (SELECT id FROM courses WHERE course_code = 'HONR 101B'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 3), (SELECT id FROM courses WHERE course_code = 'HCOM 100'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 3), (SELECT id FROM courses WHERE course_code = 'HCOM 102'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 3), (SELECT id FROM courses WHERE course_code = 'THTR 110'), FALSE, NULL);

-- Area 2A
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 4, 3, 3, 'A grade of ''C-'' (1.7) or better is required to meet this General Education requirement. A grade of ''D+'' (1.3) or below will not satisfy this General Education Requirement.')
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 4), (SELECT id FROM courses WHERE course_code = 'ESM 110'), FALSE, 'Cross-listed with MATH 110');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 4), (SELECT id FROM courses WHERE course_code = 'ESM 115A'), FALSE, 'Cross-listed with MATH 115A');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 4), (SELECT id FROM courses WHERE course_code = 'ESM 120'), FALSE, 'Cross-listed with MATH 120');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 4), (SELECT id FROM courses WHERE course_code = 'MATH 105'), FALSE, 'If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 4), (SELECT id FROM courses WHERE course_code = 'MATH 110'), FALSE, 'Cross-listed with ESM 110');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 4), (SELECT id FROM courses WHERE course_code = 'MATH 115'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 4), (SELECT id FROM courses WHERE course_code = 'MATH 115A'), FALSE, 'Cross-listed with ESM 115A');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 4), (SELECT id FROM courses WHERE course_code = 'MATH 120'), FALSE, 'Cross-listed with ESM 120');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 4), (SELECT id FROM courses WHERE course_code = 'MATH 125'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 4), (SELECT id FROM courses WHERE course_code = 'MATH 130'), FALSE, 'Formerly "A Short Course in Calculus"');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 4), (SELECT id FROM courses WHERE course_code = 'MATH 135'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 4), (SELECT id FROM courses WHERE course_code = 'MATH 150A'), FALSE, NULL);

-- Area 2U
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 5, 3, 3, '''+ indicates a course is a lab or includes a lab''')
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 5), (SELECT id FROM courses WHERE course_code = 'CPSC 313'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 5), (SELECT id FROM courses WHERE course_code = 'ECON 305'), FALSE, 'If taken Fall 2024 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 5), (SELECT id FROM courses WHERE course_code = 'FIN 310'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 5), (SELECT id FROM courses WHERE course_code = 'HCOM 308'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 5), (SELECT id FROM courses WHERE course_code = 'ISDS 361A'), FALSE, 'If taken between Fall 2019 and Spring 2026');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 5), (SELECT id FROM courses WHERE course_code = 'KNES 349'), FALSE, 'If taken in Spring 2024 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 5), (SELECT id FROM courses WHERE course_code = 'MATH 338'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 5), (SELECT id FROM courses WHERE course_code = 'MATH 380'), FALSE, 'If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 5), (SELECT id FROM courses WHERE course_code = 'PHIL 368'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 5), (SELECT id FROM courses WHERE course_code = 'PUBH 349'), FALSE, 'Formerly HESC 349');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 5), (SELECT id FROM courses WHERE course_code = 'SOCI 303'), FALSE, NULL);

-- Area 3A
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 6, 3, 3, NULL)
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 6), (SELECT id FROM courses WHERE course_code = 'ART 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 6), (SELECT id FROM courses WHERE course_code = 'ART 103'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 6), (SELECT id FROM courses WHERE course_code = 'ART 104'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 6), (SELECT id FROM courses WHERE course_code = 'ART 106A'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 6), (SELECT id FROM courses WHERE course_code = 'ART 107A'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 6), (SELECT id FROM courses WHERE course_code = 'ART 107B'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 6), (SELECT id FROM courses WHERE course_code = 'ART 201A'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 6), (SELECT id FROM courses WHERE course_code = 'ART 201B'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 6), (SELECT id FROM courses WHERE course_code = 'ART 205A'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 6), (SELECT id FROM courses WHERE course_code = 'DANC 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 6), (SELECT id FROM courses WHERE course_code = 'MUS 100'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 6), (SELECT id FROM courses WHERE course_code = 'MUS 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 6), (SELECT id FROM courses WHERE course_code = 'THTR 100'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 6), (SELECT id FROM courses WHERE course_code = 'THTR 160'), FALSE, 'Formerly "Acting for Non-Majors"');

-- Area 3B
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 7, 3, 3, NULL)
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'AFAM 250'), FALSE, 'Cross-listed with ASAM 250, CHIC 250, ENGL 250 | If taken Fall 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'ANTH 100'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'ARAB 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'ARAB 102'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'ARAB 203'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'ASAM 250'), FALSE, 'Cross-listed with AFAM 250, CHIC 250, ENGL 250 | If taken Fall 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'CHIC 250'), FALSE, 'Cross-listed with ASAM 250, AFAM 250, ENGL 250 | If taken Fall 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'CHIN 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'CHIN 102'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'CHIN 201'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'CHIN 202'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'CHIN 203'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'CHIN 204'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'ENGL 105'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'ENGL 200'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'ENGL 211'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'ENGL 212'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'ENGL 221'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'ENGL 222'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'ENGL 250'), FALSE, 'Cross-listed with ASAM 250, AFAM 250, CHIC 250 | If taken Fall 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'FREN 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'FREN 102'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'FREN 203'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'FREN 204'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'GRMN 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'GRMN 102'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'GRMN 203'), FALSE, 'If taken Fall 2024 or earlier');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'GRMN 204'), FALSE, 'If taken Fall 2024 or earlier');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'GRMN 214'), FALSE, 'If taken Fall 2023 or earlier');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'GSS 100'), FALSE, 'Formerly WGST 100');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'HIST 110A'), FALSE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'HIST 200'), FALSE, 'If taken in Spring 2021 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'HIST 210A'), FALSE, 'If taken in Spring 2021 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'HONR 210A'), FALSE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'ITAL 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'ITAL 102'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'JAPN 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'JAPN 102'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'JAPN 203'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'JAPN 204'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'KORE 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'KORE 102'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'KORE 203'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'KORE 204'), FALSE, 'If taken in Spring 2024 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'LBST 100'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'LING 106'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'PERS 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'PERS 102'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'PHIL 100'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'PHIL 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'PHIL 110'), FALSE, 'Cross-listed with RLST 110');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'PHIL 120'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'PHIL 290'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'PORT 105'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'PORT 214'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'RLST 105'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'RLST 110'), FALSE, 'Cross-listed with PHIL 110');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'RLST 200'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'RLST 210'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'RLST 250'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'RLST 270T'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'RLST 280'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'SPAN 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'SPAN 102'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'SPAN 202'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'SPAN 203'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'SPAN 204'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'SPAN 213'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'SPAN 214'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'VIET 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'VIET 102'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'VIET 201'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'VIET 202'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'VIET 203'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 7), (SELECT id FROM courses WHERE course_code = 'VIET 204'), FALSE, 'If taken Fall 2021 or later');

-- Area 3U
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 8, 3, 3, 'Explorations in the Arts and Humanities')
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'AFAM 314'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'AFAM 320'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'AFAM 324'), FALSE, 'Cross-listed with ENGL 324');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'AFAM 356'), TRUE, 'Cross-listed with MUS 356 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'AFAM 357'), TRUE, 'Cross-listed with MUS 357, THTR 357 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'AFAM 371'), FALSE, 'Cross-listed with DANC 371');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'AFAM 388'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'AMST 324'), TRUE, '*Overlay Z | If taken in Fall 2020 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'AMST 345'), TRUE, '*Overlay Z | If taken in Fall 2021 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ANTH 304'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ANTH 305'), TRUE, 'Cross-listed with RLST 305 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ANTH 306'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ANTH 311'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ART 311'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ART 312'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ART 380'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ART 382'), FALSE, 'If taken Spring 2025 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ASAM 320'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ASAM 325'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ASAM 327'), TRUE, 'Cross-listed with ENGL 327 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIC 302'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIC 304'), TRUE, 'Cross-listed with MUS 304 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIC 315'), TRUE, 'Cross-listed with THTR 315 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIC 316'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIC 330'), TRUE, '*Overlay Z | If taken Fall 2024 or earlier');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIC 333'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIC 336'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIC 337'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIC 340'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIC 367'), TRUE, 'Cross-listed with RLST 367 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIC 369'), TRUE, 'Cross-listed with CTVA 369 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIN 310'), FALSE, 'If taken in Spring 2024 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIN 311'), FALSE, 'If taken in Spring 2024 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIN 315'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIN 325'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIN 385'), TRUE, '*Overlay Z | If taken Fall 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CHIN 390'), FALSE, 'If taken in Spring 2024 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'COMM 300'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CPLT 312'), FALSE, 'Cross-listed with RLST 312');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CPLT 315'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CPLT 324'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CPLT 325'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CPLT 356'), FALSE, 'Cross-listed with ENGL 356');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CPLT 380'), TRUE, 'Cross-listed with ENGL 380 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CPLT 381'), TRUE, 'Cross-listed with ENGL 381 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CPLT 382T'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CTVA 305'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CTVA 369'), TRUE, 'Cross-listed with CHIC 369 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CTVA 372'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CTVA 373'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'CTVA 374'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'DANC 301'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'DANC 371'), TRUE, 'Cross-listed with AFAM 371 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ENGL 306'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ENGL 324'), FALSE, 'Cross-listed with AFAM 324');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ENGL 327'), TRUE, 'Cross-listed with ASAM 327 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ENGL 328'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ENGL 331'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ENGL 341'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ENGL 356'), FALSE, 'Cross-listed with CPLT 356');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ENGL 380'), TRUE, 'Cross-listed with CPLT 380 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'ENGL 381'), TRUE, 'Cross-listed with CPLT 381 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'FREN 315'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'FREN 325'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'FREN 375'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'GEOG 357'), FALSE, 'If taken in Fall 2023 or later.');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'GRMN 315'), TRUE, '*Overlay Z | If taken Fall 2023 or earlier');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'GRMN 325'), TRUE, '*Overlay Z | If taken Fall 2023 or earlier');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'GRMN 335'), FALSE, 'If taken Fall 2023 or earlier');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'GSS 320'), TRUE, '*Overlay Z | If taken Fall 2022 or later | Formerly WGST 320');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'GSS 340'), TRUE, '*Overlay Z | If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'HIST 314'), FALSE, 'If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'HIST 341'), FALSE, 'Cross-listed with LBST 341');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'HIST 377'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'HONR 302T'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'HSS 350'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'JAPN 315'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'JAPN 316'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'JAPN 375'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'JAPN 390'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'KNES 380'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'KORE 380'), FALSE, 'If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'LBST 323'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'LBST 335'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'LBST 341'), FALSE, 'Cross-listed with HIST 341');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'MUS 302'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'MUS 303'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'MUS 304'), TRUE, 'Cross-listed with CHIC 304 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'MUS 305'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'MUS 307'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'MUS 350'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'MUS 355'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'MUS 356'), TRUE, 'Cross-listed with AFAM 356 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'MUS 357'), TRUE, 'Cross-listed with AFAM 357, THTR 357 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'PHIL 300'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'PHIL 311'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'PHIL 312'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'PHIL 313'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'PHIL 314'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'PHIL 320'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'PHIL 323'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'PHIL 325'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'PHIL 349'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'PHIL 350'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'PHIL 379'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'PORT 320'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'POSC 340'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 305'), TRUE, 'Cross-listed with ANTH 305 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 307'), FALSE, 'If taken in Spring 2023 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 312'), FALSE, 'Cross-listed with CPLT 312');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 341'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 342'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 351'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 352'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 361'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 362'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 367'), TRUE, 'Cross-listed with CHIC 367 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 371'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 372'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 373'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 374'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'RLST 375'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'SPAN 315'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'SPAN 316'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'SPAN 325'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'SPAN 326'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'SPAN 375'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'THTR 300'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'THTR 311'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'THTR 315'), TRUE, 'Cross-listed with CHIC 315 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'THTR 320'), TRUE, '*Overlay Z | If taken Spring 2024 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'THTR 331'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'THTR 357'), TRUE, 'Cross-listed with AFAM 357, MUS 357 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'THTR 383'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'VIET 315'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'VIET 325'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'VIET 375'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'VIET 385'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'VIET 390'), TRUE, '*Overlay Z | If taken Spring 2025 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 8), (SELECT id FROM courses WHERE course_code = 'VIET 395'), TRUE, '*Overlay Z | If taken Spring 2025 or later');

-- Area 4A
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 9, 3, 3, 'Introduction to Social Sciences')
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'AGNG 133'), FALSE, 'Cross-listed with PSYC 133 | Formerly GERO');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'AMST 101'), FALSE, 'Formerly Introduction to American Culture Studies');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'AMST 131'), TRUE, 'Cross-listed with CAS 131, READ 131 | If taken Fall 2025 or later | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'ANTH 102'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'ANTH 103'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'ANTH 105'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'ASAM 201'), FALSE, 'Cross-listed with HIST 201');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'CAS 101'), FALSE, 'If taken Fall 2025 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'CAS 131'), TRUE, 'Cross-listed with AMST 131, READ 131 | If taken Fall 2025 or later | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'CHIC 220'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'COMM 233'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'CRJU 100'), FALSE, 'Formerly: Intro to Crime, Law, & Justice');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'ECON 100'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'ECON 201'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'ECON 202'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'GEOG 100'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'GEOG 160'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'GSS 205'), TRUE, 'If taken Fall 2025 or later | *Overlay Z | Formerly WGST 205');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'HIST 110B'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'HIST 201'), FALSE, 'Cross-listed with ASAM 201');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'HIST 230'), FALSE, 'If taken in Spring 2021 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'HIST 231'), FALSE, 'If taken in Spring 2021 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'HONR 210B'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'HUSR 133'), FALSE, 'Cross-listed with AGNG 133, PSYC 133');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'LBST 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'LING 102'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'LTAM 100'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'POSC 200'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'PSYC 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'PSYC 133'), FALSE, 'Cross-listed with AGNG 133, HUSR 133');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'PUBH 101'), FALSE, 'If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'PUBH 133'), FALSE, 'Cross-listed with AGNG 133, PSYC 133 | Formerly HESC');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'READ 131'), TRUE, 'Cross-listed with AMST 131, CAS 131 | If taken Fall 2025 or later | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'READ 295'), FALSE, 'If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'RLST 100'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'SOCI 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'SOCI 133'), FALSE, 'Cross-listed with AGNG 133, PSYC 133');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 9), (SELECT id FROM courses WHERE course_code = 'SOCI 201'), FALSE, 'If taken Fall 2026 or later');

-- Area 4B
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 10, 3, 3, 'American History, Institutions, and Values')
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 10), (SELECT id FROM courses WHERE course_code = 'AFAM 190'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 10), (SELECT id FROM courses WHERE course_code = 'AMST 201'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 10), (SELECT id FROM courses WHERE course_code = 'ASAM 190'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 10), (SELECT id FROM courses WHERE course_code = 'CHIC 190'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 10), (SELECT id FROM courses WHERE course_code = 'HIST 170A'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 10), (SELECT id FROM courses WHERE course_code = 'HIST 170B'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 10), (SELECT id FROM courses WHERE course_code = 'HIST 180'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 10), (SELECT id FROM courses WHERE course_code = 'HIST 190'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 10), (SELECT id FROM courses WHERE course_code = 'HONR 201A'), FALSE, NULL);

-- Area 4U
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 11, 3, 3, 'Explorations in the Social and Behavioral Sciences')
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'AFAM 301'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'AFAM 304'), TRUE, 'Cross-listed with SOCI 304 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'AFAM 308'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'AFAM 310'), TRUE, 'Cross-listed with GSS 310 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'AFAM 311'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'AFAM 322'), FALSE, 'Cross-listed with PSYC 322');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'AFAM 325'), TRUE, 'Cross-listed with RLST 325 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'AFAM 335'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'AFAM 370'), TRUE, 'Cross-listed with CAS 370 | *Overlay Z | If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'AGNG 313'), TRUE, '*Overlay Z | Formerly GERO 313');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'AMST 300'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'AMST 301'), TRUE, '*Overlay Z | Formerly American Character');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'AMST 395'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ANTH 300'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ANTH 310'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ANTH 313'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ANTH 321'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ANTH 325'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ANTH 327'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ANTH 329'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ANTH 340'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ANTH 347'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ANTH 350'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ANTH 383'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ASAM 300'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ASAM 342'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ASAM 344'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ASAM 346'), TRUE, 'Cross-listed with PSYC 346 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ASAM 360'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ASAM 362A'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ASAM 364'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ASAM 366'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ASAM 382'), FALSE, 'Cross-listed with HIST 382');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CAS 312'), FALSE, 'If taken Fall 2025 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CAS 315'), TRUE, 'If taken Fall 2025 or later | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CAS 330'), FALSE, 'If taken Fall 2025 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CAS 340'), TRUE, 'If taken Fall 2025 or later | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CAS 370'), TRUE, 'Cross-listed with AFAM 370 | *Overlay Z | If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CHIC 303'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CHIC 305'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CHIC 313'), TRUE, 'Cross-listed with GSS 313 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CHIC 325'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CHIC 331'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CHIC 332'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CHIC 345'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CHIC 350'), TRUE, 'Cross-listed with LTAM 350 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CHIC 353'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CHIC 360'), TRUE, 'Cross-listed with READ 360 | *Overlay Z | If taken Spring 2023 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'COMM 315'), TRUE, '*Overlay Z | If taken in Fall 2020 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'COMM 328'), FALSE, 'If taken Fall 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'COMM 333'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'COMM 370'), FALSE, 'Formerly COMM 425');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'COUN 380'), FALSE, 'Cross-listed with HUSR 380');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CRJU 300'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CRJU 320'), FALSE, 'Cross-listed with POSC 320');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CRJU 322'), FALSE, 'Cross-listed with POSC 322');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CRJU 385'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'CTVA 365'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ECON 330'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ECON 332'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ECON 333'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ECON 334'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ECON 335'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ECON 336'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ECON 350'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ECON 355'), FALSE, 'Cross-listed with GSS 355');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ECON 360'), FALSE, 'If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'ECON 362'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'EDEL 325'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'EDSC 320'), TRUE, '*Overlay Z | If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GEOG 321'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GEOG 330'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GEOG 332'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GEOG 333'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GEOG 340'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GEOG 345'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GEOG 371'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GEOG 372'), FALSE, 'If taken Fall 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GEOG 373'), FALSE, 'If taken Fall 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GSS 302'), TRUE, 'Cross-listed with PHIL 302 | *Overlay Z | Formerly WGST 302');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GSS 310'), TRUE, 'Cross-listed with AFAM 310 | *Overlay Z | Formerly WGST 310');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GSS 313'), TRUE, 'Cross-listed with CHIC 313 | *Overlay Z | Formerly WGST 313');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GSS 355'), FALSE, 'Cross-listed with ECON 355 | Formerly WGST 355');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GSS 360'), TRUE, '*Overlay Z | Formerly WGST 360');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'GSS 485'), FALSE, 'Cross-listed with POSC 485 | Formerly WGST 485');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HCOM 315'), TRUE, '*Overlay Z | If taken in Spring 2021 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HCOM 320'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HCOM 340'), TRUE, 'Cross-listed with ASAM 340 | *Overlay Z | If taken Fall 2023 or earlier');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HCOM 342'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HCOM 370'), FALSE, 'If taken in Spring 2021 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HIST 310'), TRUE, 'Cross-listed with LBST 310 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HIST 311'), FALSE, 'If taken in Fall 2020 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HIST 315'), TRUE, 'Cross-listed with LBST 315 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HIST 320'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HIST 350'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HIST 360'), FALSE, 'If taken in Spring 2020 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HIST 382'), FALSE, 'Cross-listed with ASAM 382');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HIST 386A'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HIST 395'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HONR 303T'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'HUSR 380'), FALSE, 'Cross-listed with COUN 380');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'KNES 381'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'LBST 310'), TRUE, 'Cross-listed with HIST 310 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'LBST 315'), TRUE, 'Cross-listed with HIST 315 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'LBST 322'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'LBST 340'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'LTAM 300'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'LTAM 350'), TRUE, 'Cross-listed with CHIC 350 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'NURS 402'), FALSE, 'If taken Fall 2019 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'PHIL 302'), TRUE, 'Cross-listed with GSS 302 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'PHIL 377'), TRUE, '*Overlay Z | If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'POSC 300'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'POSC 309'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'POSC 310'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'POSC 315'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'POSC 320'), FALSE, 'Cross-listed with CRJU 320');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'POSC 322'), FALSE, 'Cross-listed with CRJU 322');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'POSC 330'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'POSC 350'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'POSC 352'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'POSC 375'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'POSC 381'), FALSE, 'Cross-listed with RLST 381');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'POSC 485'), FALSE, 'Cross-listed with GSS 485');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'PSYC 311'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'PSYC 321'), TRUE, 'Cross-listed with RLST 321 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'PSYC 322'), TRUE, 'Cross-listed with AFAM 322 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'PSYC 331'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'PSYC 341'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'PSYC 346'), TRUE, 'Cross-listed with ASAM 346 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'PSYC 351'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'PUBH 321'), FALSE, 'If taken Fall 2025 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'PUBH 381'), TRUE, '*Overlay Z | If taken Fall 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'READ 360'), TRUE, 'Cross-listed with CHIC 360 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'RLST 321'), TRUE, 'Cross-listed with PSYC 321 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'RLST 325'), TRUE, 'Cross-listed with AFAM 325 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'RLST 333'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'RLST 370'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'RLST 381'), FALSE, 'Cross-listed with POSC 381');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'SOCI 304'), TRUE, 'Cross-listed with AFAM 304 | *Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'SOCI 306'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'SOCI 351'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'SOCI 352'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'SOCI 353'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'SOCI 354'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'SOCI 355'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'SOCI 356'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'SOCI 357'), TRUE, '*Overlay Z');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'SOCI 361'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'SOCI 365'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'SOCI 371'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'SOCI 385'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 11), (SELECT id FROM courses WHERE course_code = 'SPED 322'), FALSE, 'If taken Spring 2026 or later');

-- Area 5A
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 12, 3, 3, '+ indicates a course is a lab or includes a lab')
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'ASTR 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'CHEM 100'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'CHEM 102'), FALSE, 'Cross-listed with PHYS 102 | Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'CHEM 105'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'CHEM 111'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'CHEM 120A'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'CHEM 200'), FALSE, 'If taken in Spring 2021 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'GEOG 110'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'GEOL 100'), FALSE, 'If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'GEOL 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'GEOL 102'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'GEOL 110T'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'PHYS 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'PHYS 155'), FALSE, 'If taken in Spring 2024 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'PHYS 211'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 12), (SELECT id FROM courses WHERE course_code = 'PHYS 225'), FALSE, NULL);

-- Area 5B
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 13, 3, 3, '+ indicates a course is a lab or includes a lab')
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 13), (SELECT id FROM courses WHERE course_code = 'ANTH 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 13), (SELECT id FROM courses WHERE course_code = 'BIOL 101'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 13), (SELECT id FROM courses WHERE course_code = 'BIOL 102'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 13), (SELECT id FROM courses WHERE course_code = 'BIOL 103'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 13), (SELECT id FROM courses WHERE course_code = 'BIOL 151'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 13), (SELECT id FROM courses WHERE course_code = 'BIOL 152'), FALSE, 'Includes lab');

-- Area 5C
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 14, 1, 1, '+ indicates a course is a lab or includes a lab')
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'ASTR 101L'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'BIOL 101L'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'BIOL 102'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'BIOL 151'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'BIOL 152'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'CHEM 100L'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'CHEM 102'), FALSE, 'Cross-listed with PHYS 102 | Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'CHEM 120A'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'CHEM 200'), FALSE, 'If taken in Spring 2021 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'GEOG 110L'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'GEOL 101L'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'GEOL 102'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'PHYS 101L'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'PHYS 211L'), FALSE, 'Includes lab');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 14), (SELECT id FROM courses WHERE course_code = 'PHYS 225L'), FALSE, 'Includes lab');

-- Area 5U
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 15, 0, 3, 'Implications and Exploration of Mathematics and Natural Sciences')
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'AMST 332'), FALSE, 'If taken in Fall 2023 or later.');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'ANTH 301'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'ANTH 322'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'ANTH 344'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'BIOL 300'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'BIOL 304'), FALSE, 'If taken Spring 2025 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'BIOL 305'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'BIOL 306'), FALSE, 'If taken in Spring 2020 or later | If taken in Fall 2019 or earlier, counts for GE Area E');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'BIOL 310'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'BIOL 318'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'BIOL 319'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'BIOL 352'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'BIOL 360'), FALSE, 'If taken in Spring 2020 or later | If taken in Fall 2019 or earlier, counts for GE Area E');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'CHEM 313A'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'CHEM 313B'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'CHEM 313C'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'COMD 303'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'EGCE 305'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'GEOG 328'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'GEOG 329'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'GEOL 310T'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'GEOL 333'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'HIST 325'), FALSE, 'Cross-listed with LBST 325 | If taken Spring 2023 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'HIST 330'), FALSE, 'Cross-listed with LBST 330');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'HIST 331'), FALSE, 'Cross-listed with LBST 331');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'HONR 301T'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'HONR 305'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'LBST 325'), FALSE, 'Cross-listed with HIST 325 | If taken Spring 2023 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'LBST 330'), FALSE, 'Cross-listed with HIST 330');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'LBST 331'), FALSE, 'Cross-listed with HIST 331');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'LBST 333'), FALSE, 'Cross-listed with PHIL 333');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'NURS 345'), FALSE, 'If taken in Spring 2022 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'PHIL 303'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'PHIL 322'), FALSE, 'If taken Spring 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'PHIL 333'), FALSE, 'Cross-listed with LBST 333');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'PHYS 301'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'PHYS 305'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'PUBH 350'), FALSE, 'Counts for B.5 if taken in Spring 2021 or later; counts for E if taken Fall 2020 or earlier');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 15), (SELECT id FROM courses WHERE course_code = 'PUBH 358'), FALSE, 'If taken Spring 2026 or later');

-- Area 6
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 16, 3, 3, 'Ethnic Studies')
ON DUPLICATE KEY UPDATE id = id;
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'AFAM 101'), FALSE, 'Cross-listed with ASAM 101, CHIC 101');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'AFAM 107'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'AFAM 160'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'AFAM 260'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'AFAM 280'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'AFAM 361'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'AFAM 389'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'ASAM 101'), FALSE, 'Cross-listed with AFAM 101, CHIC 101');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'ASAM 202'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'ASAM 230'), FALSE, 'If taken Fall 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'ASAM 303'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'ASAM 308'), FALSE, 'If taken Fall 2026 or later');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'CHIC 101'), FALSE, 'Cross-listed with AFAM 101, ASAM 101');
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'CHIC 106'), FALSE, NULL);
INSERT INTO major_ge_courses (major_ge_requirement_id, course_id, counts_for_z, note)
VALUES ((SELECT id FROM major_ge_requirements WHERE major_id = 1 AND catalog_year_id = 1 AND ge_area_id = 16), (SELECT id FROM courses WHERE course_code = 'CHIC 201'), FALSE, NULL);

-- Area Z
INSERT INTO major_ge_requirements (major_id, catalog_year_id, ge_area_id, required_units_min, required_units_max, note)
VALUES (1, 1, 17, 3, 3, 'One (1) GE course in Area 2U, Area 3, Area 4, or Area 5 must double-count as a Z course (noted with an asterisk*)')
ON DUPLICATE KEY UPDATE id = id;
