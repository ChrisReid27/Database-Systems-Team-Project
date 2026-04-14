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
    points_scored   REAL    NOT NULL CHECK(points_scored >= 0),
    UNIQUE(student_id, assignment_id)
);

-- ── PROFESSORS ──────────────────────────────────
INSERT OR IGNORE INTO Professor(professor_id, first_name, last_name, department) VALUES
  (1, 'Michelle', 'Jones', 'Computer Science'),
  (2, 'James',    'Smith', 'Mathematics');

-- ── COURSES ─────────────────────────────────────
INSERT OR IGNORE INTO Course(department, course_number, course_name, semester, year, professor_id) VALUES
  ('CSCI',   '375', 'Software Engineering', 'Fall',   2025, 1),
  ('CSCI',   '432', 'Database Systems',     'Spring', 2026, 1),
  ('MATH',   '181', 'Discrete Mathematics', 'Spring', 2026, 2);

-- ── STUDENTS ────────────────────────────────────
INSERT OR IGNORE INTO Student(first_name, last_name, email) VALUES
  ('Alie',    'Anderson', 'alie@uni.edu'),
  ('Billy',   'Quinn',    'billy@uni.edu'),
  ('Chris',   'Reid',     'chris@uni.edu'),
  ('Divine',  'Jones',    'divine@uni.edu'),
  ('Grace',   'Kellies',  'grace@uni.edu'),
  ('Jamarri', 'Mezier',   'jamarri@uni.edu'),
  ('Xavier',  'Green',    'xavier@uni.edu');

-- ── ENROLLMENTS ─────────────────────────────────
INSERT OR IGNORE INTO Enrollment(student_id, course_id) VALUES
  (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),  -- CSCI 375: all 7 students
  (1,2),(2,2),(3,2),(4,2),(5,2),              -- CSCI 432: students 1-5
  (3,3),(4,3),(5,3),(6,3),(7,3);              -- MATH 181: students 3-7


-- ── GRADE CATEGORIES ────────────────────────────
INSERT OR IGNORE INTO GradeCategory(course_id, category_name, weight) VALUES
  (1,'Participation',15), -- CSCI 375: 15% participation, 20% HW, 15% Tests, 50% Projects
  (1,'Homework',20),
  (1,'Tests',15),
  (1,'Projects',50),
  (2,'Homework',25), -- CSCI 432: 25% HW, 50% Tests, 25% Projects
  (2,'Tests',50),
  (2,'Projects',25),
  (3,'Homework',60), -- MATH 181: 60% HW, 40% Tests
  (3,'Tests',40);

-- ── ASSIGNMENTS ─────────────────────────────────
-- CSCI 375 categories: Participation=1, HW=2, Tests=3, Projects=4
INSERT OR IGNORE INTO Assignment(category_id, assignment_name, max_score) VALUES
  (1,'Week 1-15 Participation',100),
  (2,'HW1',100),(2,'HW2',100),(2,'HW3',100),(2,'HW4',100),(2,'HW5',100),
  (3,'Quiz 1',100),(3,'Quiz 2',100),
  (4,'Projects 1-6',100);
 
-- CSCI 432 categories: HW=5, Tests=6, Projects=7
INSERT OR IGNORE INTO Assignment(category_id, assignment_name, max_score) VALUES
  (5,'HW1',100),(5,'HW2',100),(5,'HW3',100),
  (6,'Midterm',100),(6,'Final',100),
  (7,'Semester Project',100);
 
-- MATH 181 categories: HW=8, Tests=9
INSERT OR IGNORE INTO Assignment(category_id, assignment_name, max_score) VALUES
  (8,'HW1',100),(8,'HW2',100),(8,'HW3',100),
  (9,'Midterm',100),(9,'Final',100);

-- ── SCORES ──────────────────────────────────────
-- CSCI 375 assignments: participation=1, hw1-5=2-6, quiz1=7, quiz2=8, proj=9
INSERT OR IGNORE INTO Score(student_id, assignment_id, points_scored) VALUES
  (1,1,95),(1,2,88),(1,3,92),(1,4,85),(1,5,90), -- Alie
  (2,1,70),(2,2,65),(2,3,72),(2,4,68),(2,5,74), -- Billy
  (3,1,85),(3,2,90),(3,3,88),(3,4,92),(3,5,87), -- Chris
  (4,1,60),(4,2,55),(4,3,62),(4,4,58),(4,5,65), -- Divine
  (5,1,75),(5,2,74),(5,3,61),(5,4,99),(5,5,96), -- Grace
  (6,1,100),(6,2,80),(6,3,78),(6,4,82),(6,5,79), -- Jamarri
  (7,1,88),(7,2,84),(7,3,86),(7,4,89),(7,5,98); -- Xavier
 
-- CSCI 432 assignments: hw1-3=10-12, midterm=13, final=14, proj=15
INSERT OR IGNORE INTO Score(student_id, assignment_id, points_scored) VALUES
  (1,10,90),(1,11,88),(1,12,92),(1,13,85),(1,14,89),(1,15,91),
  (2,10,68),(2,11,72),(2,12,70),(2,13,65),(2,14,67),(2,15,70),
  (3,10,95),(3,11,93),(3,12,94),(3,13,91),(3,14,93),(3,15,96),
  (4,10,60),(4,11,63),(4,12,61),(4,13,58),(4,14,60),(4,15,62),
  (5,10,97),(5,11,98),(5,12,96),(5,13,95),(5,14,97),(5,15,99);
 
-- MATH 181 assignments: hw1-3=16-18, midterm=19, final=20
INSERT OR IGNORE INTO Score(student_id, assignment_id, points_scored) VALUES
  (3,16,88),(3,17,90),(3,18,87),(3,19,85),(3,20,89),
  (4,16,70),(4,17,68),(4,18,72),(4,19,65),(4,20,67),
  (5,16,95),(5,17,97),(5,18,94),(5,19,92),(5,20,96),
  (6,16,78),(6,17,80),(6,18,76),(6,19,74),(6,20,77),
  (7,16,82),(7,17,85),(7,18,80),(7,19,79),(7,20,83);
 
SELECT 'Students' AS TableName, * FROM Student;
SELECT 'Courses' AS TableName, * FROM Course;
SELECT 'Enrollments' AS TableName, * FROM Enrollment;
SELECT 'Categories' AS TableName, * FROM GradeCategory;
SELECT 'Assignments' AS TableName, * FROM Assignment;
SELECT 'Scores' AS TableName, * FROM Score;