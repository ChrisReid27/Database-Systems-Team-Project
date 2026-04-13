-- ==========================================
-- TASK 2: GRADEBOOK DATABASE TABLE CREATION
-- ==========================================

PRAGMA foreign_keys = ON;

-- 1. PROFESSOR (Professor who teaches a course or courses.)
CREATE TABLE IF NOT EXISTS Professor (
    professor_id  INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name    TEXT    NOT NULL,
    last_name     TEXT    NOT NULL,
    department    TEXT    NOT NULL
);

-- 2. COURSES (The offered classes.)
CREATE TABLE IF NOT EXISTS Course (
    course_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    department      TEXT    NOT NULL,
    course_number   TEXT    NOT NULL,
    course_name     TEXT    NOT NULL,
    semester        TEXT    NOT NULL CHECK(semester IN ('Spring','Summer','Fall')),
    year            INTEGER NOT NULL,
    professor_id    INTEGER NOT NULL REFERENCES Professor(professor_id),
    UNIQUE(department, course_number, semester, year)
);

-- 3. STUDENTS (The people who enroll, attend, do assignments, and score points in courses.)
CREATE TABLE IF NOT EXISTS Student (
    student_id  INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name  TEXT NOT NULL,
    last_name   TEXT NOT NULL,
    email       TEXT UNIQUE NOT NULL
);

-- 4. ENROLLMENTS (The roster that contains students who will take a course.)
CREATE TABLE IF NOT EXISTS Enrollment (
    enrollment_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id      INTEGER NOT NULL REFERENCES Student(student_id) ON DELETE CASCADE,
    course_id       INTEGER NOT NULL REFERENCES Course(course_id)   ON DELETE CASCADE,
    UNIQUE(student_id, course_id)
);

-- 5. GRADE CATEGORIES  (e.g. Homework 20%, Tests 40%, Participation 10%, etc.)
-- weight is in percentage.
CREATE TABLE IF NOT EXISTS GradeCategory (
    category_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    course_id       INTEGER NOT NULL REFERENCES Course(course_id) ON DELETE CASCADE,
    category_name   TEXT    NOT NULL,
    weight          REAL    NOT NULL CHECK(weight > 0 AND weight <= 100),
    UNIQUE(course_id, category_name)
);

-- 6. ASSIGNMENTS  (Belong to a category.)
CREATE TABLE IF NOT EXISTS Assignment (
    assignment_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id     INTEGER NOT NULL REFERENCES GradeCategory(category_id) ON DELETE CASCADE,
    assignment_name TEXT    NOT NULL,
    max_score       REAL    NOT NULL DEFAULT 100,
    UNIQUE(category_id, assignment_name)
);
 
-- 7. SCORES  (A student's score on an assignment.)
CREATE TABLE IF NOT EXISTS Score (
    score_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id      INTEGER NOT NULL REFERENCES Student(student_id)      ON DELETE CASCADE,
    assignment_id   INTEGER NOT NULL REFERENCES Assignment(assignment_id) ON DELETE CASCADE,
    points_scored   REAL    NOT NULL CHECK(points_earned >= 0),
    UNIQUE(student_id, assignment_id)
);
