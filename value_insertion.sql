-- ==============================
-- TASK TWO: DATA FOR INSERTION
-- ==============================

PRAGMA foreign_keys = ON;

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
  ('Frank',   'Lee',      'frank@uni.edu'),
  ('Grace',   'Kellies',  'grace@uni.edu'),
  ('Jamarri', 'Mezier',   'jamarri@uni.edu'),
  ('Xavier',  'Green',    'xavier@uni.edu);

-- ── ENROLLMENTS ─────────────────────────────────
-- CSCI 375 (course_id=1): all 8 students
INSERT OR IGNORE INTO Enrollment(student_id, course_id) VALUES
  (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1);
-- CSCI 432 (course_id=2): students 1-6
INSERT OR IGNORE INTO Enrollment(student_id, course_id) VALUES
  (1,2),(2,2),(3,2),(4,2),(5,2),(6,2);
-- MATH 181 (course_id=3): students 3-7
INSERT OR IGNORE INTO Enrollment(student_id, course_id) VALUES
  (3,3),(4,3),(5,3),(6,3),(7,3);

-- ── GRADE CATEGORIES ────────────────────────────
-- CSCI 375: 15% participation, 20% HW, 50% Tests, 15% Projects
INSERT OR IGNORE INTO GradeCategory(course_id, category_name, weight) VALUES
  (1,'Participation',15),
  (1,'Homework',20),
  (1,'Tests',50),
  (1,'Projects',15);
-- CSCI 432: 10% participation, 20% HW, 50% Tests, 20% Projects
INSERT OR IGNORE INTO GradeCategory(course_id, category_name, weight) VALUES
  (2,'Participation',10),
  (2,'Homework',20),
  (2,'Tests',50),
  (2,'Projects',20);
-- MATH 181: 40% HW, 30% Tests, Project 30%
INSERT OR IGNORE INTO GradeCategory(course_id, category_name, weight) VALUES
  (3,'Homework',40),
  (3,'Tests',30),
  (3,'Project',30);

