PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS major_requirements;

CREATE TABLE major_requirements (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  major_id INTEGER NOT NULL,
  catalog_year_id INTEGER NOT NULL,
  requirement_name TEXT NOT NULL,
  requirement_type TEXT,
  required_units_min REAL,
  required_units_max REAL,
  note TEXT
);
