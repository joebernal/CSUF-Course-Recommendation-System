/* =========================================================
   1) COURSES
   Only expanded courses are included.
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'AFAM 160',
    'Introduction to Black Creative Expression',
    'Introduction to Black originators and innovators of art forms, such as performing, literary and visual. Critical responses to art forms in both historical and contemporary contexts. Understand trends in creativity and imagination that cross expressive forms in Black communities.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'AFAM 250',
    'Introduction to Multi-Ethnic Literatures of the U.S.',
    'Introducing multi-ethnic literatures of the U. S., the course considers texts within their cultural, historical, and socio-political contexts. Relates multi-ethnic literature to the creative and performing arts. Themes covered may include diaspora, migration, memory, history, citizenship, and/or ethnic identities. (CHIC 250, AFAM 250, ASAM 250 and ENGL 250 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'AFAM 260',
    'Black Lives Matter Creative and Critical Ideas',
    'Black Lives Matter movement origins, controversies and legacies. Creative and critical responses to social activism in communities of color. Engaging critical debates around over-policing, anti-black racism and bias.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'AFAM 280',
    'Introduction to African American History',
    'Introduction to key events, individuals, institutions and experiences that shaped the history and culture of Africans and their descendants from their arrival in North America in 1619 to the present.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'AFAM 361',
    'Black Environmentalism',
    'Environmental racism, crises and justice issues for communities of color. Origins of Black environmentalism, slavery, Jim Crow segregation and impact on the relationship between African Americans with nature and the environment. Creative expressions of Black environmentalism.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'AFAM 370',
    'Development of African American Children and Youth',
    'Understanding cognitive and socio-emotional development of African American children and youth is facilitated through comprehensive examinations of significant African and African American cultural and historical experiences. (CAS 370 and AFAM 370 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'AFAM 371',
    'African American Concert Dance History',
    'Production of African derived dance from within American culture. Consideration of the history of dance artists’ biographic and critical theory literature from diverse media. Includes a lab involving choreography and performance of major African American concert dance forms. (DANC 371 and AFAM 371 are the same course)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'AFAM 388',
    'Hip Hop Culture',
    'Origins and influences of hip hop on culture, fashion, movies, television, advertising, attitude, music, dancing and slang among African Americans. Impact of the hip hop culture phenomenon on American and global societies.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'AFAM 389',
    'Black Latinx Identity',
    'The relationship between Blackness and Latin American identity formation and social movements of Black-identified Latino/a/x people. Will pay particular attention to slavery within the United States, Caribbean and Latin America; racial classification laws and social movements.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   Using INSERT ... SELECT ... WHERE NOT EXISTS so reruns
   do not duplicate rows.
   ========================================================= */

/* AFAM 370 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'AFAM 370'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* AFAM 371 prerequisite: GE Area 3A or 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 3B'
FROM courses c
WHERE c.course_code = 'AFAM 371'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 3B'
  );

/* AFAM 389 restriction: Department Consent Required */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'restriction', 'Department Consent Required'
FROM courses c
WHERE c.course_code = 'AFAM 389'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'restriction'
        AND cr.note = 'Department Consent Required'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Encodes AND/OR logic using group_number.
   - AFAM 370: one text item => GE Area 4A
   - AFAM 371: OR within same group => GE Area 3A OR GE Area 3B
   - AFAM 389: one text item => Department Consent Required
   ========================================================= */

/* AFAM 370 -> prerequisite -> text item: GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'AFAM 370'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* AFAM 371 -> prerequisite -> text item: GE Area 3A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'AFAM 371'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

/* AFAM 371 -> prerequisite -> text item: GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'AFAM 371'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* AFAM 389 -> restriction -> text item: Department Consent Required */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Department Consent Required'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'AFAM 389'
  AND cr.requirement_type = 'restriction'
  AND cr.note = 'Department Consent Required'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Department Consent Required'
  );
  
  /* =========================================================
   1) COURSES
   Only courses with expanded catalog details are included.
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'AGNG 133',
    'Introduction to Aging Studies',
    'Multidisciplinary overview of: characteristics, strengths and problems of older persons; diversity in aging process involving gender, race, ethnicity, subculture; services to older adults; gerontology as an academic discipline and a field of practice. (AGNG 133, SOCI 133, PUBH 133, HUSR 133 and PSYC 133 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'AGNG 313',
    'California Gold: Diversity and Aging',
    'California serves as a microcosm for studying diversity and aging. Course considers race/ethnicity, gender, disability, income, sexual orientation and religion among aging Californians. Highlights discrimination, racism and current/future needs and support services in the context of current events.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* AGNG 313 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'AGNG 313'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */

/* AGNG 313 -> prerequisite -> text item: GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'AGNG 313'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );
  
  /* =========================================================
   1) COURSES
   Only courses with expanded catalog details are included.
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'AMST 131',
    'Explore Core: Migrant Lives',
    'Differing sociocultural experiences of different migrant groups. How immigration as a process impacts physical, cognitive and socioemotional development of migrants’ children. Educational experiences of migrants and implications for schools and society. (CAS 131, AMST 131 and READ 131 are the same course)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'AMST 324',
    'American Immigrant Cultures',
    'Investigates American immigrant communities, both historical and contemporary, to better understand how their experiences helped shape the meaning of being American. Explores immigrant cultures through literature, music, film, oral history and photographs using interdisciplinary methods.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'AMST 332',
    'Science and Modern America',
    'Interdisciplinary analysis of the relationship between science and culture in the American past and present. Topics include questions of trust, ethics, objectivity, power and identity in developing scientific knowledge in health and medicine, the environment, and technology.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* AMST 324 prerequisite: GE Area 3A or 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 3B'
FROM courses c
WHERE c.course_code = 'AMST 324'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 3B'
  );

/* AMST 332 prerequisite: GE Area 5A and 5B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 5A and 5B'
FROM courses c
WHERE c.course_code = 'AMST 332'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 5A and 5B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Encodes AND/OR logic using group_number.
   - Different group_number = AND between groups
   - Same group_number = OR inside the group
   ========================================================= */

/* AMST 324 -> prerequisite -> GE Area 3A OR GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'AMST 324'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'AMST 324'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* AMST 332 -> prerequisite -> GE Area 5A AND GE Area 5B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'AMST 332'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A and 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'AMST 332'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A and 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );
  
  /* =========================================================
   1) COURSES
   Only courses with expanded catalog details are included.
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'ANTH 301',
    'Primate Behavior',
    'Anthropological study of the behavior of primates, including monkeys and apes with data collection in the wild and the laboratory; review and discussion of behavioral characteristics that are part of the primate heritage of humankind.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ANTH 322',
    'Human Behavioral Ecology',
    'Examines human biological and cultural diversity through an analysis of comparative socioecology using modern evolutionary theory. Topics covered include reproduction and marriage, the family, childhood, population growth and conservation. Computer labs utilizing eHRAF.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ANTH 383',
    'Archaeology of North America',
    'Change, development and diversity of adaptations of North American Indian cultures prior to European colonization. Uses archaeological data to describe and explain long-term processes of cultural change during ancient times in North America.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* ANTH 301 prerequisite: ANTH 101, ANTH 102, PSYC 101 or GE Area 5A or 5B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'ANTH 101, ANTH 102, PSYC 101 or GE Area 5A or 5B'
FROM courses c
WHERE c.course_code = 'ANTH 301'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'ANTH 101, ANTH 102, PSYC 101 or GE Area 5A or 5B'
  );

/* ANTH 322 prerequisite: GE Area 5B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 5B'
FROM courses c
WHERE c.course_code = 'ANTH 322'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 5B'
  );

/* ANTH 383 prerequisite: GE Area 4A; for anthropology majors, GE Area 4A or any ANTH course in GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A; for anthropology majors, GE Area 4A or any ANTH course in GE Area 4A'
FROM courses c
WHERE c.course_code = 'ANTH 383'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A; for anthropology majors, GE Area 4A or any ANTH course in GE Area 4A'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Encodes AND/OR logic using group_number.
   - Different group_number = AND between groups
   - Same group_number = OR inside the group
   ========================================================= */

/* ---------------------------------------------------------
   ANTH 301
   Parsed as:
   (ANTH 101 AND ANTH 102 AND (PSYC 101 OR GE Area 5A OR GE Area 5B))
   --------------------------------------------------------- */

/* group 1: ANTH 101 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ANTH 101'
WHERE c.course_code = 'ANTH 301'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'ANTH 101, ANTH 102, PSYC 101 or GE Area 5A or 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* group 2: ANTH 102 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ANTH 102'
WHERE c.course_code = 'ANTH 301'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'ANTH 101, ANTH 102, PSYC 101 or GE Area 5A or 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* group 3 option: PSYC 101 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 3, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'PSYC 101'
WHERE c.course_code = 'ANTH 301'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'ANTH 101, ANTH 102, PSYC 101 or GE Area 5A or 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 3
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* group 3 option: GE Area 5A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 3, 'text', NULL, NULL, 'GE Area 5A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ANTH 301'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'ANTH 101, ANTH 102, PSYC 101 or GE Area 5A or 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 3
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5A'
  );

/* group 3 option: GE Area 5B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 3, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ANTH 301'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'ANTH 101, ANTH 102, PSYC 101 or GE Area 5A or 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 3
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );


/* ---------------------------------------------------------
   ANTH 322
   GE Area 5B
   --------------------------------------------------------- */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ANTH 322'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );


/* ---------------------------------------------------------
   ANTH 383
   Catalog note is major-specific, so this is stored as text items.
   Parsed conservatively as:
   - default path: GE Area 4A
   - anth majors alternate path: any ANTH course in GE Area 4A
   Both are kept as text because your schema cannot directly model
   "for anthropology majors" as a separate condition cleanly.
   --------------------------------------------------------- */

/* option 1: GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ANTH 383'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A; for anthropology majors, GE Area 4A or any ANTH course in GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* option 2: any ANTH course in GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Any ANTH course in GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ANTH 383'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A; for anthropology majors, GE Area 4A or any ANTH course in GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Any ANTH course in GE Area 4A'
  );
  
  /* =========================================================
   1) COURSES
   Only courses with expanded catalog details are included.
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'ART 382',
    'Art and Social Justice',
    'Create art lessons and art projects to share with community partners via teaching experiences. Work directly with community to teach and create social justice service projects and public practice projects in alternative venues.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* ART 382 prerequisite: GE Area 3A or 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 3B'
FROM courses c
WHERE c.course_code = 'ART 382'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 3B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   - Same group_number = OR
   ========================================================= */

/* ART 382 -> prerequisite -> GE Area 3A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ART 382'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

/* ART 382 -> prerequisite -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ART 382'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );
  
  /* =========================================================
   1) COURSES
   Only courses with expanded catalog details are included.
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'ASAM 202',
    'Ideas, Imagination and Intersections in Ethnic Studies/Asian American Studies',
    'Understand contemporary Ethnic Studies/Asian American Studies by examining their roots and agency to imagine a society beyond our nation’s historical legacies. Students consider their life experiences through core concepts, research and creative works, and intersectional topics and identities in ES/ASAM.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ASAM 250',
    'Introduction to Multi-Ethnic Literatures of the U.S.',
    'Introducing multi-ethnic literatures of the U. S., the course considers texts within their cultural, historical, and socio-political contexts. Relates multi-ethnic literature to the creative and performing arts. Themes covered may include diaspora, migration, memory, history, citizenship, and/or ethnic identities. (CHIC 250, AFAM 250, ASAM 250 and ENGL 250 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ASAM 303',
    'Community, Liberation and Action in Ethnic Studies/Asian American Studies',
    'Examine Asian American Studies’ historical legacies, community formation and social movements to address issues impacting APIDA communities, e.g., justice, identity, oppression. Apply knowledge of activism, creativity and liberation to design, implement and evaluate transformative action projects.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ASAM 320',
    'Asian Pacific American Cultural Studies',
    'Asian American life as portrayed through novels, short stories, plays, poetry, film, music, painting, dance and other expressive forms. Examines historical and contemporary works by a variety of Asian and Pacific Americans.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* ASAM 320 prerequisite: GE Areas 3A and 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Areas 3A and 3B'
FROM courses c
WHERE c.course_code = 'ASAM 320'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Areas 3A and 3B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   - Different group_number = AND
   ========================================================= */

/* ASAM 320 -> prerequisite -> GE Area 3A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ASAM 320'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 3A and 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

/* ASAM 320 -> prerequisite -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ASAM 320'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 3A and 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );
  
  /* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'ASTR 101',
    'Introduction to Astronomy',
    'The science of stars, planets, moons and our Sun. Starlight, galaxies and the history of our universe, alien planets and black holes. High school algebra recommended. Co-enrollment in ASTR 101L recommended.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ASTR 101L',
    'Introduction to Astronomy Laboratory',
    'Laboratory course investigating the fundamental concepts of astronomy; motion of the night sky, phases of the moon, telescopes, history and composition of the universe, and modern astronomical discoveries.',
    1.0,
    1.0,
    TRUE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* ASTR 101L corequisite: ASTR 101 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'ASTR 101'
FROM courses c
WHERE c.course_code = 'ASTR 101L'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'corequisite'
        AND cr.note = 'ASTR 101'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */

/* ASTR 101L -> corequisite -> ASTR 101 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ASTR 101'
WHERE c.course_code = 'ASTR 101L'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'ASTR 101'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );


/* =========================================================
   4) COURSE PAIRS
   Pair ASTR 101 with ASTR 101L as lecture_lab
   ========================================================= */

INSERT INTO course_pairs (
    course_id,
    paired_course_id,
    pair_type
)
SELECT c1.id, c2.id, 'lecture_lab'
FROM courses c1
JOIN courses c2
  ON c1.course_code = 'ASTR 101'
 AND c2.course_code = 'ASTR 101L'
WHERE NOT EXISTS (
    SELECT 1
    FROM course_pairs cp
    WHERE cp.course_id = c1.id
      AND cp.paired_course_id = c2.id
      AND cp.pair_type = 'lecture_lab'
);

/* =========================================================
   1) COURSES
   Only courses with expanded catalog details are included.
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'BIOL 103',
    'Biology of Disease',
    'The role of evolution, environment, genetics, physiology, cells, bacteria and viruses in disease. For non-science majors. No credit towards biological science major.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'BIOL 133',
    'Explore Core: Truth',
    'Nature, significance and knowability of truth, exploring perspectives from philosophy, history, journalism, criminal justice, mathematics, engineering and the natural sciences. How is truth made or discovered? And why and when we should we trust the truths that emerge? (PHIL 133, BIOL 133, EGME 133, LBST 133 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'BIOL 304',
    '21st Century Virology',
    'Principles of virology addressing virus infection strategies and recent scientific advances to prevent infection or severe illness, with special attention on the SARS Coronavirus-2. Application of viruses in biotechnology. No credit toward biological science major.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'BIOL 305',
    'Human Heredity and Development',
    'Principles of human heredity and embryology relating to human development. Mendelian genetics, single gene effects, molecular genetics, prenatal diagnosis and human embryology. No credit toward biological science major.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'BIOL 318',
    'Wildlife Conservation',
    'Causes and consequences of loss of biological diversity, emphasizing wildlife populations and science-based conservation. Threatened and endangered species/ecosystems, ecosystem management, habitat restoration, captive species reintroductions and conservation legislation. No credit toward biology major.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'BIOL 319',
    'Marine Biology',
    'Marine plants and animals in their habitats. No credit toward biological science major.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'BIOL 352',
    'Plants and Life',
    'Importance of plants in our lives, including plant domestication and the origin of agriculture. Why plants are fascinating organisms. No credit toward biological science major.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* BIOL 304 prerequisite: GE Area 5B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 5B'
FROM courses c
WHERE c.course_code = 'BIOL 304'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 5B'
  );

/* BIOL 305 prerequisite: GE Area 5B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 5B'
FROM courses c
WHERE c.course_code = 'BIOL 305'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 5B'
  );

/* BIOL 318 prerequisite: GE Area 5B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 5B'
FROM courses c
WHERE c.course_code = 'BIOL 318'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 5B'
  );

/* BIOL 319 prerequisite: GE Area 5B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 5B'
FROM courses c
WHERE c.course_code = 'BIOL 319'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 5B'
  );

/* BIOL 352 prerequisite: GE Area 5B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 5B'
FROM courses c
WHERE c.course_code = 'BIOL 352'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 5B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */

/* BIOL 304 -> prerequisite -> GE Area 5B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'BIOL 304'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );

/* BIOL 305 -> prerequisite -> GE Area 5B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'BIOL 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );

/* BIOL 318 -> prerequisite -> GE Area 5B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'BIOL 318'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );

/* BIOL 319 -> prerequisite -> GE Area 5B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'BIOL 319'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );

/* BIOL 352 -> prerequisite -> GE Area 5B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'BIOL 352'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );
  
  /* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'CAS 131',
    'Explore Core: Migrant Lives',
    'Differing sociocultural experiences of different migrant groups. How immigration as a process impacts physical, cognitive and socioemotional development of migrants’ children. Educational experiences of migrants and implications for schools and society. (CAS 131, AMST 131 and READ 131 are the same course)',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;
    
/* =========================================================
   1) COURSES
   Only courses with expanded catalog details are included.
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'CHIC 106',
    'Introduction to Chicano Studies',
    'Role of the Chicano in the U.S. The Chicano’s cultural values, social organization, urbanization patterns, and the problems in the area of education, politics and legislation.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'CHIC 201',
    'Chicana and Chicano Environmentalisms',
    'Relationships between Chicanx/Latinx communities and environments and ecologies as represented in art, film, literature, oral histories, photography and other forms of cultural production. How Chicanx/Latinx cultural production contributes to understandings about environmentalisms and ecologies.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'CHIC 250',
    'Introduction to Multi-Ethnic Literatures of the U.S.',
    'Introducing multi-ethnic literatures of the U. S., the course considers texts within their cultural, historical, and socio-political contexts. Relates multi-ethnic literature to the creative and performing arts. Themes covered may include diaspora, migration, memory, history, citizenship, and/or ethnic identities. (CHIC 250, AFAM 250, ASAM 250 and ENGL 250 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'CHIC 303',
    'Chicano/Mexican Cultures',
    'Methodology for studying and analyzing the cultural background of Mexican and Chicana/o populations in order to understand current traditions, practices, beliefs and ideologies. Syncretism, colonialism, modernization, urbanization, migration and resistance.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'CHIC 316',
    'The Chicano Music Experience',
    'Mexican folk and popular music and its relationship to the culture of Mexico. Pre-Cortesian period to the present in Mexico and Southwestern United States.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'CHIC 360',
    'Literacy Education for Social Change',
    'Guides students through theories of critical and de-colonial literacies, alongside exploration and practice in qualitative inquiry, in order to deeply reflect on meaningful educational and social change in schools and societies. Fieldwork component. (READ 360 and CHIC 360 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'CHIC 369',
    'Border Cinema',
    'Examines representations of the U.S.-Mexico border in Mexican and U.S. films from the Mexican Revolution era to the present, as well as border theories in international films and scholarship. (CHIC 369 and CTVA 369 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* CHIC 303 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'CHIC 303'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* CHIC 316 prerequisite: GE Area 3A or 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 3B'
FROM courses c
WHERE c.course_code = 'CHIC 316'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 3B'
  );

/* CHIC 360 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'CHIC 360'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* CHIC 369 prerequisite: GE Area 3A or 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 3B'
FROM courses c
WHERE c.course_code = 'CHIC 369'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 3B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Encodes AND/OR logic using group_number.
   - Same group_number = OR
   - Different group_number = AND
   ========================================================= */

/* CHIC 303 -> prerequisite -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CHIC 303'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* CHIC 316 -> prerequisite -> GE Area 3A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CHIC 316'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

/* CHIC 316 -> prerequisite -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CHIC 316'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* CHIC 360 -> prerequisite -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CHIC 360'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* CHIC 369 -> prerequisite -> GE Area 3A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CHIC 369'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

/* CHIC 369 -> prerequisite -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CHIC 369'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );
  
  /* =========================================================
   1) COURSES
   Only courses with expanded catalog details are included.
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'CHIN 385',
    'Advanced Chinese Cultural Communication',
    'Helps students to further develop Chinese competency at the advanced level through the reading of literary texts, with a focus on discussions and essays about various topics related to Chinese culture. Conducted in Chinese.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'CHIN 390',
    'Chinese Culture through Cinema and Literature',
    'The development of modern Chinese culture and society. Multicultural analysis of global issues through various media, including subtitled films and literature. Conducted primarily in English.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* CHIN 385 prerequisite: CHIN 204 or equivalent Chinese communicative competency */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'CHIN 204 or equivalent Chinese communicative competency'
FROM courses c
WHERE c.course_code = 'CHIN 385'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'CHIN 204 or equivalent Chinese communicative competency'
  );

/* CHIN 390 prerequisite: GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'CHIN 390'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */

/* CHIN 385 -> prerequisite -> CHIN 204 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'CHIN 204'
WHERE c.course_code = 'CHIN 385'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'CHIN 204 or equivalent Chinese communicative competency'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* CHIN 385 -> prerequisite -> equivalent Chinese communicative competency */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Equivalent Chinese communicative competency'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CHIN 385'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'CHIN 204 or equivalent Chinese communicative competency'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Equivalent Chinese communicative competency'
  );

/* CHIN 390 -> prerequisite -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CHIN 390'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );
  
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'COMD 303',
    'Biology of Human Communication',
    'Biology and evolution of speech and language. Speech production, evolution and development; speech perception; language, hemispheric specialization, clinical studies; current methods in neurolinguistics; and plasticity and aging.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* COMD 303 prerequisite: BIOL 101 or PSYC 101 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'BIOL 101 or PSYC 101'
FROM courses c
WHERE c.course_code = 'COMD 303'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'BIOL 101 or PSYC 101'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Same group_number = OR
   ========================================================= */

/* option: BIOL 101 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'BIOL 101'
WHERE c.course_code = 'COMD 303'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'BIOL 101 or PSYC 101'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* option: PSYC 101 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'PSYC 101'
WHERE c.course_code = 'COMD 303'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'BIOL 101 or PSYC 101'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );
  
  /* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'COMM 370',
    'Principles and Ethics of Journalism',
    'American journalism; newspapers and periodicals through radio, television and the internet; ideological, political, social and economic aspects.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* COMM 370 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'COMM 370'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* COMM 370 corequisite: Communications major - COMM 233 or COMM 317 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'Communications major - COMM 233 or COMM 317'
FROM courses c
WHERE c.course_code = 'COMM 370'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'corequisite'
        AND cr.note = 'Communications major - COMM 233 or COMM 317'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   - Same group_number = OR
   ========================================================= */

/* COMM 370 -> prerequisite -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'COMM 370'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* COMM 370 -> corequisite -> Communications major */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Communications major'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'COMM 370'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'Communications major - COMM 233 or COMM 317'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Communications major'
  );

/* COMM 370 -> corequisite -> COMM 233 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'COMM 233'
WHERE c.course_code = 'COMM 370'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'Communications major - COMM 233 or COMM 317'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* COMM 370 -> corequisite -> COMM 317 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'COMM 317'
WHERE c.course_code = 'COMM 370'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'Communications major - COMM 233 or COMM 317'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'CPLT 356',
    'Queer Literature and Theory',
    'Representations and productions of heteronormativity, sexual orientation and gender roles in literature and critical theory. Considers literary texts from different genres and critical theory from a variety of theorists. (ENGL 356 and CPLT 356 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* CPLT 356 prerequisite: sophomore, junior or senior standing */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'sophomore, junior or senior standing'
FROM courses c
WHERE c.course_code = 'CPLT 356'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'sophomore, junior or senior standing'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Same group_number = OR
   ========================================================= */

/* CPLT 356 -> prerequisite -> sophomore standing */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Sophomore standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CPLT 356'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'sophomore, junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Sophomore standing'
  );

/* CPLT 356 -> prerequisite -> junior standing */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Junior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CPLT 356'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'sophomore, junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Junior standing'
  );

/* CPLT 356 -> prerequisite -> senior standing */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Senior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CPLT 356'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'sophomore, junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Senior standing'
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'CPSC 313',
    'The Computer Impact',
    'The effects of computers on society. Unanticipated consequences of computing technology for individuals, organizations, and institutions. Personal responsibility and legal ramifications. May not be applied toward Computer Science major requirements.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* CPSC 313 prerequisite: GE Area 2A; junior or senior standing */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 2A; junior or senior standing'
FROM courses c
WHERE c.course_code = 'CPSC 313'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 2A; junior or senior standing'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   ========================================================= */

/* group 1: GE Area 2A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 2A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CPSC 313'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 2A; junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 2A'
  );

/* group 2 option: junior standing */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'Junior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CPSC 313'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 2A; junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'Junior standing'
  );

/* group 2 option: senior standing */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'Senior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CPSC 313'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 2A; junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'Senior standing'
  );
  
  /* =========================================================
   1) COURSES
   Only courses with expanded catalog details are included.
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'CRJU 100',
    'Myths and Realities of Crime and Justice',
    'The myths and misperceptions of crime, law and justice. The role of moral panics and the media in shaping perceptions of crime.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'CRJU 320',
    'Introduction to Public Administration',
    'Introduces public administration through current trends and problems of public sector agencies in such areas as organization behavior, public budgeting, personnel, planning and policy making. Examples and cases from the Criminal Justice field. (POSC 320 and CRJU 320 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* CRJU 320 prerequisite: POSC 100 and GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'POSC 100 and GE Area 4A'
FROM courses c
WHERE c.course_code = 'CRJU 320'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'POSC 100 and GE Area 4A'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   ========================================================= */

/* CRJU 320 -> prerequisite -> POSC 100 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 100'
WHERE c.course_code = 'CRJU 320'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100 and GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* CRJU 320 -> prerequisite -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CRJU 320'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100 and GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );
  
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'CTVA 365',
    'Children’s TV',
    'Research and literature on effects of television on children. Historical and contemporary aspects of children’s TV issues, including advertising, violence, stereotyping and education. How children’s TV producers use concepts related to children to design material for them.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'CTVA 369',
    'Border Cinema',
    'Examines representations of the U.S.-Mexico border in Mexican and U.S. films from the Mexican Revolution era to the present, as well as border theories in international films and scholarship. (CHIC 369 and CTVA 369 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'CTVA 372',
    'World Cinema: Beginnings-1950',
    'National cinemas, film movements, filmmakers, and the increasing internationalization of the world film industry from its beginnings to 1950, in terms of stylistic elements and how they are shaped by the circumstances in which they are produced and received.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'CTVA 373',
    'World Cinema: 1950-1990',
    'National cinemas, film movements, filmmakers, and the increasing internationalization of the world film industry from 1950 to 1990, in terms of stylistic elements and how they are shaped by the circumstances in which they are produced and received.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'CTVA 374',
    'Contemporary World Cinema',
    'National cinemas, film movements, filmmakers and the increasing internationalization of the world film industry from 1990 to the present, in terms of stylistic elements and how they are shaped by the circumstances in which they are produced and received.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* CTVA 365 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'CTVA 365'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* CTVA 369 prerequisite: GE Area 3A or 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 3B'
FROM courses c
WHERE c.course_code = 'CTVA 369'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 3B'
  );

/* CTVA 372 prerequisite: GE Area 3A or 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 3B'
FROM courses c
WHERE c.course_code = 'CTVA 372'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 3B'
  );

/* CTVA 373 prerequisite: GE Area 3A or 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 3B'
FROM courses c
WHERE c.course_code = 'CTVA 373'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 3B'
  );

/* CTVA 374 prerequisite: GE Area 3A or 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 3B'
FROM courses c
WHERE c.course_code = 'CTVA 374'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 3B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */

/* CTVA 365 -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CTVA 365'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );


/* ----- GE Area 3A or 3B logic (same group = OR) ----- */

/* helper for multiple courses */
-- CTVA 369, 372, 373, 374 share same prereq pattern

INSERT INTO course_requirement_items
(course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code IN ('CTVA 369','CTVA 372','CTVA 373','CTVA 374')
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
      AND cri.group_number = 1
      AND cri.item_type = 'text'
      AND cri.item_text = 'GE Area 3A'
  );

INSERT INTO course_requirement_items
(course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code IN ('CTVA 369','CTVA 372','CTVA 373','CTVA 374')
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
      AND cri.group_number = 1
      AND cri.item_type = 'text'
      AND cri.item_text = 'GE Area 3B'
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'DANC 101',
    'Introduction to Dance',
    'Historical and contemporary dance forms. Experiences in various dance forms such as ballet, modern, jazz, folk, ethnic. Recommended for non-majors.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'DANC 301',
    'Dance and Cultural Diversity',
    'Impact of various dance forms, from primitive time to modern, on diverse cultures. Contributions of immigrants, minorities and women to dance as a personal, social and cultural expression.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'DANC 371',
    'African American Concert Dance History',
    'Production of African derived dance from within American culture. Consideration of the history of dance artists’ biographic and critical theory literature from diverse media. Includes a lab involving choreography and performance of major African American concert dance forms. (DANC 371 and AFAM 371 are the same course)',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* DANC 101 prerequisite: not a Dance major */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'not a Dance major'
FROM courses c
WHERE c.course_code = 'DANC 101'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'not a Dance major'
  );

/* DANC 371 prerequisite: GE Area 3A or 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 3B'
FROM courses c
WHERE c.course_code = 'DANC 371'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 3B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */

/* DANC 101 -> prerequisite -> not a Dance major */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Not a Dance major'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'DANC 101'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'not a Dance major'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Not a Dance major'
  );

/* DANC 371 -> prerequisite -> GE Area 3A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'DANC 371'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

/* DANC 371 -> prerequisite -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'DANC 371'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'ECON 305',
    'Economics, Causality, and Analytics',
    'Modern economic analysis, which centers around causal inference - how X causes Y. How economists and social scientists identify causal effects without experiments, how to diagram causality and how to implement casual methods using R.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ECON 330',
    'Comparative Economic Systems',
    'Alternative economic systems; their theoretical foundations, actual economic institutions, and achievements and failures. Contrast between socialist and capitalist systems.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ECON 332',
    'Economies of the Pacific Rim',
    'Dimensions of industrialization, agriculture, investment, human resources and trade in economies of the Far East (including Japan and China), India and related nations of the Pacific Rim.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ECON 333',
    'Economic Development: Analysis and Case Studies',
    'Processes of economic growth with references to developing areas. Capital formation, resource allocation, relation to the world economy, economic planning and institutional factors, with case studies.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ECON 334',
    'Economics of Latin America and the Caribbean',
    'Regional economic problems within an international context: dependence, industrialization and the international corporation; agriculture; regional cooperation; inflation; trade and debt problems.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ECON 335',
    'The International Economy',
    'Theory, practice and institutions of the international economy. International trade and investment, effects of trade policies, trade blocs, balance of payments, foreign exchange markets, short-run and long-run determinants of exchange rates.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ECON 336',
    'Economies of the Middle East',
    'Economic circumstances and challenges in the Middle East. Topics include population and education, dependence on oil exports, state control of the economy, and the potential for economic growth and stability in the region.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ECON 350',
    'American Economic History',
    'Development of American economic institutions; economic problems, economic growth and economic welfare.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ECON 355',
    'Economics of Gender and Work',
    'Economic analysis of demographic trends and changing gender roles and experiences in paid and unpaid work, education, earnings and market discrimination using economic theory. International comparisons. (ECON 355 and GSS 355 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ECON 360',
    'Economic Inequality in the U.S.',
    'Why inequality exists and why it matters using an economic lens. Discuss increases in economic inequality in the United States and government policies aimed at reversing this trend with a focus on economic concepts and data literacy.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ECON 362',
    'Environmental Economics',
    'Economic analysis of environmental problems and related issues: externalities, property rights, social costs and benefits, user cost, rent and decision making under uncertainty.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* ECON 305 prerequisite: GE Area 2A; ECON 100, ECON 201 or ECON 202 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 2A; ECON 100, ECON 201 or ECON 202'
FROM courses c
WHERE c.course_code = 'ECON 305'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 2A; ECON 100, ECON 201 or ECON 202'
  );

/* ECON 330 prerequisite: ECON 100; or ECON 201, ECON 202 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'ECON 100; or ECON 201, ECON 202'
FROM courses c
WHERE c.course_code = 'ECON 330'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'ECON 100; or ECON 201, ECON 202'
  );

/* ECON 332 prerequisite: ECON 100; or ECON 201, ECON 202 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'ECON 100; or ECON 201, ECON 202'
FROM courses c
WHERE c.course_code = 'ECON 332'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'ECON 100; or ECON 201, ECON 202'
  );

/* ECON 333 prerequisite: ECON 100; or ECON 201, ECON 202 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'ECON 100; or ECON 201, ECON 202'
FROM courses c
WHERE c.course_code = 'ECON 333'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'ECON 100; or ECON 201, ECON 202'
  );

/* ECON 334 prerequisite: ECON 100; or ECON 201, ECON 202 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'ECON 100; or ECON 201, ECON 202'
FROM courses c
WHERE c.course_code = 'ECON 334'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'ECON 100; or ECON 201, ECON 202'
  );

/* ECON 335 prerequisite: ECON 100; or ECON 201, ECON 202 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'ECON 100; or ECON 201, ECON 202'
FROM courses c
WHERE c.course_code = 'ECON 335'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'ECON 100; or ECON 201, ECON 202'
  );

/* ECON 336 prerequisite: ECON 100; or ECON 201, ECON 202 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'ECON 100; or ECON 201, ECON 202'
FROM courses c
WHERE c.course_code = 'ECON 336'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'ECON 100; or ECON 201, ECON 202'
  );

/* ECON 350 prerequisite: ECON 100, ECON 201 or ECON 202 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'ECON 100, ECON 201 or ECON 202'
FROM courses c
WHERE c.course_code = 'ECON 350'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'ECON 100, ECON 201 or ECON 202'
  );

/* ECON 355 prerequisite: GE Area 4A, junior or senior standing */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A, junior or senior standing'
FROM courses c
WHERE c.course_code = 'ECON 355'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A, junior or senior standing'
  );

/* ECON 360 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'ECON 360'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* ECON 362 prerequisite: ECON 100 or ECON 201 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'ECON 100 or ECON 201'
FROM courses c
WHERE c.course_code = 'ECON 362'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'ECON 100 or ECON 201'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   Same group_number = OR
   ========================================================= */

/* ---------------------------------------------------------
   ECON 305
   Parsed as:
   GE Area 2A AND (ECON 100 OR ECON 201 OR ECON 202)
   --------------------------------------------------------- */

/* ECON 305 -> GE Area 2A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 2A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ECON 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 2A; ECON 100, ECON 201 or ECON 202'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 2A'
  );

/* ECON 305 -> ECON 100 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ECON 100'
WHERE c.course_code = 'ECON 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 2A; ECON 100, ECON 201 or ECON 202'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* ECON 305 -> ECON 201 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ECON 201'
WHERE c.course_code = 'ECON 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 2A; ECON 100, ECON 201 or ECON 202'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* ECON 305 -> ECON 202 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ECON 202'
WHERE c.course_code = 'ECON 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 2A; ECON 100, ECON 201 or ECON 202'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );


/* ---------------------------------------------------------
   ECON 330 / 332 / 333 / 334 / 335 / 336
   Parsed as:
   ECON 100 OR (ECON 201 AND ECON 202)
   --------------------------------------------------------- */

/* Option 1: ECON 100 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ECON 100'
WHERE c.course_code IN ('ECON 330','ECON 332','ECON 333','ECON 334','ECON 335','ECON 336')
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'ECON 100; or ECON 201, ECON 202'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* Option 2 path: ECON 201 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ECON 201'
WHERE c.course_code IN ('ECON 330','ECON 332','ECON 333','ECON 334','ECON 335','ECON 336')
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'ECON 100; or ECON 201, ECON 202'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* Option 2 path: ECON 202 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 3, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ECON 202'
WHERE c.course_code IN ('ECON 330','ECON 332','ECON 333','ECON 334','ECON 335','ECON 336')
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'ECON 100; or ECON 201, ECON 202'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 3
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );


/* ---------------------------------------------------------
   ECON 350
   Parsed as:
   ECON 100 OR ECON 201 OR ECON 202
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ECON 100'
WHERE c.course_code = 'ECON 350'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'ECON 100, ECON 201 or ECON 202'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ECON 201'
WHERE c.course_code = 'ECON 350'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'ECON 100, ECON 201 or ECON 202'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ECON 202'
WHERE c.course_code = 'ECON 350'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'ECON 100, ECON 201 or ECON 202'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );


/* ---------------------------------------------------------
   ECON 355
   Parsed as:
   GE Area 4A AND (Junior standing OR Senior standing)
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ECON 355'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A, junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'Junior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ECON 355'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A, junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'Junior standing'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'Senior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ECON 355'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A, junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'Senior standing'
  );


/* ---------------------------------------------------------
   ECON 360
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ECON 360'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );


/* ---------------------------------------------------------
   ECON 362
   Parsed as:
   ECON 100 OR ECON 201
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ECON 100'
WHERE c.course_code = 'ECON 362'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'ECON 100 or ECON 201'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ECON 201'
WHERE c.course_code = 'ECON 362'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'ECON 100 or ECON 201'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'CTVA 305',
    'Diversity in Television',
    'Critical examination and analysis of the representation of minority groups in American and global television. The intersectional representation of age, disability, gender, race/ethnicity, religion, sexual identity, nation and socioeconomic class.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* CTVA 305 prerequisite: GE Area 3A or 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 3B'
FROM courses c
WHERE c.course_code = 'CTVA 305'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 3B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Same group_number = OR
   ========================================================= */

/* CTVA 305 -> prerequisite -> GE Area 3A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CTVA 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

/* CTVA 305 -> prerequisite -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'CTVA 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'EDSC 320',
    'Adolescent Development',
    'Biological, cognitive and socio-cultural development of adolescents. Contexts of adolescent development, including family, peers, school, work and leisure. Health and safety issues of adolescents.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'EGCE 305',
    'Earthquake Impact on Structures',
    'Geological aspects of earthquakes as they apply to building safety; introduction to earthquake-related problems and building damages caused by historic earthquakes. Destruction aspects of earthquakes, preparedness for large earthquakes and how to protect structural and non-structural parts of buildings.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* EGCE 305 prerequisite: GE Areas 2A and 5A or 5B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Areas 2A and 5A or 5B'
FROM courses c
WHERE c.course_code = 'EGCE 305'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Areas 2A and 5A or 5B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Parsed as:
   GE Area 2A AND (GE Area 5A OR GE Area 5B)
   ========================================================= */

/* Requirement: GE Area 2A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 2A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'EGCE 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 2A and 5A or 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 2A'
  );

/* Requirement: GE Area 5A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 5A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'EGCE 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 2A and 5A or 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5A'
  );

/* Requirement: GE Area 5B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'EGCE 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 2A and 5A or 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'ENGL 356',
    'Queer Literature and Theory',
    'Representations and productions of heteronormativity, sexual orientation and gender roles in literature and critical theory. Considers literary texts from different genres and critical theory from a variety of theorists. (ENGL 356 and CPLT 356 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ENGL 380',
    'Introduction to Asian Literature',
    'Selected translations of Arabic, Persian, Indian, Chinese or Japanese literature. (CPLT 380 and ENGL 380 are the same course)',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* ENGL 356 prerequisite: sophomore, junior or senior standing */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'sophomore, junior or senior standing'
FROM courses c
WHERE c.course_code = 'ENGL 356'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'sophomore, junior or senior standing'
  );

/* ENGL 380 prerequisite: GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'ENGL 380'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */

/* ENGL 356 -> prerequisite -> sophomore standing */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Sophomore standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ENGL 356'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'sophomore, junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Sophomore standing'
  );

/* ENGL 356 -> prerequisite -> junior standing */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Junior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ENGL 356'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'sophomore, junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Junior standing'
  );

/* ENGL 356 -> prerequisite -> senior standing */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Senior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ENGL 356'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'sophomore, junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Senior standing'
  );

/* ENGL 380 -> prerequisite -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'ENGL 380'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'ENGL 250',
    'Introduction to Multi-Ethnic Literatures of the U.S.',
    'Introducing multi-ethnic literatures of the U. S., the course considers texts within their cultural, historical, and socio-political contexts. Relates multi-ethnic literature to the creative and performing arts. Themes covered may include diaspora, migration, memory, history, citizenship, and/or ethnic identities. (CHIC 250, AFAM 250, ASAM 250 and ENGL 250 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'ESM 110',
    'Mathematics for Liberal Arts Students',
    'Survey of traditional and contemporary topics in mathematics, such as elementary logic, counting techniques, probability, statistics, and the mathematics of the social sciences. For non-science majors.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ESM 115A',
    'College Algebra (A)',
    'First semester of a two-semester sequence for students planning to take calculus who are not MATH/QR ready. Linear and quadratic equations with additional focus on foundation-level mathematics to support algebraic properties of linear and quadratic functions, graphs and applications. (MATH 115A and ESM 115A are the same course).',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'ESM 120',
    'Elementary Statistics',
    'Explore and analyze data with real-world applications. Design surveys and experiments. Graphical and numerical summaries. Correlation, regression and analysis of contingency tables. Confidence intervals and hypothesis testing via simulation and using normal, t, chi-squared distributions.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* ESM 110 corequisite: MATH 10S/ESM 10S */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'MATH 10S/ESM 10S'
FROM courses c
WHERE c.course_code = 'ESM 110'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'corequisite'
        AND cr.note = 'MATH 10S/ESM 10S'
  );

/* ESM 120 corequisite: MATH 20S/ESM 20S */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'MATH 20S/ESM 20S'
FROM courses c
WHERE c.course_code = 'ESM 120'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'corequisite'
        AND cr.note = 'MATH 20S/ESM 20S'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Same group_number = OR
   ========================================================= */

/* ESM 110 -> corequisite -> MATH 10S */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'MATH 10S'
WHERE c.course_code = 'ESM 110'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'MATH 10S/ESM 10S'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* ESM 110 -> corequisite -> ESM 10S */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ESM 10S'
WHERE c.course_code = 'ESM 110'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'MATH 10S/ESM 10S'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* ESM 120 -> corequisite -> MATH 20S */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'MATH 20S'
WHERE c.course_code = 'ESM 120'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'MATH 20S/ESM 20S'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* ESM 120 -> corequisite -> ESM 20S */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ESM 20S'
WHERE c.course_code = 'ESM 120'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'MATH 20S/ESM 20S'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'FIN 310',
    'Personal Financial Management',
    'Financial problems of the household in allocating resources and planning expenditures. Housing, insurance, installment buying, medical care, savings and investments. Special financial planning problems faced by minorities and women. May not be used to fulfill the concentration requirement in finance.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* FIN 310 prerequisite: GE Area 2A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 2A'
FROM courses c
WHERE c.course_code = 'FIN 310'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 2A'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */

/* FIN 310 -> prerequisite -> GE Area 2A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 2A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'FIN 310'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 2A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 2A'
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'GEOG 110',
    'Intro to Natural Environment',
    'Introduction to the major components of the physical environment, including landforms, climate, natural vegetation and soils.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GEOG 110L',
    'Introduction to the Natural Environment: Laboratory',
    'Observations, experiments and demonstrations designed to familiarize students with techniques utilized by physical geographers. Topics include weather and climate, vegetation, and landforms.',
    1.0,
    1.0,
    TRUE,
    FALSE
),
(
    'GEOG 160',
    'Human Geography',
    'Introduction to Human Geography. Understanding the regional distribution of language, religion, population, migration and settlement patterns, political organization, technology, methods of livelihood over the earth.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GEOG 321',
    'Nature and Society',
    'Interface between human systems and natural systems. Various factors affecting human interaction with the earth, including environmental ethics, public policy and technology.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GEOG 332',
    'United States and Canada',
    'Origins and development of the physical and cultural regions of the United States and Canada, and the similarities and differences between the two countries.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GEOG 371',
    'The National Parks',
    'The creation and use of national parks and other protected areas. Origins and globalization of the national parks. Challenges and conflicts related to national parks.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GEOG 372',
    'Geography of Illegal Drugs',
    'Global patterns of illegal drug production and use, including agricultural aspects, trafficking, consumption patterns, political economy, laws and politics, drug tourism, environmental aspects and related issues. Focuses on a number of case studies around the world.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GEOG 373',
    'Global Cuisines',
    'International dimensions of food and wine traditions in the cultural landscape. Foods and drinks that are wild, tabooed, medicinal, gendered and erotic. Migrant cuisine from Mexico, Europe, Africa, Asia and the Middle East.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* GEOG 110L pre- or corequisite: GEOG 110
   Stored as corequisite in this schema, with note preserving the exact wording.
*/
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'Pre- or corequisite: GEOG 110'
FROM courses c
WHERE c.course_code = 'GEOG 110L'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'corequisite'
        AND cr.note = 'Pre- or corequisite: GEOG 110'
  );

/* GEOG 321 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'GEOG 321'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */

/* GEOG 110L -> corequisite -> GEOG 110 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'GEOG 110'
WHERE c.course_code = 'GEOG 110L'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'Pre- or corequisite: GEOG 110'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* GEOG 321 -> prerequisite -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'GEOG 321'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );


/* =========================================================
   4) COURSE PAIRS
   Pair GEOG 110 with GEOG 110L as lecture_lab
   ========================================================= */

INSERT INTO course_pairs (
    course_id,
    paired_course_id,
    pair_type
)
SELECT c1.id, c2.id, 'lecture_lab'
FROM courses c1
JOIN courses c2
  ON c1.course_code = 'GEOG 110'
 AND c2.course_code = 'GEOG 110L'
WHERE NOT EXISTS (
    SELECT 1
    FROM course_pairs cp
    WHERE cp.course_id = c1.id
      AND cp.paired_course_id = c2.id
      AND cp.pair_type = 'lecture_lab'
);
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'GEOL 100',
    'Introduction to Earth Sciences',
    'Introduction to the Earth sciences, including geology, oceanography and meteorology, as well as Earth’s place in the solar system. Natural hazards, the interaction of the geosphere, atmosphere and hydrosphere, and the role of Earth’s systems in everyday life. High school algebra recommended.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'GSS 100',
    'Introduction to Gender Studies in the Humanities',
    'Gender representation in the humanities, using primary texts from around the world that shape global perspectives on the human condition. Rationality, the moral dimensions of individuals and communities, and the social construction of gender.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GSS 205',
    'Gender and Globalization',
    'How globalization affects women’s lives through the distribution of wealth, knowledge and opportunity. Local and transnational responses to global processes and how activists can work within and between these movements. International in focus.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GSS 302',
    'Gender and Sexuality Studies',
    'Interdisciplinary introduction to women’s issues and research in relevant disciplines. (GSS 302 and PHIL 302 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GSS 310',
    'Black Women in America',
    'Issues in the study of black women in America, including social, political, economic and intellectual development. Historical and contemporary issues as they affect black American women. (AFAM 310 and GSS 310 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GSS 313',
    'La Chicana',
    'Cultural influences that the family, religion, economic status and community play upon the lifestyles, values and roles held by Chicanas. (CHIC 313 and GSS 313 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GSS 320',
    'Digital Culture, Gender and Sexuality',
    'Current technologies and their relationship to gender issues, combining theoretical considerations with practical applications. Learn some basic technologies to use as tools for projects.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GSS 340',
    'Masculinities',
    'Critical examination of competing frameworks of masculinity. How the social construction of masculinity is framed by intersections of race, class, gender and sexuality.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GSS 355',
    'Economics of Gender and Work',
    'Economic analysis of demographic trends and changing gender roles and experiences in paid and unpaid work, education, earnings and market discrimination using economic theory. International comparisons. (ECON 355 and GSS 355 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GSS 360',
    'Politics of Sexuality',
    'Cultural politics of sexuality within the U.S. and across national and cultural boundaries using feminist theories and methods. A focus on sexual controversies illuminates the relationship between sex, power and social change.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'GSS 485',
    'Women, Gender and Politics',
    'Changing political environment and women’s role in elected, appointed and other public agencies; issues of particular concern to women, including family issues, comparable worth and other economic issues and political participation. (POSC 485 and GSS 485 are the same course)',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* GSS 205 prerequisite: GE Area 3A or 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 4A'
FROM courses c
WHERE c.course_code = 'GSS 205'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 4A'
  );

/* GSS 310 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'GSS 310'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* GSS 313 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'GSS 313'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* GSS 320 prerequisite: GE Area 3A or 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 3B'
FROM courses c
WHERE c.course_code = 'GSS 320'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 3B'
  );

/* GSS 355 prerequisite: GE Area 4A, junior or senior standing */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A, junior or senior standing'
FROM courses c
WHERE c.course_code = 'GSS 355'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A, junior or senior standing'
  );

/* GSS 360 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'GSS 360'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* GSS 485 prerequisite: POSC 100 or HONR 201B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'POSC 100 or HONR 201B'
FROM courses c
WHERE c.course_code = 'GSS 485'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'POSC 100 or HONR 201B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   Same group_number = OR
   ========================================================= */

/* GSS 205 -> GE Area 3A or 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'GSS 205'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'GSS 205'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* GSS 310 -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'GSS 310'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* GSS 313 -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'GSS 313'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* GSS 320 -> GE Area 3A or 3B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'GSS 320'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'GSS 320'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* GSS 355 -> GE Area 4A AND (Junior standing OR Senior standing) */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'GSS 355'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A, junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'Junior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'GSS 355'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A, junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'Junior standing'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'Senior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'GSS 355'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A, junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'Senior standing'
  );

/* GSS 360 -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'GSS 360'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* GSS 485 -> POSC 100 or HONR 201B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 100'
WHERE c.course_code = 'GSS 485'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'HONR 201B'
WHERE c.course_code = 'GSS 485'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'HCOM 308',
    'Quantitative Research Methods',
    'Current perspectives in empirical research methodology in the discipline of Communication Studies. Experimental designs, common statistical tests and the use of the computer as a research tool.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HCOM 315',
    'Social Media and Communication',
    'Social media across communication contexts. Interaction among social media, communication and culture. Analyze and evaluate contemporary social media and practices. Requires basic familiarity with social media technologies.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HCOM 370',
    'Sport Communication',
    'Introduction to the theories and processes of sport communication. The communication processes of sport fans, coaches, athletes, teams, organizations and society. Application of these theories and processes to careers in sports communication, research and administration.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* HCOM 308 prerequisite: GE Area 2A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 2A'
FROM courses c
WHERE c.course_code = 'HCOM 308'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 2A'
  );

/* HCOM 315 prerequisite: HCOM 100 or GE Area 1C; GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'HCOM 100 or GE Area 1C; GE Area 4A'
FROM courses c
WHERE c.course_code = 'HCOM 315'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'HCOM 100 or GE Area 1C; GE Area 4A'
  );

/* HCOM 370 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'HCOM 370'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   Same group_number = OR
   ========================================================= */

/* HCOM 308 -> GE Area 2A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 2A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HCOM 308'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 2A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 2A'
  );


/* HCOM 315 parsed as:
   (HCOM 100 OR GE Area 1C) AND GE Area 4A
*/

/* HCOM 315 -> HCOM 100 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'HCOM 100'
WHERE c.course_code = 'HCOM 315'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'HCOM 100 or GE Area 1C; GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* HCOM 315 -> GE Area 1C */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 1C'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HCOM 315'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'HCOM 100 or GE Area 1C; GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 1C'
  );

/* HCOM 315 -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HCOM 315'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'HCOM 100 or GE Area 1C; GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );


/* HCOM 370 -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HCOM 370'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'HIST 110A',
    'World Civilizations to the 16th Century',
    'Development of Western and non-Western civilizations from their origins to the 16th century.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 110B',
    'World Civilizations Since the 16th Century',
    'Development of Western and non-Western civilizations from the 16th century to the present.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 170A',
    'United States to 1877',
    'Political, social, economic and cultural development of the United States to 1877. Old World background, rise of the new nation, sectional problems, the Civil War and Reconstruction.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 170B',
    'United States Since 1877',
    'U.S. history from the late 19th century to the present. Economic transformation, political reform movements, social, cultural and intellectual changes and the role of the United States in world affairs.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 180',
    'Survey of American History',
    'American history from prehistoric times (before 1492) to the present according to chronological time periods. Basic themes that pervade the entire sweep of the nation’s history. Satisfies state requirement in U.S. History.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 190',
    'Survey of American History with Emphasis on Ethnic Minorities',
    'Survey of American history from prehistoric times (before 1492) to the present with special emphasis on the role of race and ethnicity. (HIST 190, AFAM 190, ASAM 190 and CHIC 190 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 200',
    'Ideas, Books, And Beliefs: Texts that Changed History',
    'Probes a central historical question: how ideas change, by examining the role of fictional and non-fiction texts in fundamentally altering a people’s belief systems.',
    1.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 201',
    'The History of Asian Pacific Americans',
    'Origins and evolution of Asian American communities and cultures, with an emphasis upon the southern California region, through selected books, oral histories, films, outside speakers and excursions. (HIST 201 and ASAM 201 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 210A',
    'Baseball History',
    'Examines history of baseball through art, films, memoirs, music and fiction. In playing, watching, writing about and contemplating the nation’s most creative, complicated and exported sport, diverse Americans have defined themselves and their connections to other regions of the world.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 230',
    'Clashing Steel: Classic and Medieval War and Society',
    'History of the global emergence and experience of organized violence, evolution of strategy and tactics, the impact of technology on warfare, and the relationship between military and civilians in pre-modern eras. Topically examines social and cultural reactions to war.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 231',
    'Roar of Cannons: Modern War and Society',
    'Developments following the introduction of gunpowder. The evolution of military strategy and tactics, impact of technology on warfare, and relationship between war and civilian populations.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 314',
    'Travels in Time',
    'The encounters of travelers with people and places around the world through time. Locations and time periods will vary.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 325',
    'Cross-Cultural History of Medicine',
    'The diversity of health and healing systems from the early modern period to the present. Employ an interdisciplinary approach to examine the science and ethics of health and healing across a variety of geographical, historical and cultural contexts. (LBST 325 and HIST 325 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 330',
    'History of Early Science and Technology',
    'Science and technology in the development of human culture, especially the interactions among science, technology and society in ancient Greece and China, medieval and Renaissance Europe, and Islam. (HIST 330 and LBST 330 are the same course).',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 341',
    'Ancient Eats: Food and Foodways in the Ancient World',
    'Food in the Roman Empire and elsewhere in the ancient world. Farming, sustainability, trade, purchasing, processing, production, ingredients, terroir, recipes, tools, the place and function of feasts, and food in myth, cult and philosophy (LBST 341 and HIST 341 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 350',
    'History of Latin American Civilization',
    'Social, economic, political and cultural evolution of Latin America from the European conquest to the present.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HIST 386A',
    'American Social History 1750-1860',
    'Social history of the United States to the Civil War. How different groups shaped American history and respond to changing laws, institutions and economic realities. Theories and methods social historians use.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* HIST 325 prerequisite: GE Area 5A or 5B; junior or senior standing */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 5A or 5B; junior or senior standing'
FROM courses c
WHERE c.course_code = 'HIST 325'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 5A or 5B; junior or senior standing'
  );

/* HIST 330 prerequisite: GE Areas 5A and 5B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Areas 5A and 5B'
FROM courses c
WHERE c.course_code = 'HIST 330'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Areas 5A and 5B'
  );

/* HIST 341 prerequisite: GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'HIST 341'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

/* HIST 350 prerequisite: GE Area 3B, 3U, 4A, 4B or HIST 110A or HIST 110B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B, 3U, 4A, 4B or HIST 110A or HIST 110B'
FROM courses c
WHERE c.course_code = 'HIST 350'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B, 3U, 4A, 4B or HIST 110A or HIST 110B'
  );

/* HIST 386A prerequisite: GE Area 4A or 4B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A or 4B'
FROM courses c
WHERE c.course_code = 'HIST 386A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A or 4B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   Same group_number = OR
   ========================================================= */

/* ---------------------------------------------------------
   HIST 325
   Parsed as:
   (GE Area 5A OR GE Area 5B) AND (Junior standing OR Senior standing)
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HIST 325'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A or 5B; junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HIST 325'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A or 5B; junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'Junior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HIST 325'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A or 5B; junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'Junior standing'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'Senior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HIST 325'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A or 5B; junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'Senior standing'
  );


/* ---------------------------------------------------------
   HIST 330
   Parsed as:
   GE Area 5A AND GE Area 5B
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HIST 330'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 5A and 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HIST 330'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 5A and 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );


/* ---------------------------------------------------------
   HIST 341
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HIST 341'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );


/* ---------------------------------------------------------
   HIST 350
   Parsed as:
   GE Area 3B OR GE Area 3U OR GE Area 4A OR GE Area 4B OR HIST 110A OR HIST 110B
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HIST 350'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B, 3U, 4A, 4B or HIST 110A or HIST 110B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3U'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HIST 350'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B, 3U, 4A, 4B or HIST 110A or HIST 110B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3U'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HIST 350'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B, 3U, 4A, 4B or HIST 110A or HIST 110B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HIST 350'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B, 3U, 4A, 4B or HIST 110A or HIST 110B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4B'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'HIST 110A'
WHERE c.course_code = 'HIST 350'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B, 3U, 4A, 4B or HIST 110A or HIST 110B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'HIST 110B'
WHERE c.course_code = 'HIST 350'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B, 3U, 4A, 4B or HIST 110A or HIST 110B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );


/* ---------------------------------------------------------
   HIST 386A
   Parsed as:
   GE Area 4A OR GE Area 4B
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HIST 386A'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A or 4B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HIST 386A'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A or 4B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4B'
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'HONR 101A',
    'Honors Seminar in Critical Thinking',
    'Seminar for first-year Honors Program students. Developing critical thinking skills. Interpretation, analysis, criticism and advocacy of ideas encountered in designated Honors Program activities.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HONR 101B',
    'Honors Seminar in Oral Communication',
    'Seminar for first-year Honors Program students, emphasizing oral communication skills. Construction, presentation and critical analysis of oral presentations related to the ideas encountered in designated Honors Program activities. Instruction in effective oral communication and critical thinking.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HONR 201A',
    'Honors Seminar: American Institutions and Values to 1877',
    'Critically examines the historical development and political culture of American institutions and values from Colonial history to the Reconstruction era. The interaction, conflict and cooperation of diverse groups, with specific attention to race, ethnicity, gender and class.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HONR 210A',
    'Honors Seminar: World Civilizations to 1500',
    'Integrative, holistic introductory survey of the historical development of civilization within a global context. Impact of Western institutions and ideas upon non-Western societies and cultures and the influence of non-Western cultures and peoples upon Western societies and cultures.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HONR 210B',
    'Honors Seminar: World Civilizations since 1500',
    'Integrative, holistic introductory survey of the historical development of civilization within a global context. Impact of Western institutions and ideas upon non-Western societies and cultures and the influence of non-Western cultures and peoples upon Western societies and cultures.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HONR 301T',
    'Honors Seminar in Natural Science and Mathematics',
    'Interdisciplinary seminar examining selected topics in natural science and mathematics.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HONR 302T',
    'Honors Seminar in Arts and Humanities',
    'Interdisciplinary seminar examining selected topics in arts and humanities.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HONR 303T',
    'Honors Seminar in Social Sciences',
    'Interdisciplinary seminar examining selected topics in social sciences.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'HONR 305',
    'Honors Seminar: Evolution and Creation',
    'Interdisciplinary study of evolutionary biology’s impact on culture in the context of religious doctrines of creation. Evolutionary theory and religious and philosophical reactions to it from Darwin to the present, including relevant educational and legal contexts.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* HONR 101A prerequisite: University Honors Program student */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'University Honors Program student'
FROM courses c
WHERE c.course_code = 'HONR 101A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'University Honors Program student'
  );

/* HONR 101B prerequisite: University Honors Program student */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'University Honors Program student'
FROM courses c
WHERE c.course_code = 'HONR 101B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'University Honors Program student'
  );

/* HONR 201A prerequisite: University Honors Program student */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'University Honors Program student'
FROM courses c
WHERE c.course_code = 'HONR 201A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'University Honors Program student'
  );

/* HONR 210A prerequisite: University Honors Program student */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'University Honors Program student'
FROM courses c
WHERE c.course_code = 'HONR 210A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'University Honors Program student'
  );

/* HONR 210B prerequisite: University Honors Program student */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'University Honors Program student'
FROM courses c
WHERE c.course_code = 'HONR 210B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'University Honors Program student'
  );

/* HONR 301T prerequisite: GE Area 5A, 5B or 2A; University Honors Program Students */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 5A, 5B or 2A; University Honors Program Students'
FROM courses c
WHERE c.course_code = 'HONR 301T'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 5A, 5B or 2A; University Honors Program Students'
  );

/* HONR 302T prerequisite: GE Area 3A or 3B; University Honors Program Students */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 3B; University Honors Program Students'
FROM courses c
WHERE c.course_code = 'HONR 302T'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 3B; University Honors Program Students'
  );

/* HONR 303T prerequisite: GE Area 4A; University Honors Program Students */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A; University Honors Program Students'
FROM courses c
WHERE c.course_code = 'HONR 303T'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A; University Honors Program Students'
  );

/* HONR 305 prerequisite: GE Area 5A, 5B or 2A; University Honors Program Students */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 5A, 5B or 2A; University Honors Program Students'
FROM courses c
WHERE c.course_code = 'HONR 305'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 5A, 5B or 2A; University Honors Program Students'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   Same group_number = OR
   ========================================================= */

/* ---------------------------------------------------------
   HONR 101A / 101B / 201A / 210A / 210B
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'University Honors Program student'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code IN ('HONR 101A', 'HONR 101B', 'HONR 201A', 'HONR 210A', 'HONR 210B')
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'University Honors Program student'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'University Honors Program student'
  );


/* ---------------------------------------------------------
   HONR 301T
   Parsed as:
   (GE Area 5A OR GE Area 5B OR GE Area 2A) AND University Honors Program Students
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HONR 301T'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A, 5B or 2A; University Honors Program Students'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HONR 301T'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A, 5B or 2A; University Honors Program Students'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 2A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HONR 301T'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A, 5B or 2A; University Honors Program Students'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 2A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'University Honors Program Students'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HONR 301T'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A, 5B or 2A; University Honors Program Students'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'University Honors Program Students'
  );


/* ---------------------------------------------------------
   HONR 302T
   Parsed as:
   (GE Area 3A OR GE Area 3B) AND University Honors Program Students
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HONR 302T'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B; University Honors Program Students'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HONR 302T'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B; University Honors Program Students'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'University Honors Program Students'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HONR 302T'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B; University Honors Program Students'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'University Honors Program Students'
  );


/* ---------------------------------------------------------
   HONR 303T
   Parsed as:
   GE Area 4A AND University Honors Program Students
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HONR 303T'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A; University Honors Program Students'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'University Honors Program Students'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HONR 303T'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A; University Honors Program Students'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'University Honors Program Students'
  );


/* ---------------------------------------------------------
   HONR 305
   Parsed as:
   (GE Area 5A OR GE Area 5B OR GE Area 2A) AND University Honors Program Students
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HONR 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A, 5B or 2A; University Honors Program Students'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HONR 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A, 5B or 2A; University Honors Program Students'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 2A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HONR 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A, 5B or 2A; University Honors Program Students'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 2A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'University Honors Program Students'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HONR 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A, 5B or 2A; University Honors Program Students'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'University Honors Program Students'
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'HSS 350',
    'Life and Culture Abroad',
    'Interdisciplinary course providing a broad background to culture and civilization abroad. Social, historical and cultural approach to contemporary societies abroad. Examines traditions and institutions to help understand the 21st century way of life abroad. Related field trips. (Course only offered as part of CSUF Study Abroad Programs.) May be repeated once for credit.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* HSS 350 prerequisite: GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'HSS 350'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */

/* HSS 350 -> prerequisite -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'HSS 350'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'HUSR 133',
    'Introduction to Aging Studies',
    'Multidisciplinary overview of: characteristics, strengths and problems of older persons; diversity in aging process involving gender, race, ethnicity, subculture; services to older adults; gerontology as an academic discipline and a field of practice. (AGNG 133, SOCI 133, PUBH 133, HUSR 133 and PSYC 133 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'JAPN 315',
    'Introduction to Japanese Civilization',
    'Readings and lectures in Japanese literature, arts and institutions from earliest history to 1868, to develop insights into Japanese culture while strengthening facility in the language. Conducted primarily in Japanese.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'JAPN 316',
    'Modern Japan',
    'Readings and lectures in Japanese literature, arts and institutions from 1868 to the present, to develop insights into Japanese culture while strengthening facility in the language. Conducted primarily in Japanese.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'JAPN 375',
    'Introduction to Japanese Literature',
    'Introduction to literary forms and concepts of literary techniques. Analysis and interpretation of various texts. Conducted primarily in Japanese.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* JAPN 315 prerequisite: JAPN 204 and GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'JAPN 204 and GE Area 3B'
FROM courses c
WHERE c.course_code = 'JAPN 315'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'JAPN 204 and GE Area 3B'
  );

/* JAPN 316 prerequisite: JAPN 204 and GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'JAPN 204 and GE Area 3B'
FROM courses c
WHERE c.course_code = 'JAPN 316'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'JAPN 204 and GE Area 3B'
  );

/* JAPN 375 prerequisite: JAPN 305, JAPN 306, JAPN 307, JAPN 308, JAPN 310 or JAPN 311; GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'JAPN 305, JAPN 306, JAPN 307, JAPN 308, JAPN 310 or JAPN 311; GE Area 3B'
FROM courses c
WHERE c.course_code = 'JAPN 375'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'JAPN 305, JAPN 306, JAPN 307, JAPN 308, JAPN 310 or JAPN 311; GE Area 3B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   Same group_number = OR
   ========================================================= */

/* ---------------------------------------------------------
   JAPN 315
   Parsed as:
   JAPN 204 AND GE Area 3B
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'JAPN 204'
WHERE c.course_code = 'JAPN 315'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'JAPN 204 and GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'JAPN 315'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'JAPN 204 and GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );


/* ---------------------------------------------------------
   JAPN 316
   Parsed as:
   JAPN 204 AND GE Area 3B
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'JAPN 204'
WHERE c.course_code = 'JAPN 316'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'JAPN 204 and GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'JAPN 316'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'JAPN 204 and GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );


/* ---------------------------------------------------------
   JAPN 375
   Parsed as:
   (JAPN 305 OR JAPN 306 OR JAPN 307 OR JAPN 308 OR JAPN 310 OR JAPN 311)
   AND GE Area 3B
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code IN ('JAPN 305','JAPN 306','JAPN 307','JAPN 308','JAPN 310','JAPN 311')
WHERE c.course_code = 'JAPN 375'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'JAPN 305, JAPN 306, JAPN 307, JAPN 308, JAPN 310 or JAPN 311; GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'JAPN 375'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'JAPN 305, JAPN 306, JAPN 307, JAPN 308, JAPN 310 or JAPN 311; GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'LBST 133',
    'Explore Core: Truth',
    'Nature, significance and knowability of truth, exploring perspectives from philosophy, history, journalism, criminal justice, mathematics, engineering and the natural sciences. How is truth made or discovered? And why and when we should we trust the truths that emerge? (PHIL 133, BIOL 133, EGME 133, LBST 133 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'LBST 322',
    'Cross-Cultural Social Thought',
    'Interdisciplinary exploration of the variety of cultural and historical approaches to enduring questions of social life, organization, and cooperation. The differences, as well as interactions, between these approaches.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'LBST 325',
    'Cross-Cultural History of Medicine',
    'The diversity of health and healing systems from the early modern period to the present. Employ an interdisciplinary approach to examine the science and ethics of health and healing across a variety of geographical, historical and cultural contexts. (LBST 325 and HIST 325 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'LBST 330',
    'History of Early Science and Technology',
    'Science and technology in the development of human culture, especially the interactions among science, technology and society in ancient Greece and China, medieval and Renaissance Europe, and Islam. (HIST 330 and LBST 330 are the same course).',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'LBST 335',
    'Science on the Silver Screen',
    'Representations of science and scientists in film. Themes include images of scientists, the relationship between science and society, depictions of scientific personalities, and the emotional lives of scientists.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'LBST 340',
    'Food in the Social Sciences',
    'Interdisciplinary exploration of the study of food in the social sciences. The meanings of food in the construction of society and culture across time and space.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'LBST 341',
    'Ancient Eats: Food and Foodways in the Ancient World',
    'Food in the Roman Empire and elsewhere in the ancient world. Farming, sustainability, trade, purchasing, processing, production, ingredients, terroir, recipes, tools, the place and function of feasts, and food in myth, cult and philosophy (LBST 341 and HIST 341 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* LBST 322 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'LBST 322'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* LBST 325 prerequisite: GE Area 5A or 5B; junior or senior standing */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 5A or 5B; junior or senior standing'
FROM courses c
WHERE c.course_code = 'LBST 325'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 5A or 5B; junior or senior standing'
  );

/* LBST 330 prerequisite: GE Areas 5A and 5B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Areas 5A and 5B'
FROM courses c
WHERE c.course_code = 'LBST 330'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Areas 5A and 5B'
  );

/* LBST 335 prerequisite: GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'LBST 335'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

/* LBST 340 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'LBST 340'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* LBST 341 prerequisite: GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'LBST 341'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   Same group_number = OR
   ========================================================= */

/* LBST 322 -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'LBST 322'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );


/* LBST 325 parsed as:
   (GE Area 5A OR GE Area 5B) AND (Junior standing OR Senior standing)
*/
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'LBST 325'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A or 5B; junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'LBST 325'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A or 5B; junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'Junior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'LBST 325'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A or 5B; junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'Junior standing'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'Senior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'LBST 325'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A or 5B; junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'Senior standing'
  );


/* LBST 330 parsed as:
   GE Area 5A AND GE Area 5B
*/
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'LBST 330'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 5A and 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'LBST 330'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 5A and 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );


/* LBST 335 -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'LBST 335'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* LBST 340 -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'LBST 340'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* LBST 341 -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'LBST 341'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'LTAM 100',
    'Introduction to Latin American Studies',
    'Introduces salient features of Modern Latin America from an interdisciplinary perspective, emphasizing social, political, economic, and cultural trends. Analyze key historical moments, institutions, peoples, cultures, and issues to appreciate the diversity of Latin America today.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;

/* =========================================================
   COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'MATH 105',
    'Differential and Integral Calculus Essentials',
    'Properties of functions. Rules and applications of limits, derivatives, antiderivatives. Integrals. Fundamental theorem of calculus. Differential equations.',
    5,
    5,
    FALSE,
    FALSE
),
(
    'MATH 110',
    'Mathematics for Liberal Arts Students',
    'Survey of traditional and contemporary topics in mathematics, such as elementary logic, counting techniques, probability, statistics, and the mathematics of the social sciences.',
    3,
    3,
    FALSE,
    FALSE
),
(
    'MATH 115',
    'College Algebra',
    'Equations, inequalities, and systems of equations. Properties of functions and their graphs, including polynomial functions, rational functions, exponential and logarithmic functions, with applications. Sequences and series.',
    4,
    4,
    FALSE,
    FALSE
),
(
    'MATH 115A',
    'College Algebra (A)',
    'First semester of a two-semester sequence for students planning to take calculus who are not MATH/QR ready. Linear and quadratic equations with additional focus on foundation-level mathematics to support algebraic properties of linear and quadratic functions, graphs and applications.',
    3,
    3,
    FALSE,
    FALSE
),
(
    'KORE 204',
    'Intermediate Korean - B',
    'Continued development of communicative competence in Korean with a focus on listening, speaking, reading, writing and culture. Vocabulary building and developing grammatical accuracy.',
    3,
    3,
    FALSE,
    FALSE
),
(
    'KORE 380',
    'Korean Culture and Society: K-Pop',
    'Korean culture and society, as well as multicultural analysis of global issues, as reflected in Korean popular music. Examines K-pop as both text and industry.',
    3,
    3,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE course_code = course_code;


/* =========================================================
   REQUIREMENTS
   ========================================================= */

-- MATH 110 corequisite: MATH 10S
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT id, 'corequisite', 'Corequisite: MATH 10S'
FROM courses
WHERE course_code = 'MATH 110';

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id
)
SELECT
    cr.id,
    1,
    'course',
    c2.id
FROM course_requirements cr
JOIN courses c1 ON cr.course_id = c1.id
JOIN courses c2 ON c2.course_code = 'MATH 10S'
WHERE c1.course_code = 'MATH 110'
AND cr.requirement_type = 'corequisite';


-- KORE 204 prerequisite: KORE 203
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT id, 'prerequisite', 'Prerequisite: KORE 203'
FROM courses
WHERE course_code = 'KORE 204';

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id
)
SELECT
    cr.id,
    1,
    'course',
    c2.id
FROM course_requirements cr
JOIN courses c1 ON cr.course_id = c1.id
JOIN courses c2 ON c2.course_code = 'KORE 203'
WHERE c1.course_code = 'KORE 204'
AND cr.requirement_type = 'prerequisite';

/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'MUS 100',
    'Introduction to Music',
    'Musical enjoyment and understanding through a general survey of musical literature representative of a variety of styles and performance media. Music will be related to other arts through lectures, recordings, and concerts. For non-music majors.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'MUS 101',
    'Music Theory for Non-Music Majors',
    'Basic theory and practical applications to improve music performance and listening skills. Sight-singing and relationship to keyboard and simple melodic instruments. For non-music majors.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'MUS 302',
    'History of Jazz',
    'Historical study of jazz music in America, along with its antecedents; chronological development and stylistic evolution with consideration of related trends. Listening, reading and written work. Intended for non-music majors. May not be used as a music-major elective.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'MUS 303',
    'World Music',
    'Art, folk and popular music of selected world areas; topics vary according to semester and are chosen from Latin American, North American, Asian, African, and European cultures and traditions. Listening, reading and written work. Intended for non-music majors. May not be used as a music-major elective.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'MUS 304',
    'Music of Mexico',
    'Historical survey of folk, popular and art music traditions of Mexico and music in Mexican American/Chicano society; pre-Cortesian and contemporary indigenous musical practices; relationship of music to Mexican history and culture. Listening, reading and written work. Intended for non-music majors. May be used as a music-major elective. (MUS 304 and CHIC 304 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'MUS 305',
    'Women in Music',
    'Contributions women have made as composers and performers, and as musical patrons, as well as the historical limitations to which women musicians have been subject. Listening, reading and written work. Intended for non-music majors. May be used as a music-major elective.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'MUS 307',
    'History of Rock Music',
    'Rock music around the world; its origins and the development of national styles. Emphasis on listening. For non-music majors.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'MUS 350',
    'Music in American Society',
    'Music in its relationship to American culture and society. Sociological approach through the study of musical repertoires and concert life, as well as audience participation in musical consumption. Listening, reading and written work. Intended for non-music majors. May not be used as a music-major elective.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'MUS 355',
    'Film Music',
    'Historical survey of the use of music in motion pictures. Analysis and examination of film scores. Listening, reading and written work. Intended for non-music majors. May be used as a music-major elective.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'MUS 356',
    'African American Music Appreciation',
    'Black music in America; the sociological conditions that help produce various forms of black music. (AFAM 356 and MUS 356 are the same course)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'MUS 357',
    'Blacks in the Performing Arts',
    'African-American culture through the performing arts. Blacks in the entertainment industry as a means of understanding and revealing important aspects of African-American culture. (AFAM 357, MUS 357 and THTR 357 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* MUS 302 prerequisite: GE Area 3A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A'
FROM courses c
WHERE c.course_code = 'MUS 302'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A'
  );

/* MUS 303 prerequisite: GE Area 3A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A'
FROM courses c
WHERE c.course_code = 'MUS 303'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A'
  );

/* MUS 304 prerequisite: GE Area 3A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A'
FROM courses c
WHERE c.course_code = 'MUS 304'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A'
  );

/* MUS 305 prerequisite: GE Area 3A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A'
FROM courses c
WHERE c.course_code = 'MUS 305'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A'
  );

/* MUS 350 prerequisite: GE Area 3A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A'
FROM courses c
WHERE c.course_code = 'MUS 350'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A'
  );

/* MUS 355 prerequisite: GE Area 3A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A'
FROM courses c
WHERE c.course_code = 'MUS 355'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A'
  );

/* MUS 356 prerequisite: junior or senior standing */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'junior or senior standing'
FROM courses c
WHERE c.course_code = 'MUS 356'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'junior or senior standing'
  );

/* MUS 357 prerequisite: GE Area 3A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A'
FROM courses c
WHERE c.course_code = 'MUS 357'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Same group_number = OR
   ========================================================= */

/* MUS 302 -> prerequisite -> GE Area 3A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'MUS 302'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

/* MUS 303 -> prerequisite -> GE Area 3A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'MUS 303'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

/* MUS 304 -> prerequisite -> GE Area 3A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'MUS 304'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

/* MUS 305 -> prerequisite -> GE Area 3A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'MUS 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

/* MUS 350 -> prerequisite -> GE Area 3A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'MUS 350'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

/* MUS 355 -> prerequisite -> GE Area 3A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'MUS 355'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

/* MUS 356 -> prerequisite -> junior standing */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Junior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'MUS 356'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Junior standing'
  );

/* MUS 356 -> prerequisite -> senior standing */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Senior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'MUS 356'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'junior or senior standing'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Senior standing'
  );

/* MUS 357 -> prerequisite -> GE Area 3A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'MUS 357'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );
  /* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'NURS 345',
    'Pathophysiology',
    'Builds upon and explores major pathophysiological concepts using a body systems approach that is critical to clinical decision making in nursing. Recognize pathophysiological manifestations as they relate to disease processes.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'NURS 402',
    'Population Health Nursing',
    'Introduction to population health, public health core functions and services related to community as client. Epidemiology, ethical principles, mandates, multidisciplinary theories/models, research utilization and client advocacy applied to the nursing process for best practices for diverse, vulnerable, at risk populations.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* NURS 345 prerequisite: GE Areas 5A, 5B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Areas 5A and 5B'
FROM courses c
WHERE c.course_code = 'NURS 345'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Areas 5A and 5B'
  );

/* NURS 345 pre- or corequisites: NURS 305, NURS 310
   Stored as corequisite in this schema, while preserving note text.
*/
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'Pre- or corequisites: NURS 305, NURS 310'
FROM courses c
WHERE c.course_code = 'NURS 345'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'corequisite'
        AND cr.note = 'Pre- or corequisites: NURS 305, NURS 310'
  );

/* NURS 402 prerequisites: NURS 340, NURS 340L, NURS 345; GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'NURS 340, NURS 340L, NURS 345; GE Area 4A'
FROM courses c
WHERE c.course_code = 'NURS 402'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'NURS 340, NURS 340L, NURS 345; GE Area 4A'
  );

/* NURS 402 corequisite: NURS 402L */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'NURS 402L'
FROM courses c
WHERE c.course_code = 'NURS 402'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'corequisite'
        AND cr.note = 'NURS 402L'
  );

/* NURS 402 restriction: Department Consent Required */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'restriction', 'Department Consent Required'
FROM courses c
WHERE c.course_code = 'NURS 402'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'restriction'
        AND cr.note = 'Department Consent Required'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   Same group_number = OR
   ========================================================= */

/* ---------------------------------------------------------
   NURS 345
   Parsed as:
   GE Area 5A AND GE Area 5B
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'NURS 345'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 5A and 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'NURS 345'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 5A and 5B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );

/* NURS 345 pre- or corequisites: NURS 305 AND NURS 310
   Stored as corequisite items in this schema.
*/
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'NURS 305'
WHERE c.course_code = 'NURS 345'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'Pre- or corequisites: NURS 305, NURS 310'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'NURS 310'
WHERE c.course_code = 'NURS 345'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'Pre- or corequisites: NURS 305, NURS 310'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );


/* ---------------------------------------------------------
   NURS 402
   Parsed as:
   NURS 340 AND NURS 340L AND NURS 345 AND GE Area 4A
   --------------------------------------------------------- */

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'NURS 340'
WHERE c.course_code = 'NURS 402'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'NURS 340, NURS 340L, NURS 345; GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'NURS 340L'
WHERE c.course_code = 'NURS 402'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'NURS 340, NURS 340L, NURS 345; GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 3, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'NURS 345'
WHERE c.course_code = 'NURS 402'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'NURS 340, NURS 340L, NURS 345; GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 3
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 4, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'NURS 402'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'NURS 340, NURS 340L, NURS 345; GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 4
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* NURS 402 corequisite: NURS 402L */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'NURS 402L'
WHERE c.course_code = 'NURS 402'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'NURS 402L'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* NURS 402 restriction: Department Consent Required */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Department Consent Required'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'NURS 402'
  AND cr.requirement_type = 'restriction'
  AND cr.note = 'Department Consent Required'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Department Consent Required'
  );
  /* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'PERS 101',
    'Fundamental Persian-A',
    'Develop listening and reading comprehension, speaking and writing, and cultural awareness to communicate on a basic level. Introduction to Persian customs, cultures and civilization. Conducted primarily in Persian.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'PHIL 100',
    'Introduction to Philosophy',
    'Nature, methods and some of the main problems of philosophy. Primarily for freshmen and sophomores. Not a prerequisite for advanced courses.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 101',
    'Meaning, Purpose, and the Good Life',
    'Introduction to Western and Eastern approaches to perennial topics in philosophy concerning human flourishing and the nature of persons. Questions considered include, “What is happiness?” “What is the good life?” “Does life have meaning and purpose?” and “What is a person?”',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 105',
    'Critical Thinking',
    'Developing non-mathematical critical reasoning skills, including recognition of arguments, argument evaluation and construction of arguments.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 106',
    'Introduction to Logic',
    'Logical structure of language and correct reasoning: deduction, induction, scientific reasoning and informal fallacies.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 110',
    'Religions of the World',
    'Introduction to at least five religious world views from an historical and comparative perspective, with descriptive analyses of their belief systems, moral codes and symbolic rituals: Judaism, Christianity, Islam, Hinduism, Buddhism and Sikhism. (RLST 110 and PHIL 110 are same course.)',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 120',
    'Introduction to Ethics',
    'Problems of human conduct and moral evaluation: standards for moral assessment of conduct and persons; morality and its relation to mores, social demands and personal commitments.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 133',
    'Explore Core: Truth',
    'Nature, significance and knowability of truth, exploring perspectives from philosophy, history, journalism, criminal justice, mathematics, engineering and the natural sciences. How is truth made or discovered? And why and when we should we trust the truths that emerge? (PHIL 133, BIOL 133, EGME 133, LBST 133 are the same course.)',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 290',
    'History of Philosophy: Greek Philosophy',
    'Origins of Western philosophy and its development through Socrates, Plato and Aristotle.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 300',
    'History of Philosophy: Rationalism and Empiricism',
    'Rationalism of Descartes, Spinoza and Leibniz, and the empiricism of Locke, Berkeley and Hume.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 302',
    'Gender and Sexuality Studies',
    'Interdisciplinary introduction to women’s issues and research in relevant disciplines. (GSS 302 and PHIL 302 are the same course.)',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 303',
    'Introduction to the Philosophy of Science',
    'The ongoing debates within philosophy of science about the claims of scientific progress, and the limits of scientific knowledge and the scientific method, with an eye on the impact of science on society and of society on science.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 311',
    'Aesthetics: Philosophy of Art and Beauty',
    'Conditions and aims of art and of aesthetic experience.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 312',
    'Business and Professional Ethics',
    'Nature and limits of the moral rights and responsibilities of business and the professions (including law, medicine, science, engineering, journalism, management and teaching).',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 313',
    'Environmental Ethics',
    'Conceptual and moral foundations of environmental ethics, focusing on ecosystem and wildlife conservation policies, animal rights, a land ethic, competing policy analyses and obligations to future generations.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 314',
    'Medical Ethics',
    'Ethical issues raised by recent technical developments in medicine and of the moral rights and responsibilities of patients and health-care professionals.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 320',
    'Contemporary Moral Issues',
    'Applying ethical and social/political theories to contemporary moral problems. Topics selected from current issues in law, business, medicine, sexual morality, and gender/multicultural studies, including abortion, racism, crime, punishment, welfare, domestic violence and pornography.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 322',
    'Ethics, Artificial Intelligence and Robots',
    'Ethical issues related to technological advancements of AI and robotics. Topics include: AI¿s accountability, transparency, implicit biases, value alignment; robots¿ ethical guidelines and potential moral/legal status; and possible massive human job displacement resulting from AI and robotics.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 323',
    'Existentialism',
    'Introduction to existentialist perspectives on freedom, meaning, responsibility, authenticity and self-deception. Typically includes discussion of Kierkegaard, Nietzsche, Heidegger and Sartre.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 325',
    'Philosophy of Sex and Love',
    'Philosophical approaches to love, friendship, marriage and eroticism. Nature of love, relationship between sexuality and love, gender roles and gender equality. Investigates ethical and legal controversies in sexuality, marriage and privacy.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 333',
    'Evolution and Creation',
    'Interdisciplinary study of evolutionary biology’s impact on culture in context of religious doctrines of creation. Evolutionary theory and religious and philosophical reactions from Darwin to the present, including relevant educational and legal contexts. (PHIL 333 and LBST 333 are the same course.)',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 349',
    'Philosophy, Literature and Cinema',
    'Aesthetics of literature and film, emphasizing how storytelling deepens our imagination and understanding of identity, culture, society and values through use of word and image.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 350',
    'Asian Philosophy',
    'Asian philosophies such as Taoism, Confucianism and Buddhism (especially Zen): world views, conceptions of human nature and the good life. Applications to martial and non-martial arts. Comparisons with Western philosophies, religions and values.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 368',
    'First Course in Symbolic Logic',
    'Recognition and construction of correct deductions in the sentential logic and the first-order predicate calculus.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 377',
    'Philosophical Approaches to Race, Class, and Gender',
    'Despite the history of analyzing race, class, and gender as separate phenomena, the three are integrally connected. Focus on the interstitial connections among the three to gain knowledge of the formation of race, class and gender.',
    3.0, 3.0, FALSE, FALSE
),
(
    'PHIL 379',
    'American Philosophy',
    'Examines and critiques significant philosophical themes, texts, and trends in the philosophy of the Americas in the late 19th and early 20th century, especially the classical pragmatists (e.g. Peirce, James, Dewey, Addams, DuBois), and their contemporary interpreters (e.g. Misak, Haack, Talisse).',
    3.0, 3.0, FALSE, FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'PHIL 300'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 5A or 5B; or lower-division philosophy course'
FROM courses c
WHERE c.course_code = 'PHIL 303'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 5A or 5B; or lower-division philosophy course'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3A or 3B'
FROM courses c
WHERE c.course_code = 'PHIL 311'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3A or 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'junior or senior standing'
FROM courses c
WHERE c.course_code = 'PHIL 312'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'junior or senior standing'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B or 4A'
FROM courses c
WHERE c.course_code = 'PHIL 313'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B or 4A'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'PHIL 314'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'PHIL 320'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'PHIL 325'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Areas 3B and 5B'
FROM courses c
WHERE c.course_code = 'PHIL 333'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Areas 3B and 5B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'PHIL 350'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 2A, 5A or 5B'
FROM courses c
WHERE c.course_code = 'PHIL 368'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 2A, 5A or 5B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'lower-division philosophy course'
FROM courses c
WHERE c.course_code = 'PHIL 377'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'lower-division philosophy course'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'PHIL 379'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   Same group_number = OR
   ========================================================= */

/* PHIL 300 -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 300'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* PHIL 303 -> (GE Area 5A OR GE Area 5B) OR lower-division philosophy course */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 303'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A or 5B; or lower-division philosophy course'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 303'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A or 5B; or lower-division philosophy course'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Lower-division philosophy course'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 303'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A or 5B; or lower-division philosophy course'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Lower-division philosophy course'
  );

/* PHIL 311 -> GE Area 3A OR 3B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 311'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 311'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3A or 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* PHIL 312 -> junior OR senior standing */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Junior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 312'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'junior or senior standing'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Junior standing'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Senior standing'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 312'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'junior or senior standing'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Senior standing'
  );

/* PHIL 313 -> GE Area 3B OR 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 313'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B or 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 313'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B or 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* PHIL 314 -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 314'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* PHIL 320 -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 320'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* PHIL 325 -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 325'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* PHIL 333 -> GE Area 3B AND GE Area 5B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 333'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 3B and 5B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 333'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 3B and 5B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );

/* PHIL 350 -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 350'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* PHIL 368 -> GE Area 2A OR 5A OR 5B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 2A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 368'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 2A, 5A or 5B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 2A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 368'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 2A, 5A or 5B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 368'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 2A, 5A or 5B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5B'
  );

/* PHIL 377 -> lower-division philosophy course */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'Lower-division philosophy course'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 377'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'lower-division philosophy course'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'Lower-division philosophy course'
  );

/* PHIL 379 -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHIL 379'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'PHYS 101',
    'Survey of Physics',
    'Basic concepts of physics for the non-science major. Physical concepts in real-world contexts such as global warming. How our ideas about motion, energy, heat and temperature, light and color, electricity, and atoms form a framework for understanding the natural world.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'PHYS 101L',
    'Survey of Physics Laboratory',
    'Experiments that demonstrate important concepts in astronomy and physics. For non-science majors.',
    1.0,
    1.0,
    TRUE,
    FALSE
),
(
    'PHYS 155',
    'Quantum Computing for Everyone',
    'Introduction to the new field of quantum computing. What is quantum physics? What is entanglement? What makes a quantum computer so special? Preparation for reading and understanding popular science articles on advances in quantum computing and other quantum technologies.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'PHYS 211',
    'Elementary Physics',
    'Introduction to mechanics and thermodynamics. Designed for life and health science majors.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'PHYS 211L',
    'Elementary Physics: Laboratory',
    'Laboratory for PHYS 211. (3 hours laboratory). Instructional fee required.',
    1.0,
    1.0,
    TRUE,
    FALSE
),
(
    'PHYS 301',
    'Energy and Sustainability',
    'Basic physical principles applied to the generation and use of energy. Conventional and alternative energy sources. Environmental consequences of energy use, greenhouse effect, global warming. Energy conservation principles.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'PHYS 305',
    'Physics of Sound',
    'Applying physical principles in music, including topics such as sound wave propagation, time periodicity, vibrations, resonance, acoustics and human perception. Selected topics in stringed, woodwind, brass instruments, the human voice, recording and playback, and digital vs. analog music.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* PHYS 101L corequisite: PHYS 101 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'PHYS 101'
FROM courses c
WHERE c.course_code = 'PHYS 101L'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'corequisite'
        AND cr.note = 'PHYS 101'
  );

/* PHYS 211 prerequisite: MATH 125, MATH 130 or MATH 150A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'MATH 125, MATH 130 or MATH 150A'
FROM courses c
WHERE c.course_code = 'PHYS 211'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'MATH 125, MATH 130 or MATH 150A'
  );

/* PHYS 211 corequisite: PHYS 211L */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'PHYS 211L'
FROM courses c
WHERE c.course_code = 'PHYS 211'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'corequisite'
        AND cr.note = 'PHYS 211L'
  );

/* PHYS 211L corequisite: PHYS 211 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'PHYS 211'
FROM courses c
WHERE c.course_code = 'PHYS 211L'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'corequisite'
        AND cr.note = 'PHYS 211'
  );

/* PHYS 301 prerequisite: GE Area 5A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 5A'
FROM courses c
WHERE c.course_code = 'PHYS 301'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 5A'
  );

/* PHYS 305 prerequisite: GE Area 5A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 5A'
FROM courses c
WHERE c.course_code = 'PHYS 305'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 5A'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Same group_number = OR
   Different group_number = AND
   ========================================================= */

/* PHYS 101L -> corequisite -> PHYS 101 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'PHYS 101'
WHERE c.course_code = 'PHYS 101L'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'PHYS 101'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* PHYS 211 -> prerequisite -> MATH 125 OR MATH 130 OR MATH 150A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'MATH 125'
WHERE c.course_code = 'PHYS 211'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'MATH 125, MATH 130 or MATH 150A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'MATH 130'
WHERE c.course_code = 'PHYS 211'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'MATH 125, MATH 130 or MATH 150A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'MATH 150A'
WHERE c.course_code = 'PHYS 211'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'MATH 125, MATH 130 or MATH 150A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* PHYS 211 -> corequisite -> PHYS 211L */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'PHYS 211L'
WHERE c.course_code = 'PHYS 211'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'PHYS 211L'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* PHYS 211L -> corequisite -> PHYS 211 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'PHYS 211'
WHERE c.course_code = 'PHYS 211L'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'PHYS 211'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* PHYS 301 -> prerequisite -> GE Area 5A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHYS 301'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5A'
  );

/* PHYS 305 -> prerequisite -> GE Area 5A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 5A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PHYS 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 5A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 5A'
  );


/* =========================================================
   4) COURSE PAIRS
   ========================================================= */

/* Pair PHYS 101 with PHYS 101L as lecture_lab */
INSERT INTO course_pairs (
    course_id,
    paired_course_id,
    pair_type
)
SELECT c1.id, c2.id, 'lecture_lab'
FROM courses c1
JOIN courses c2
  ON c1.course_code = 'PHYS 101'
 AND c2.course_code = 'PHYS 101L'
WHERE NOT EXISTS (
    SELECT 1
    FROM course_pairs cp
    WHERE cp.course_id = c1.id
      AND cp.paired_course_id = c2.id
      AND cp.pair_type = 'lecture_lab'
);

/* Pair PHYS 211 with PHYS 211L as lecture_lab */
INSERT INTO course_pairs (
    course_id,
    paired_course_id,
    pair_type
)
SELECT c1.id, c2.id, 'lecture_lab'
FROM courses c1
JOIN courses c2
  ON c1.course_code = 'PHYS 211'
 AND c2.course_code = 'PHYS 211L'
WHERE NOT EXISTS (
    SELECT 1
    FROM course_pairs cp
    WHERE cp.course_id = c1.id
      AND cp.paired_course_id = c2.id
      AND cp.pair_type = 'lecture_lab'
);

/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'PORT 105',
    'Introduction to Portuguese Language and Culture',
    'Introduction to the Lusophone world through the study of the language, customs, culture and products of Portuguese-speaking communities. Develop cultural and communicative competence at an introductory level. Conducted in Portuguese.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'PORT 214',
    'Intermediate Portuguese Language and Culture',
    'Continued study of the language, customs, culture and products of Portuguese-speaking communities in Europe, Africa and the Americas. Develops cultural and communicative competence at an intermediate level. Conducted in Portuguese.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* PORT 214 prerequisite: PORT 105 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'PORT 105'
FROM courses c
WHERE c.course_code = 'PORT 214'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'PORT 105'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */

/* PORT 214 -> prerequisite -> PORT 105 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'PORT 105'
WHERE c.course_code = 'PORT 214'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'PORT 105'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );
  
  /* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'POSC 200',
    'Introduction to the Study of Politics',
    'Introduction to the study of politics and its foundations: power; war and diplomacy; government and its administration in the U.S. and internationally; institutions; law; justice; and ideology.',
    3.0, 3.0, FALSE, FALSE
),
(
    'POSC 300',
    'California Government and Politics',
    'California state and local government institutions and politics, including direct democracy and current policy issues. The role of California state and local governments in the federal system, including comparisons with other state and local governments. Satisfies state requirement in California state and local government.',
    3.0, 3.0, FALSE, FALSE
),
(
    'POSC 309',
    'Introduction to Local Government',
    'Introduction to the evolution and variety of local governments in the United States. Topics include urban political machines and reform, home rule, urban policy, local politics, planning, intergovernmental relations and local government finance.',
    3.0, 3.0, FALSE, FALSE
),
(
    'POSC 310',
    'Political Behavior',
    'Analyze issues and divisions in American politics, as viewed through voting, protest and other behaviors. Race, class, ideology and parties.',
    3.0, 3.0, FALSE, FALSE
),
(
    'POSC 315',
    'Introduction to Public Policy',
    'Federal domestic policy making. Structure, functions and relationships among American national institutions, including executive, legislative and judicial branches, media, political parties and pressure groups.',
    3.0, 3.0, FALSE, FALSE
),
(
    'POSC 320',
    'Introduction to Public Administration',
    'Introduces public administration through current trends and problems of public sector agencies in such areas as organization behavior, public budgeting, personnel, planning and policy making. Examples and cases from the Criminal Justice field. (POSC 320 and CRJU 320 are the same course.)',
    3.0, 3.0, FALSE, FALSE
),
(
    'POSC 322',
    'Leadership for Public Service',
    'Conceptions of leadership as applied in governmental and nonprofit sectors. Types of leaders; tools for leaders; leadership in public policy-making settings. Includes student project and extend leadership concepts; participation in CSUF Student Leadership Institute or similar activity. (POSC 322 and CRJU 322 are the same course.)',
    3.0, 3.0, FALSE, FALSE
),
(
    'POSC 330',
    'Politics in Nation-States',
    'Compares patterns of political behavior and interaction in various political systems.',
    3.0, 3.0, FALSE, FALSE
),
(
    'POSC 340',
    'Political Philosophy',
    'Major thinkers in the Western tradition of political philosophy from Plato to the present; the principal concepts and theories.',
    3.0, 3.0, FALSE, FALSE
),
(
    'POSC 350',
    'International Relations',
    'Political relationships among governments and other participants within the global system: internal and external factors influencing foreign policies of the great powers, their allies and minor powers; role of non-state actors, such as the United Nations, multinational corporations and liberation movements.',
    3.0, 3.0, FALSE, FALSE
),
(
    'POSC 352',
    'American Foreign Policy',
    'Formation and implementation of American foreign policy since 1945; the origins of the Cold War and the reasons for its end; debates about American grand strategy after the Cold War and 9/11.',
    3.0, 3.0, FALSE, FALSE
),
(
    'POSC 375',
    'Law, Politics and Society',
    'Law as emergent from political processes, rooted within social norms and communities. Law as a feature of the modern state, a tool for seeking advantage, domination and/or liberation. An overview of legislative, judicial, administrative, and other political processes that produce law.',
    3.0, 3.0, FALSE, FALSE
),
(
    'POSC 381',
    'Religion and Politics in the United States',
    'Relationship of politics and religion, especially in the U.S. The colonial and constitutional experience, Supreme Court decisions on religious issues, the principal theorists of moral discourse in the public forum, contemporary issues of concern. (RLST 381 and POSC 381 are the same course.)',
    3.0, 3.0, FALSE, FALSE
),
(
    'POSC 485',
    'Women, Gender and Politics',
    'Changing political environment and women’s role in elected, appointed and other public agencies; issues of particular concern to women, including family issues, comparable worth and other economic issues and political participation. (POSC 485 and GSS 485 are the same course)',
    3.0, 3.0, FALSE, FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'POSC 100 or HONR 201B'
FROM courses c
WHERE c.course_code = 'POSC 300'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'POSC 100 or HONR 201B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'POSC 100 or HONR 201B'
FROM courses c
WHERE c.course_code = 'POSC 309'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'POSC 100 or HONR 201B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'POSC 100'
FROM courses c
WHERE c.course_code = 'POSC 310'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'POSC 100'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'POSC 100, GE Area 4A'
FROM courses c
WHERE c.course_code = 'POSC 315'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'POSC 100, GE Area 4A'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'POSC 100, GE Area 4A'
FROM courses c
WHERE c.course_code = 'POSC 320'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'POSC 100, GE Area 4A'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'POSC 100, POSC 200 or GE Area 4A'
FROM courses c
WHERE c.course_code = 'POSC 322'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'POSC 100, POSC 200 or GE Area 4A'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A; POSC 100 or HONR 201B'
FROM courses c
WHERE c.course_code = 'POSC 330'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A; POSC 100 or HONR 201B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'POSC 100 or HONR 201B'
FROM courses c
WHERE c.course_code = 'POSC 340'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'POSC 100 or HONR 201B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'POSC 100'
FROM courses c
WHERE c.course_code = 'POSC 350'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'POSC 100'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'POSC 100'
FROM courses c
WHERE c.course_code = 'POSC 352'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'POSC 100'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A; POSC 100 or HONR 201B'
FROM courses c
WHERE c.course_code = 'POSC 375'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A; POSC 100 or HONR 201B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'POSC 381'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'POSC 100 or HONR 201B'
FROM courses c
WHERE c.course_code = 'POSC 485'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'POSC 100 or HONR 201B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   Same group_number = OR
   ========================================================= */

/* POSC 300 -> POSC 100 OR HONR 201B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 100'
WHERE c.course_code = 'POSC 300'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'HONR 201B'
WHERE c.course_code = 'POSC 300'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* POSC 309 -> POSC 100 OR HONR 201B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 100'
WHERE c.course_code = 'POSC 309'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'HONR 201B'
WHERE c.course_code = 'POSC 309'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* POSC 310 -> POSC 100 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 100'
WHERE c.course_code = 'POSC 310'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* POSC 315 -> POSC 100 AND GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 100'
WHERE c.course_code = 'POSC 315'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100, GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'POSC 315'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100, GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* POSC 320 -> POSC 100 AND GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 100'
WHERE c.course_code = 'POSC 320'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100, GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'POSC 320'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100, GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* POSC 322 -> (POSC 100 AND POSC 200) OR GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 100'
WHERE c.course_code = 'POSC 322'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100, POSC 200 or GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 200'
WHERE c.course_code = 'POSC 322'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100, POSC 200 or GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'POSC 322'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100, POSC 200 or GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* POSC 330 -> GE Area 4A AND (POSC 100 OR HONR 201B) */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'POSC 330'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A; POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 100'
WHERE c.course_code = 'POSC 330'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A; POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'HONR 201B'
WHERE c.course_code = 'POSC 330'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A; POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* POSC 340 -> POSC 100 OR HONR 201B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 100'
WHERE c.course_code = 'POSC 340'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'HONR 201B'
WHERE c.course_code = 'POSC 340'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* POSC 350 -> POSC 100 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 100'
WHERE c.course_code = 'POSC 350'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* POSC 352 -> POSC 100 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 100'
WHERE c.course_code = 'POSC 352'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* POSC 375 -> GE Area 4A AND (POSC 100 OR HONR 201B) */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'POSC 375'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A; POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 100'
WHERE c.course_code = 'POSC 375'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A; POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'HONR 201B'
WHERE c.course_code = 'POSC 375'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A; POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* POSC 381 -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'POSC 381'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* POSC 485 -> POSC 100 OR HONR 201B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'POSC 100'
WHERE c.course_code = 'POSC 485'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'HONR 201B'
WHERE c.course_code = 'POSC 485'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'POSC 100 or HONR 201B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'PSYC 101',
    'Introductory Psychology',
    'Concepts, issues, and methods of psychology. Processes of sensation/perception, motivation/emotion, learning/memory, cognition. Research in developmental, personality, social, abnormal, and biological psychology. Research participation required. It is recommended that students satisfy the ELM requirement before enrolling.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'PSYC 110',
    'Critical Thinking in Psychology',
    'Models and strategies of critical thinking. Training in inductive and deductive reasoning techniques; strategies for self-regulation of thinking. Formal and informal fallacies; social, cognitive, and emotional factors that aid and interfere with critical thinking and reasoning.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'PSYC 133',
    'Introduction to Aging Studies',
    'Multidisciplinary overview of: characteristics, strengths and problems of older persons; diversity in aging process involving gender, race, ethnicity, subculture; services to older adults; gerontology as an academic discipline and a field of practice. (AGNG 133, SOCI 133, PUBH 133, HUSR 133 and PSYC 133 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'PSYC 311',
    'Educational Psychology',
    'Applying psychological research and theory to educational processes, including learning, motivation, individual differences, teaching methods and evaluation. Recommended for those interested in teaching careers.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'PSYC 321',
    'Psychology of Religion',
    'A survey of classical and contemporary empirical psychological research investigating religious beliefs, experiences and practices. Topics include religious behavior across the lifespan; the social psychology of religious organizations; and religious connections to morality, coping, and psychopathology. (RLST 321 and PSYC 321 are the same course).',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'PSYC 322',
    'Black Psychology',
    'Uses psychological principles and practices to guide students’ comprehension of life as an African American. Introduction to a holistic perspective that expands ways of conceptualizing psychology from an African American world view. (AFAM 322 and PSYC 322 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'PSYC 331',
    'Personality Psychology',
    'Traditional and contemporary approaches to research, theory and assessment techniques in the area of personality.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'PSYC 341',
    'Psychological Disorders',
    'Symptoms, causes, treatment and prevention of psychological disorders/psychiatric illnesses; for example, anxiety, mood, psychotic disorders and related topics.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'PSYC 346',
    'Asian American Psychology',
    'Major issues in the Asian American community from a psychosocial perspective, including ethnic identity development, generational conflicts, the “model minority” myth, interracial relationships, attitudes toward mental health services and alternative healing/therapeutic approaches. (ASAM 346 and PSYC 346 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'PSYC 351',
    'Social Psychology',
    'How the social world affects our thoughts, feelings, and behaviors. Thinking about, influencing, and relating to others. Social perception/cognition, attitudes and attitude change, attraction, prejudice, aggression, helping behavior, conformity, and group processes.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* PSYC 311 prerequisite: PSYC 101 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'PSYC 101'
FROM courses c
WHERE c.course_code = 'PSYC 311'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'PSYC 101'
  );

/* PSYC 321 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'PSYC 321'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* PSYC 322 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'PSYC 322'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* PSYC 331 prerequisite: PSYC 101 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'PSYC 101'
FROM courses c
WHERE c.course_code = 'PSYC 331'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'PSYC 101'
  );

/* PSYC 341 prerequisite: PSYC 101 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'PSYC 101'
FROM courses c
WHERE c.course_code = 'PSYC 341'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'PSYC 101'
  );

/* PSYC 346 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'PSYC 346'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* PSYC 351 prerequisite: PSYC 101 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'PSYC 101'
FROM courses c
WHERE c.course_code = 'PSYC 351'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'PSYC 101'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */

/* PSYC 311 -> prerequisite -> PSYC 101 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'PSYC 101'
WHERE c.course_code = 'PSYC 311'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'PSYC 101'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* PSYC 321 -> prerequisite -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PSYC 321'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* PSYC 322 -> prerequisite -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PSYC 322'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* PSYC 331 -> prerequisite -> PSYC 101 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'PSYC 101'
WHERE c.course_code = 'PSYC 331'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'PSYC 101'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* PSYC 341 -> prerequisite -> PSYC 101 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'PSYC 101'
WHERE c.course_code = 'PSYC 341'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'PSYC 101'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* PSYC 346 -> prerequisite -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PSYC 346'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* PSYC 351 -> prerequisite -> PSYC 101 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'PSYC 101'
WHERE c.course_code = 'PSYC 351'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'PSYC 101'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );
  
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'PUBH 381',
    'Climate Change and Global Health',
    'Explore global health outcomes of climate change through social-ecological systems that influence patterns of infectious and chronic diseases worldwide. Cross-cutting themes, such as health equity and justice.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* PUBH 381 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'PUBH 381'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */

/* PUBH 381 -> prerequisite -> GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'PUBH 381'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'READ 131',
    'Explore Core: Migrant Lives',
    'Differing sociocultural experiences of different migrant groups. How immigration as a process impacts physical, cognitive and socioemotional development of migrants’ children. Educational experiences of migrants and implications for schools and society. (CAS 131, AMST 131 and READ 131 are the same course)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'READ 290A',
    'Critical Reading, Thinking and Literacy',
    'Relationship of critical reading to critical thinking. Develop critical thinking skills with application in interpretation, analysis, criticism and advocacy of ideas encountered in academic readings.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'READ 295',
    'Critical Literacies for Advocacy and Community Engagement',
    'Exploring and applying intellectual habits and dispositions across dimensions of literacy. Evaluate and create information to facilitate collaborative solutions for fostering change in the community. Culminating project advocating for local change and action with global implication.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'READ 360',
    'Literacy Education for Social Change',
    'Guides students through theories of critical and de-colonial literacies, alongside exploration and practice in qualitative inquiry, in order to deeply reflect on meaningful educational and social change in schools and societies. Fieldwork component. (READ 360 and CHIC 360 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* READ 360 prerequisite: GE Area 4A */

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'READ 360'
AND NOT EXISTS (
    SELECT 1
    FROM course_requirements cr
    WHERE cr.course_id = c.id
    AND cr.requirement_type = 'prerequisite'
    AND cr.note = 'GE Area 4A'
);


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */

/* READ 360 -> prerequisite -> GE Area 4A */

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT
    cr.id,
    1,
    'text',
    NULL,
    NULL,
    'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'READ 360'
AND cr.requirement_type = 'prerequisite'
AND cr.note = 'GE Area 4A'
AND NOT EXISTS (
    SELECT 1
    FROM course_requirement_items cri
    WHERE cri.course_requirement_id = cr.id
    AND cri.group_number = 1
    AND cri.item_type = 'text'
    AND cri.item_text = 'GE Area 4A'
);

/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'RLST 100',
    'Introduction to the Study of Religion',
    'An introduction to the academic study of religion, exploring the social and cultural dimensions of religion, as well as religious consciousness and perception. Key concepts, theorists and methodological approaches.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 105',
    'Religion and the Quest for Meaning',
    'Nature of religious experience as the human pursuit of meaning and transcendence, exploring its central themes, phenomena and questions; its principal types of figures and communities; and its major categories of sacred rituals, objects, seasons and places.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 110',
    'Religions of the World',
    'Introduction to at least five religious world views from an historical and comparative perspective, with descriptive analyses of their belief systems, moral codes and symbolic rituals: Judaism, Christianity, Islam, Hinduism, Buddhism and Sikhism. (RLST 110 and PHIL 110 are same course.)',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 200',
    'Introduction to Christianity',
    'Overview of the Christian tradition, including Eastern Orthodox, Roman Catholic and Protestant expressions. Beliefs, practices and authority structures.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 210',
    'Introduction to Judaism',
    'The Jewish tradition - its scriptures, laws, customs, holidays and world view in their historical setting.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 250',
    'Introduction to Islam',
    'Religion of Islam, its background and main teachings: the rise of Islam; the caliphate; Islamic theology, teachings, mysticism and philosophy.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 270T',
    'Introduction to the Asian Religions',
    'Main teachings of a major South Asian, Far Eastern or “Oriental” religion per semester, including such religions as Jainism, Hinduism, Sikhism, Taoism, Shintoism and Zoroastrianism. May be repeated for credit with different subject matter.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 280',
    'Introduction to Buddhism',
    'Introduction to the origins and development of Buddhism. The major teachings found in all traditions of Buddhism, the three major traditions of Buddhism and the position of Buddhism in the U.S.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 305',
    'Anthropology of Religion',
    'Beliefs and practices in the full human variation of religious phenomena, with an emphasis on primitive religions. Forms, functions, structures, symbolism, and history and evolution of religious systems. (ANTH 305 and RLST 305 are the same course.)',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 307',
    'Non-violence, Animal Rights and Diet in Jainism',
    'Development of the beliefs, practices, culture, philosophy and art of the Jain religion. Examine core Jain principles, such as nonviolence and non-possessiveness and their contemporary relevance. Fieldtrip to a major Jain site in Southern California.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 312',
    'The Bible as Literature',
    'Literary qualities of biblical literature and the influence of major themes upon Western literary traditions. (CPLT 312 and RLST 312 are the same course.)',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 321',
    'Psychology of Religion',
    'A survey of classical and contemporary empirical psychological research investigating religious beliefs, experiences and practices. Topics include religious behavior across the lifespan; the social psychology of religious organizations; and religious connections to morality, coping, and psychopathology. (RLST 321 and PSYC 321 are the same course).',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 325',
    'African American Religions and Spirituality',
    'African-American belief systems and denominations. Folk beliefs among Blacks, African-American religious groups and the role of the Black Church in politics and social change in the Black community. (AFAM 325 and RLST 325 are the same course.)',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 333',
    'Religion and Sexuality',
    'Connection between religion and sexuality. The religious ideas behind political and public debates related to sexuality and consideration of the private realm, such as sexual identity, family life, gender roles and reproduction.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 341',
    'Hindu Tradition to 400 B.C.E.',
    'Hindu thought in its earliest period. Overview of Vedic literature, especially its religious content and the major rituals of the early Veda; philosophical developments in the Upanisads or later Veda; and related sacred writings.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 342',
    'Hindu Tradition from 400 B.C.E.',
    'Hindu thought after the Vedic period. The beginnings of Hindu philosophies, classical Hindu practice, devotionalism, modern or neo-Hindu groups appearing in the 19th century, and the contributions of thinkers, such as Ramakrishna and Gandhi.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 351',
    'History and Development of Early Christian Thought',
    'Historical study of the diversity of Christian beliefs, movements and key figures from New Testament times to the late Middle Ages, including important creeds and councils, spiritual movements, and central figures such as Augustine and Aquinas.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 352',
    'History and Development of Modern Christian Thought',
    'Historical study of the diversity of Christian beliefs, movements and key figures from the late Middle Ages to the present, including the context and thinkers of the Reformation era, post-Reformation controversies and recent debates and trends.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 361',
    'History and Development of Jewish Thought: Biblical and Rabbinical Eras',
    'Hebrew Scriptures in their historical context, development of rabbinical Judaism and the Talmud, and Judaism in the Christian and Muslim worlds down to the close of the Spanish “Golden Age” (1150).',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 362',
    'History and Development of Jewish Thought: Medieval and Modern Eras',
    'Maimonides’ legacy, impact of mysticism, rise of anti-Semitism, emancipation of European Jews, the Holocaust, Israel’s founding and history, and contributions of Jews to American culture.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 367',
    'Religion in Latino/a Life',
    'National and international expressions of Latino/a religiosity - from popular religion to Marian devotion to curanderismo - through film, historical documents, poetry, theology, art, sociology and ethnic studies. (RLST 367 and CHIC 367 are the same course.)',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 370',
    'New Religious Movements in the U.S.A.',
    'Beliefs, history, ritual and organizational makeup of nontraditional modern religions in America, such as Scientology, the Unification Church, Hare Krishna (ISKCON) and Rajneeshism as presented by guest speakers. Discussion of “cult,” “sect” and the occult.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 371',
    'History and Development of Islamic Thought: The Beginning to 1258',
    'Islamic theology, law, culture, and spirituality up to the close of the classical period in 1258. Interpretation of the Qur’an, formation of Hadith literature, development of Islamic law, divisions within Islam, rise of mysticism, contributions to science and art.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 372',
    'History and Development of Islamic Thought: 1259 to Modern Times',
    'Islamic thought from the close of the classical period to the present, with emphasis on 20th century developments. Emergence of modern Middle East, reform movements, Islamic response to nationalism and modernity, recent Islamic resurgence.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 373',
    'Women in Islam',
    'Status and roles of Muslim women from the perspectives of the basic Islamic texts (The Qur’an and Prophetic Traditions). Rights, marriage and divorce, seclusion and dress codes, and religious, economic and socio-political participation.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 374',
    'Issues in Contemporary Islam',
    'Some of the contentious issues in Islam. Concepts of piety, peace, jihad, fundamentalism, terrorism, democracy, human rights, leadership of women and sexuality; the intellectual arguments surrounding these topics.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 375',
    'Conceptions of the Afterlife',
    'How selected religious traditions have sought to answer the question: “What happens when I die.” Resurrection, reincarnation, immortality of the soul, heaven and hell. RLST 110 recommended.',
    3.0, 3.0, FALSE, FALSE
),
(
    'RLST 381',
    'Religion and Politics in the United States',
    'Relationship of politics and religion, especially in the U.S. The colonial and constitutional experience, Supreme Court decisions on religious issues, the principal theorists of moral discourse in the public forum, contemporary issues of concern. (RLST 381 and POSC 381 are the same course.)',
    3.0, 3.0, FALSE, FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 305'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 307'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 312'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'RLST 321'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'RLST 325'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'RLST 333'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'RLST 110 or GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 341'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'RLST 110 or GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'RLST 105, RLST 110 or GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 342'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'RLST 105, RLST 110 or GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 351'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 352'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 361'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 362'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 367'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A and 3U or 4U'
FROM courses c
WHERE c.course_code = 'RLST 370'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A and 3U or 4U'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 371'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 372'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 373'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 374'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'RLST 375'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'RLST 381'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   Same group_number = OR
   ========================================================= */

/* RLST 305 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 305'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 307 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 307'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 312 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 312'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 321 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 321'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* RLST 325 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 325'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* RLST 333 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 333'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* RLST 341 -> RLST 110 OR GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'RLST 110'
WHERE c.course_code = 'RLST 341'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'RLST 110 or GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 341'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'RLST 110 or GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 342 -> RLST 105 OR RLST 110 OR GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'RLST 105'
WHERE c.course_code = 'RLST 342'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'RLST 105, RLST 110 or GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'RLST 110'
WHERE c.course_code = 'RLST 342'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'RLST 105, RLST 110 or GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 342'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'RLST 105, RLST 110 or GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 351 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 351'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 352 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 352'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 361 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 361'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 362 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 362'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 367 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 367'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 370 -> GE Area 4A AND (GE Area 3U OR GE Area 4U) */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 370'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A and 3U or 4U'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 3U'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 370'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A and 3U or 4U'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3U'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 4U'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 370'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A and 3U or 4U'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4U'
  );

/* RLST 371 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 371'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 372 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 372'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 373 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 373'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 374 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 374'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 375 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 375'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* RLST 381 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'RLST 381'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );
  
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'SOCI 101',
    'Introduction to Sociology',
    'Basic concepts of sociology: social interaction, culture, personality, social processes, population, social class, the community, social institutions and socio-cultural change.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 133',
    'Introduction to Aging Studies',
    'Multidisciplinary overview of: characteristics, strengths and problems of older persons; diversity in aging process involving gender, race, ethnicity, subculture; services to older adults; gerontology as an academic discipline and a field of practice. (AGNG 133, SOCI 133, PUBH 133, HUSR 133 and PSYC 133 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 201',
    'Social Media and Social Interaction',
    'Self, identities, culture, communities, inequalities and social interaction as experienced through social media and technology. Use sociological perspectives to evaluate the benefits and hazards of social media for self and society.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 303',
    'Statistics for the Social Sciences',
    'Techniques for the elementary statistical analysis of social data. Description and inferential measures include tests, chi-square, analysis of variance, contingency table analysis and linear regression.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 304',
    'Black Families in America',
    'Issues of race, class, gender, sexuality and identity within African American families. Topics will include: black single mothers and welfare, prisons, black middle class families and residential housing, black youth and activism, and LGBT family formations. (AFAM 304 and SOCI 304 are the same course.)',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 306',
    'Applying Sociology in the Community',
    'Combines community service with an analysis of select community issues. At least 40 hours of community service required, applying theories and methods to field site. Findings and analysis discussed in weekly meetings.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 351',
    'Sociology of Families',
    'The family as a social institution. Historical and cross-cultural perspectives; social change affecting marriage and the family; analysis of American courtship and marriage patterns; the psycho-dynamics of family life.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 352',
    'The Sociology of Education',
    'Education as a social institution and agent of socialization. Dynamic interplay with economic, political, religious, family institutions, and community. Gender, race, and class inequality in education. Cross-national perspectives on education and related social problems and social policy.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 353',
    'Sociology of Children and Youth',
    'Historical, cross-national, and contemporary views of children, adolescents and youth in society; childhood socialization and the effects of the family, school, peers, gender roles, the media community, and technology; social problems of children and youth; recommendations for social policy.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 354',
    'Gender, Sex and Society',
    'Gender as a social and institutional construct, including analyses of identity, sexuality, media, family, work, economy, the state, and global relations.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 355',
    'Women in Contemporary Societies',
    'Micro and macro analyses of women’s roles and experiences in contemporary societies. Topics may include gender socialization, institutional inequalities, women’s work, violence against women, resistant to inequality, women’s health and sexuality.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 356',
    'Social Inequality',
    'Development, patterns, structures and consequences of social inequality, with emphasis on social class, race, ethnicity, gender, and sexuality in the U.S. Dynamics of resistance and social change are also discussed.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 357',
    'Race and Ethnic Relations',
    'Development and current conditions of minority/majority relations through study of social, political and economic causes and consequences of prejudice and discrimination. Evolutionary and revolutionary movements for change will be studied.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 361',
    'Population and the Environment',
    'Population composition, growth and movement. Social factors affecting birth rates, death rates and migration. Environmental and resource base implications of population growth, urbanization and migration. Role of the economy, poverty, gender and development on population dynamics.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 365',
    'Law and Society',
    'Relationship between a society and its laws using sociological theory and major concepts. Analyze court process, legal professions, and related social institutions.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 371',
    'Sociology of City Life',
    'Ecology, patterns of growth, institutional inequalities, social problems, cultures, and organized resistances of urban communities in global contexts.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SOCI 385',
    'Family Violence',
    'Contemporary issues of family violence: victims, perpetrators and societal responses. Explores causes, intervention and prevention of all types of abuse - child, sibling, spouse, parent and elder - through the examination of theories, research findings and practical field application.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* SOCI 303 prerequisite: GE Areas 2A and 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Areas 2A and 4A'
FROM courses c
WHERE c.course_code = 'SOCI 303'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Areas 2A and 4A'
  );

/* SOCI 304 prerequisite: SOCI 101 or GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'SOCI 101 or GE Area 4A'
FROM courses c
WHERE c.course_code = 'SOCI 304'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'SOCI 101 or GE Area 4A'
  );

/* SOCI 306 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'SOCI 306'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* SOCI 351 prerequisite: SOCI 101 or GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'SOCI 101 or GE Area 4A'
FROM courses c
WHERE c.course_code = 'SOCI 351'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'SOCI 101 or GE Area 4A'
  );

/* SOCI 352 prerequisites: GE Area 4A; SOCI 101 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A; SOCI 101'
FROM courses c
WHERE c.course_code = 'SOCI 352'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A; SOCI 101'
  );

/* SOCI 353 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'SOCI 353'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* SOCI 354 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'SOCI 354'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* SOCI 355 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'SOCI 355'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* SOCI 356 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'SOCI 356'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* SOCI 357 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'SOCI 357'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* SOCI 361 prerequisite: SOCI 101 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'SOCI 101'
FROM courses c
WHERE c.course_code = 'SOCI 361'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'SOCI 101'
  );

/* SOCI 365 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'SOCI 365'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* SOCI 371 prerequisite: GE Area 4A */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 4A'
FROM courses c
WHERE c.course_code = 'SOCI 371'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 4A'
  );

/* SOCI 385 prerequisite: SOCI 101 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'SOCI 101'
FROM courses c
WHERE c.course_code = 'SOCI 385'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'SOCI 101'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   Same group_number = OR
   ========================================================= */

/* SOCI 303 -> GE Area 2A AND GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 2A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SOCI 303'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 2A and 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 2A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SOCI 303'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Areas 2A and 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* SOCI 304 -> SOCI 101 OR GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'SOCI 101'
WHERE c.course_code = 'SOCI 304'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'SOCI 101 or GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SOCI 304'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'SOCI 101 or GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* SOCI 306 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SOCI 306'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* SOCI 351 -> SOCI 101 OR GE Area 4A */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'SOCI 101'
WHERE c.course_code = 'SOCI 351'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'SOCI 101 or GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SOCI 351'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'SOCI 101 or GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* SOCI 352 -> GE Area 4A AND SOCI 101 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SOCI 352'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A; SOCI 101'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'SOCI 101'
WHERE c.course_code = 'SOCI 352'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A; SOCI 101'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* SOCI 353 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SOCI 353'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* SOCI 354 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SOCI 354'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* SOCI 355 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SOCI 355'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* SOCI 356 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SOCI 356'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* SOCI 357 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SOCI 357'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* SOCI 361 -> SOCI 101 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'SOCI 101'
WHERE c.course_code = 'SOCI 361'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'SOCI 101'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* SOCI 365 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SOCI 365'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* SOCI 371 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 4A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SOCI 371'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 4A'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 4A'
  );

/* SOCI 385 -> SOCI 101 */
INSERT INTO course_requirement_items (
    course_requirement_id, group_number, item_type, required_course_id, exam_name, item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'SOCI 101'
WHERE c.course_code = 'SOCI 385'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'SOCI 101'
  AND NOT EXISTS (
      SELECT 1 FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );
  
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'SPAN 315',
    'Introduction to Spanish Civilization',
    'Readings and discussions on Spanish literature, arts, and institutions. Strengthens facility in the language. Conducted in Spanish.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SPAN 316',
    'Introduction to Spanish-American Civilization',
    'Readings and discussion in Spanish-American literature, arts and institutions. Strengthening of facility in the language. Conducted in Spanish.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SPAN 325',
    'Contemporary Culture of Spain',
    'Develop an understanding of the culture of Spain from the beginning of the 20th century to the present day. Ideologies, institutions, literature and arts. Conducted in Spanish.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SPAN 326',
    'Spanish-American Modern Culture',
    'Develop an understanding of Spanish-American culture from the 19th century to the present day. Ideologies, institutions, literature and arts. Conducted in Spanish.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'SPAN 375',
    'Introduction to Literary Forms',
    'Introduction to literary forms and concepts of literary techniques and criticism. Analysis and interpretation of various texts. Strengthens abilities in reading, language and literary criticism. Conducted in Spanish.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* SPAN 315 prerequisite: GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'SPAN 315'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

/* SPAN 315 pre- or corequisite: SPAN 301
   Stored as corequisite in this schema, preserving the wording in note.
*/
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'Pre- or corequisite: SPAN 301'
FROM courses c
WHERE c.course_code = 'SPAN 315'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'corequisite'
        AND cr.note = 'Pre- or corequisite: SPAN 301'
  );

/* SPAN 316 prerequisite: GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'SPAN 316'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

/* SPAN 316 pre- or corequisite: SPAN 301
   Stored as corequisite in this schema, preserving the wording in note.
*/
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'corequisite', 'Pre- or corequisite: SPAN 301'
FROM courses c
WHERE c.course_code = 'SPAN 316'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'corequisite'
        AND cr.note = 'Pre- or corequisite: SPAN 301'
  );

/* SPAN 325 prerequisite: SPAN 301; Spanish language competency; GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'SPAN 301; Spanish language competency; GE Area 3B'
FROM courses c
WHERE c.course_code = 'SPAN 325'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'SPAN 301; Spanish language competency; GE Area 3B'
  );

/* SPAN 326 prerequisite: SPAN 301; Spanish language competency; GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'SPAN 301; Spanish language competency; GE Area 3B'
FROM courses c
WHERE c.course_code = 'SPAN 326'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'SPAN 301; Spanish language competency; GE Area 3B'
  );

/* SPAN 375 prerequisite: GE Area 3B; SPAN 301 */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B; SPAN 301'
FROM courses c
WHERE c.course_code = 'SPAN 375'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B; SPAN 301'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   Same group_number = OR
   ========================================================= */

/* SPAN 315 -> prerequisite -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SPAN 315'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* SPAN 315 -> corequisite -> SPAN 301 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'SPAN 301'
WHERE c.course_code = 'SPAN 315'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'Pre- or corequisite: SPAN 301'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* SPAN 316 -> prerequisite -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SPAN 316'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* SPAN 316 -> corequisite -> SPAN 301 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'SPAN 301'
WHERE c.course_code = 'SPAN 316'
  AND cr.requirement_type = 'corequisite'
  AND cr.note = 'Pre- or corequisite: SPAN 301'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

/* SPAN 325 -> SPAN 301 AND Spanish language competency AND GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'SPAN 301'
WHERE c.course_code = 'SPAN 325'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'SPAN 301; Spanish language competency; GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'Spanish language competency'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SPAN 325'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'SPAN 301; Spanish language competency; GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'Spanish language competency'
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 3, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SPAN 325'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'SPAN 301; Spanish language competency; GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 3
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* SPAN 326 -> SPAN 301 AND Spanish language competency AND GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'SPAN 301'
WHERE c.course_code = 'SPAN 326'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'SPAN 301; Spanish language competency; GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, 'Spanish language competency'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SPAN 326'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'SPAN 301; Spanish language competency; GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = 'Spanish language competency'
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 3, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SPAN 326'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'SPAN 301; Spanish language competency; GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 3
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* SPAN 375 -> GE Area 3B AND SPAN 301 */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'SPAN 375'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B; SPAN 301'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'course', req.id, NULL, NULL
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'SPAN 301'
WHERE c.course_code = 'SPAN 375'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B; SPAN 301'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'course'
        AND cri.required_course_id = req.id
  );
  
/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'SPED 322',
    'Introduction to Positive Behavior Support',
    'Basic theory and technology of applied behavior analysis as it applies to individual, class-wide, and school-wide Positive Behavior Support. Assessing and evaluating school environments in terms of how events and conditions support behavior. Requires 10 hours field observation. Flexible options for observation hours may be discussed with the Instructor.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;

/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'THTR 100',
    'Introduction to the Theatre',
    'For the general student leading to an appreciation and understanding of the theatre as an entertainment medium and as an art form. Recommended for non-majors.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'THTR 110',
    'Oral Communication of Literature',
    'Analysis and performance of literary works through the medium of oral interpretation. Emphasis upon understanding the content of communication in literature as well as form. Exploration of techniques involved in discovery, evaluation and performance of literary speakers.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'THTR 160',
    'Introduction to Acting',
    'For non-acting students, both majors and non-majors. The history, techniques, terminology, interpretation and communication skills involved in the art of acting explored through lecture, discussion, exercises and written reflection.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'THTR 300',
    'Theatre and Cultural Diversity',
    'Contributions of diverse cultures to the fabric of American theatre. Focus on Hispanic, Asian and African-American influences as well as alternative theatre viewpoints from gender, political and experimental perspectives.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'THTR 311',
    'Oral Interpretation of Children’s Literature',
    'Oral presentation of children’s literature in classroom, recreation and home situations including individual and group performance of fiction, non-fiction, fantasy and poetry.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'THTR 315',
    'Chicano/Latino Theatre',
    'Contemporary Chicano/Latino theatre in relation to its historical evolution. Plays, playwrights and theatre groups expressing the Chicano/Latino experience. Extensive play reading.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'THTR 320',
    'Theatre and Issues in Society',
    'Study and analysis of dramatic literature and performance examining current social issues.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'THTR 331',
    'Shakespeare on Film',
    'Analyze Shakespeare plays and film versions using literary and film terminology. Students write critical responses and develop adaptation storyboards and production concepts.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'THTR 357',
    'Blacks in the Performing Arts',
    'African-American culture through the performing arts and the role of Blacks in the entertainment industry as a means of understanding African-American cultural expression.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'THTR 383',
    'Drama into Film',
    'Critical examination of films adapted from plays and evaluation of techniques used in presenting dramatic literature in theatre and film performance.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
course_code = course_code;



/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* THTR 100 restriction */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT id, 'restriction', 'Not a Theatre or Theatre Arts major'
FROM courses
WHERE course_code = 'THTR 100'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements
    WHERE course_id = courses.id
    AND requirement_type = 'restriction'
    AND note = 'Not a Theatre or Theatre Arts major'
);


/* THTR 300 prerequisite */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT id, 'prerequisite', 'GE Area 3A'
FROM courses
WHERE course_code = 'THTR 300'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements
    WHERE course_id = courses.id
    AND requirement_type = 'prerequisite'
    AND note = 'GE Area 3A'
);


/* THTR 315 prerequisite */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT id, 'prerequisite', 'GE Area 3A or GE Area 3B'
FROM courses
WHERE course_code = 'THTR 315'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements
    WHERE course_id = courses.id
    AND requirement_type = 'prerequisite'
    AND note = 'GE Area 3A or GE Area 3B'
);


/* THTR 320 prerequisite */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT id, 'prerequisite', 'GE Area 3A'
FROM courses
WHERE course_code = 'THTR 320'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements
    WHERE course_id = courses.id
    AND requirement_type = 'prerequisite'
    AND note = 'GE Area 3A'
);


/* THTR 331 prerequisite */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT id, 'prerequisite', 'ENGL 101'
FROM courses
WHERE course_code = 'THTR 331'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements
    WHERE course_id = courses.id
    AND requirement_type = 'prerequisite'
    AND note = 'ENGL 101'
);


/* THTR 357 prerequisite */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT id, 'prerequisite', 'GE Area 3A'
FROM courses
WHERE course_code = 'THTR 357'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements
    WHERE course_id = courses.id
    AND requirement_type = 'prerequisite'
    AND note = 'GE Area 3A'
);


/* THTR 383 prerequisite */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT id, 'prerequisite', 'GE Area 3A'
FROM courses
WHERE course_code = 'THTR 383'
AND NOT EXISTS (
    SELECT 1 FROM course_requirements
    WHERE course_id = courses.id
    AND requirement_type = 'prerequisite'
    AND note = 'GE Area 3A'
);



/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   ========================================================= */


/* THTR 100 restriction */
INSERT INTO course_requirement_items
(course_requirement_id, group_number, item_type, item_text)
SELECT cr.id, 1, 'text', 'Not a Theatre or Theatre Arts major'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'THTR 100'
AND cr.requirement_type = 'restriction';



/* THTR 300 */
INSERT INTO course_requirement_items
(course_requirement_id, group_number, item_type, item_text)
SELECT cr.id, 1, 'text', 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'THTR 300';



/* THTR 315 OR condition */
INSERT INTO course_requirement_items
(course_requirement_id, group_number, item_type, item_text)
SELECT cr.id, 1, 'text', 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'THTR 315';

INSERT INTO course_requirement_items
(course_requirement_id, group_number, item_type, item_text)
SELECT cr.id, 1, 'text', 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'THTR 315';



/* THTR 320 */
INSERT INTO course_requirement_items
(course_requirement_id, group_number, item_type, item_text)
SELECT cr.id, 1, 'text', 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'THTR 320';



/* THTR 331 */
INSERT INTO course_requirement_items
(course_requirement_id, group_number, item_type, required_course_id)
SELECT cr.id, 1, 'course', req.id
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
JOIN courses req ON req.course_code = 'ENGL 101'
WHERE c.course_code = 'THTR 331';



/* THTR 357 */
INSERT INTO course_requirement_items
(course_requirement_id, group_number, item_type, item_text)
SELECT cr.id, 1, 'text', 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'THTR 357';



/* THTR 383 */
INSERT INTO course_requirement_items
(course_requirement_id, group_number, item_type, item_text)
SELECT cr.id, 1, 'text', 'GE Area 3A'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'THTR 383';

/* =========================================================
   1) COURSES
   ========================================================= */

INSERT INTO courses (
    course_code,
    course_name,
    course_description,
    units_min,
    units_max,
    has_lab,
    includes_lab
)
VALUES
(
    'VIET 385',
    'Advanced Vietnamese Cultural Communication',
    'Exploration of topics and themes to broaden and deepen Vietnamese cultural awareness from a humanistic perspective, and development of critical, analytical and creative oral and writing competencies. Conducted in Vietnamese.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'VIET 390',
    'Vietnamese Culture through Cinema and Literature',
    'The development of modern Vietnamese culture and society, as well as multicultural analysis of global issues, through various media including subtitled films and literature (in translation). Conducted in English.',
    3.0,
    3.0,
    FALSE,
    FALSE
),
(
    'VIET 395',
    'Vietnamese Literature and Arts',
    'Interdisciplinary exploration of Vietnamese literature and arts through a wide variety of representations. Contextualized analysis of movements and genres within historical processes. Conducted in English.',
    3.0,
    3.0,
    FALSE,
    FALSE
)
ON DUPLICATE KEY UPDATE
    course_code = course_code;


/* =========================================================
   2) COURSE REQUIREMENTS
   ========================================================= */

/* VIET 385 prerequisites: GE Area 3B, 300-level VIET course */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B; 300-level VIET course'
FROM courses c
WHERE c.course_code = 'VIET 385'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B; 300-level VIET course'
  );

/* VIET 390 prerequisite: GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'VIET 390'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );

/* VIET 395 prerequisite: GE Area 3B */
INSERT INTO course_requirements (course_id, requirement_type, note)
SELECT c.id, 'prerequisite', 'GE Area 3B'
FROM courses c
WHERE c.course_code = 'VIET 395'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirements cr
      WHERE cr.course_id = c.id
        AND cr.requirement_type = 'prerequisite'
        AND cr.note = 'GE Area 3B'
  );


/* =========================================================
   3) COURSE REQUIREMENT ITEMS
   Different group_number = AND
   Same group_number = OR
   ========================================================= */

/* VIET 385 -> GE Area 3B AND 300-level VIET course */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'VIET 385'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B; 300-level VIET course'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 2, 'text', NULL, NULL, '300-level VIET course'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'VIET 385'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B; 300-level VIET course'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 2
        AND cri.item_type = 'text'
        AND cri.item_text = '300-level VIET course'
  );

/* VIET 390 -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'VIET 390'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );

/* VIET 395 -> GE Area 3B */
INSERT INTO course_requirement_items (
    course_requirement_id,
    group_number,
    item_type,
    required_course_id,
    exam_name,
    item_text
)
SELECT cr.id, 1, 'text', NULL, NULL, 'GE Area 3B'
FROM course_requirements cr
JOIN courses c ON c.id = cr.course_id
WHERE c.course_code = 'VIET 395'
  AND cr.requirement_type = 'prerequisite'
  AND cr.note = 'GE Area 3B'
  AND NOT EXISTS (
      SELECT 1
      FROM course_requirement_items cri
      WHERE cri.course_requirement_id = cr.id
        AND cri.group_number = 1
        AND cri.item_type = 'text'
        AND cri.item_text = 'GE Area 3B'
  );