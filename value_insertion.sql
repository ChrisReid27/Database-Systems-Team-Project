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
-- CSCI 375: 15% participation, 20% HW, 15% Tests, 50% Projects
INSERT OR IGNORE INTO GradeCategory(course_id, category_name, weight) VALUES
  (1,'Participation',15),
  (1,'Homework',20),
  (1,'Tests',15),
  (1,'Projects',50);

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

-- ── ASSIGNMENTS ─────────────────────────────────
-- CS 375 categories: Participation=1, HW=2, Tests=3, Projects=4
INSERT OR IGNORE INTO Assignment(category_id, assignment_name, max_score) VALUES
  (1,'Week 1-15 Participation',100),
  (2,'HW1',100),(2,'HW2',100),
  (3,'Quiz 1',100),(3,'Quiz 2',100),(3,'Quiz 3',100)
  (4,'Projects 1-5',100),(4,'Final Project',100);
 
-- CS 432 categories: Participation=5 HW=6, Tests=7, Projects=8
INSERT OR IGNORE INTO Assignment(category_id, assignment_name, max_score) VALUES
  (5,'Week 1-15 Participation',100),
  (6,'HW1',100),(6,'HW2',100),(6,'HW3',100),
  (7,'Midterm',100),(7,'Final',100),
  (8,'Semester Project',100);
 
-- MATH 181 categories: HW=9, Tests=10, Project=11
INSERT OR IGNORE INTO Assignment(category_id, assignment_name, max_score) VALUES
  (9,'HW1',100),(9,'HW2',100),(9,'HW3',100),
  (10,'Midterm',100),(10,'Final',100),
  (11,'Team Project',100)
