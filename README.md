# CSUF Course Recommendation System

## Run With Docker Compose

This project includes a 3-container setup:
- `db`: MySQL 8.4
- `backend`: Flask API on port 5001
- `frontend`: Next.js app on port 3000

### 1. Create Docker env file

Copy the provided template:

```bash
cp .env.docker.example .env
```

Edit `.env` with your Firebase values if needed.

### 2. Build and run

```bash
docker compose up --build
```

### 3. Open the app

- Frontend: http://localhost:3000
- Backend API: http://localhost:5001

## Database Initialization

On first startup (fresh volume), the MySQL container imports:
- `0001_schema.sql`
- `0002_insert_2025_catalog_courses.sql`
- `0003_insert_major_courses.sql`
- `0004_insert_course_requirements.sql`
- `0005_insert_ge_areas.sql`
- `0006_insert_missing_ge_courses.sql`
- `0007_insert_cs_major_ge_requirements_and_courses.sql`

These are mounted explicitly through `docker-compose.yml`.

If you need to re-run initialization from scratch, remove the DB volume:

```bash
docker compose down -v
docker compose up --build
```