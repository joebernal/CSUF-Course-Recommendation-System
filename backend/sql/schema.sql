CREATE DATABASE IF NOT EXISTS tuffyplan DEFAULT CHARSET = utf8mb4;
USE tuffyplan;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS completed_courses;
DROP TABLE IF EXISTS plan_courses;
DROP TABLE IF EXISTS course_plans;

DROP TABLE IF EXISTS course_requirement_items;
DROP TABLE IF EXISTS course_requirements;

DROP TABLE IF EXISTS major_ge_courses;
DROP TABLE IF EXISTS major_ge_requirements;
DROP TABLE IF EXISTS ge_areas;

DROP TABLE IF EXISTS major_requirement_courses;
DROP TABLE IF EXISTS major_rules;
DROP TABLE IF EXISTS major_requirements;

DROP TABLE IF EXISTS course_pairs;
DROP TABLE IF EXISTS courses;

DROP TABLE IF EXISTS user_exams;
DROP TABLE IF EXISTS user_preferences;
DROP TABLE IF EXISTS users;

DROP TABLE IF EXISTS majors;
DROP TABLE IF EXISTS catalog_years;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================
-- 1) Users + Preferences
-- =========================

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NULL,
    google_uid VARCHAR(255) NULL UNIQUE,
    full_name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    enrollment_status VARCHAR(20) DEFAULT 'fulltime',
    available_winter BOOLEAN DEFAULT FALSE,
    available_summer BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- One row per user, easy to add more columns later
CREATE TABLE user_preferences (
    user_id INT PRIMARY KEY,
    preferred_language VARCHAR(20) NULL,  -- e.g., Python, Java, C++, C#, Swift
    career_interest VARCHAR(30) NULL,     -- e.g., Web, AI, Security, Data, Systems, GameDev
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_preferences_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Users can mark passing exams like "CS Placement Exam"
CREATE TABLE user_exams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    exam_name VARCHAR(100) NOT NULL,  -- e.g., "CS Placement Exam"
    passed BOOLEAN NOT NULL DEFAULT FALSE,
    date_taken DATE NULL,
    UNIQUE (user_id, exam_name),
    CONSTRAINT fk_user_exams_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =========================
-- 2) Catalog Years + Majors
-- =========================

CREATE TABLE catalog_years (
    id INT AUTO_INCREMENT PRIMARY KEY,
    catalog_name VARCHAR(50) NOT NULL UNIQUE,   -- e.g., "Fall 2025 & Beyond"
    start_term VARCHAR(10) NOT NULL,            -- "Fall", "Spring", "Summer", "Winter"
    start_year INT NOT NULL,
    end_term VARCHAR(10) NULL,                  -- NULL = open-ended
    end_year INT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE majors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    major_name VARCHAR(100) NOT NULL UNIQUE,
    major_acronym VARCHAR(10) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =========================
-- 3) Courses + Pairing
-- =========================

CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(15) NOT NULL UNIQUE,     -- e.g., "CPSC 120"
    course_name VARCHAR(255) NULL,
    course_description TEXT NULL,                -- store full catalog description here
    units_min DECIMAL(3,1) NOT NULL DEFAULT 0,   -- supports 1–3 style courses
    units_max DECIMAL(3,1) NOT NULL DEFAULT 0,
    has_lab BOOLEAN NOT NULL DEFAULT FALSE,      -- standalone lab course (e.g., PHYS 225L)
    includes_lab BOOLEAN NOT NULL DEFAULT FALSE  -- lecture that includes lab time (e.g., CPSC 120)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Link lecture/lab pairs so your planner can treat them as paired automatically
CREATE TABLE course_pairs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,          -- e.g., "CPSC 120A" (or "CPSC 120" in older catalogs)
    paired_course_id INT NOT NULL,   -- e.g., "CPSC 120L"
    pair_type VARCHAR(20) NOT NULL,  -- e.g., "lecture_lab"
    UNIQUE (course_id, paired_course_id, pair_type),
    CONSTRAINT fk_course_pairs_course
        FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT fk_course_pairs_paired_course
        FOREIGN KEY (paired_course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =========================
-- 4) Major Requirements
-- =========================

-- Each major has requirements that can change by catalog year
CREATE TABLE major_requirements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    major_id INT NOT NULL,
    catalog_year_id INT NOT NULL,
    requirement_name VARCHAR(120) NOT NULL,      -- e.g., "Lower-Division Core", "Math Requirements"
    requirement_type VARCHAR(30) NOT NULL,       -- e.g., "core", "math", "science_elective", "cs_elective", "graduation"
    required_units_min DECIMAL(4,1) NULL,
    required_units_max DECIMAL(4,1) NULL,
    note TEXT NULL,
    UNIQUE (major_id, catalog_year_id, requirement_name),
    CONSTRAINT fk_major_requirements_major
        FOREIGN KEY (major_id) REFERENCES majors(id) ON DELETE CASCADE,
    CONSTRAINT fk_major_requirements_catalog
        FOREIGN KEY (catalog_year_id) REFERENCES catalog_years(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Courses that satisfy a requirement (can handle "choose one" and elective buckets)
CREATE TABLE major_requirement_courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    major_requirement_id INT NOT NULL,
    course_id INT NOT NULL,
    choice_group INT NOT NULL DEFAULT 0,
    -- choice_group meaning:
    -- 0 = required (no choice)
    -- 1,2,3... = "choose one from this group"
    note TEXT NULL,
    UNIQUE (major_requirement_id, course_id),
    CONSTRAINT fk_mrc_requirement
        FOREIGN KEY (major_requirement_id) REFERENCES major_requirements(id) ON DELETE CASCADE,
    CONSTRAINT fk_mrc_course
        FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Rules you want your planner to ENFORCE
CREATE TABLE major_rules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    major_id INT NOT NULL,
    catalog_year_id INT NOT NULL,
    rule_name VARCHAR(120) NOT NULL,       -- e.g., "Max lower-division elective units"
    rule_value_int INT NULL,               -- e.g., 3
    rule_value_text VARCHAR(255) NULL,     -- extra info if needed
    is_enforced BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (major_id, catalog_year_id, rule_name),
    CONSTRAINT fk_major_rules_major
        FOREIGN KEY (major_id) REFERENCES majors(id) ON DELETE CASCADE,
    CONSTRAINT fk_major_rules_catalog
        FOREIGN KEY (catalog_year_id) REFERENCES catalog_years(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =========================
-- 5) GE Areas (Major-approved list) + Z overlay
-- =========================

CREATE TABLE ge_areas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    area_code VARCHAR(10) NOT NULL,         -- e.g., "2A", "2U", "4U", "E"
    area_name VARCHAR(150) NOT NULL,
    UNIQUE (area_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- GE requirements (units) differ by catalog year and by major (you chose CS-approved list)
CREATE TABLE major_ge_requirements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    major_id INT NOT NULL,
    catalog_year_id INT NOT NULL,
    ge_area_id INT NOT NULL,
    required_units_min DECIMAL(4,1) NULL,
    required_units_max DECIMAL(4,1) NULL,
    note TEXT NULL,
    UNIQUE (major_id, catalog_year_id, ge_area_id),
    CONSTRAINT fk_mgr_major
        FOREIGN KEY (major_id) REFERENCES majors(id) ON DELETE CASCADE,
    CONSTRAINT fk_mgr_catalog
        FOREIGN KEY (catalog_year_id) REFERENCES catalog_years(id) ON DELETE CASCADE,
    CONSTRAINT fk_mgr_ge_area
        FOREIGN KEY (ge_area_id) REFERENCES ge_areas(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Which courses count for that GE area for that major+catalog year
CREATE TABLE major_ge_courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    major_ge_requirement_id INT NOT NULL,
    course_id INT NOT NULL,
    counts_for_z BOOLEAN NOT NULL DEFAULT FALSE,
    note TEXT NULL, -- store things like "Overlay Z if taken Spring 2021 or later" as text for now
    UNIQUE (major_ge_requirement_id, course_id),
    CONSTRAINT fk_major_ge_courses_req
        FOREIGN KEY (major_ge_requirement_id) REFERENCES major_ge_requirements(id) ON DELETE CASCADE,
    CONSTRAINT fk_major_ge_courses_course
        FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =========================
-- 6) Prerequisites / Corequisites (AND/OR supported)
-- =========================

CREATE TABLE course_requirements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,                 -- the course that has this requirement
    requirement_type VARCHAR(20) NOT NULL,  -- "prerequisite", "corequisite", "restriction"
    note TEXT NULL,                         -- store the full text ("CS major/minor or graduate standing")
    CONSTRAINT fk_course_requirements_course
        FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE course_requirement_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_requirement_id INT NOT NULL,
    group_number INT NOT NULL DEFAULT 1,
    -- AND/OR logic:
    -- Different group_number = AND between groups
    -- Same group_number = OR inside the group

    item_type VARCHAR(20) NOT NULL,   -- "course", "exam", "text"
    required_course_id INT NULL,      -- used when item_type = "course"
    exam_name VARCHAR(100) NULL,      -- used when item_type = "exam" (e.g., CS Placement Exam)
    item_text VARCHAR(255) NULL,      -- used when item_type = "text" (e.g., "CS major/minor")

    CONSTRAINT fk_cri_requirement
        FOREIGN KEY (course_requirement_id) REFERENCES course_requirements(id) ON DELETE CASCADE,
    CONSTRAINT fk_cri_course
        FOREIGN KEY (required_course_id) REFERENCES courses(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =========================
-- 7) Plans + Completed Courses
-- =========================

CREATE TABLE course_plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    major_id INT NOT NULL,
    catalog_year_id INT NOT NULL,
    plan_name VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_course_plans_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_course_plans_major
        FOREIGN KEY (major_id) REFERENCES majors(id) ON DELETE RESTRICT,
    CONSTRAINT fk_course_plans_catalog
        FOREIGN KEY (catalog_year_id) REFERENCES catalog_years(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE plan_courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plan_id INT NOT NULL,
    course_id INT NOT NULL,
    term VARCHAR(10) NOT NULL, -- Fall, Winter, Spring, Summer
    year INT NOT NULL CHECK (year BETWEEN 2001 AND 2100),

    -- Optional: track what the planner intended this course to satisfy
    applied_to VARCHAR(50) NULL,  -- e.g., "GE 2A", "CS Core", "Science Elective", etc.
    note TEXT NULL,

    UNIQUE (plan_id, course_id, term, year),
    CONSTRAINT fk_plan_courses_plan
        FOREIGN KEY (plan_id) REFERENCES course_plans(id) ON DELETE CASCADE,
    CONSTRAINT fk_plan_courses_course
        FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE completed_courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    term VARCHAR(10) NOT NULL, -- Fall, Winter, Spring, Summer
    year INT NOT NULL CHECK (year BETWEEN 2001 AND 2100),
    grade VARCHAR(3) NULL, -- optional if you later enforce minimum grades
    UNIQUE (user_id, course_id),
    CONSTRAINT fk_completed_courses_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_completed_courses_course
        FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;