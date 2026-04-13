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
  ('Grace',   'Kellies',  'grace@uni.edu'),
  ('Jamarri', 'Mezier',   'jamarri@uni.edu'),
  ('Xavier',  'Green',    'xavier@uni.edu');

-- ── ENROLLMENTS ─────────────────────────────────
-- CSCI 375 (course_id=1): all 7 students
INSERT OR IGNORE INTO Enrollment(student_id, course_id) VALUES
  (1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1);

-- CSCI 432 (course_id=2): students 1-5
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

-- CSCI 432: 25% HW, 50% Tests, 25% Projects
INSERT OR IGNORE INTO GradeCategory(course_id, category_name, weight) VALUES
  (2,'Homework',25),
  (2,'Tests',50),
  (2,'Projects',25);

-- MATH 181: 60% HW, 40% Tests
INSERT OR IGNORE INTO GradeCategory(course_id, category_name, weight) VALUES
  (3,'Homework',60),
  (3,'Tests',40);

-- ── ASSIGNMENTS ─────────────────────────────────
-- CSCI 375 categories: Participation=1, HW=2, Tests=3, Projects=4
INSERT OR IGNORE INTO Assignment(category_id, assignment_name, max_score) VALUES
  (1,'Week 1-15 Participation',100),
  (2,'HW1',100),(2,'HW2',100),(2,'HW3',100),(2,'HW4',100),(2,'HW5',100),
  (3,'Quiz 1',100),(3,'Quiz 2',100),
  (4,'Projects 1-6',100);
 
-- CSCI 432 categories: Participation=5 HW=6, Tests=7, Projects=8
INSERT OR IGNORE INTO Assignment(category_id, assignment_name, max_score) VALUES
  (5,'HW1',100),(6,'HW2',100),(6,'HW3',100),
  (6,'Midterm',100),(7,'Final',100),
  (7,'Semester Project',100);
 
-- MATH 181 categories: HW=9, Tests=10, Project=11
INSERT OR IGNORE INTO Assignment(category_id, assignment_name, max_score) VALUES
  (8,'HW1',100),(9,'HW2',100),(9,'HW3',100),
  (9,'Midterm',100),(10,'Final',100);

-- ── SCORES ──────────────────────────────────────
-- CSCI 375 assignments: participation=1, hw1-5=2-6, midterm=7, quiz1=8, quiz2=9, proj1-6=10
 
-- Alie(1)
INSERT OR IGNORE INTO Score(student_id, assignment_id, points_earned) VALUES
  (1,1,95),(1,2,88),(1,3,92),(1,4,85),(1,5,90),(1,6,87),
  (1,7,78),(1,8,82),(1,9,91),(1,10,88);
-- Billy(2)
INSERT OR IGNORE INTO Score(student_id, assignment_id, points_earned) VALUES
  (2,1,70),(2,2,65),(2,3,72),(2,4,68),(2,5,74),(2,6,71),
  (2,7,60),(2,8,65),(2,9,70),(2,10,68);
-- Chris(3)
INSERT OR IGNORE INTO Score(student_id, assignment_id, points_earned) VALUES
  (3,1,85),(3,2,90),(3,3,88),(3,4,92),(3,5,87),(3,6,91),
  (3,7,88),(3,8,91),(3,9,85),(3,10,89);
-- Divine(4)
INSERT OR IGNORE INTO Score(student_id, assignment_id, points_earned) VALUES
  (4,1,60),(4,2,55),(4,3,62),(4,4,58),(4,5,65),(4,6,60),
  (4,7,55),(4,8,58),(4,9,62),(4,10,60);
-- Grace(5)
INSERT OR IGNORE INTO Score(student_id, assignment_id, points_earned) VALUES
  (5,1,75),(5,2,74),(5,3,61),(5,4,99),(5,5,96),(5,6,98),
  (5,7,94),(5,8,97),(5,9,99),(5,10,96);
-- Jamarri(6)
INSERT OR IGNORE INTO Score(student_id, assignment_id, points_earned) VALUES
  (6,1,100),(6,2,80),(6,3,78),(6,4,82),(6,5,79),(6,6,91),
  (6,7,94),(6,8,86),(6,9,80),(6,10,99);
-- Xavier(7)
INSERT OR IGNORE INTO Score(student_id, assignment_id, points_earned) VALUES
  (7,1,88),(7,2,84),(7,3,86),(7,4,89),(7,5,98),(7,6,94),
  (7,7,82),(7,8,85),(7,9,88),(7,10,100);
 
-- CSCI 432 assignments: hw1-3=11-13, midterm=14, final=15, proj1=16
INSERT OR IGNORE INTO Score(student_id, assignment_id, points_earned) VALUES
  (1,11,90),(1,12,88),(1,13,92),(1,14,85),(1,15,89),(1,16,91),
  (2,11,68),(2,12,72),(2,13,70),(2,14,65),(2,15,67),(2,16,70),
  (3,11,95),(3,12,93),(3,13,94),(3,14,91),(3,15,93),(3,16,96),
  (4,11,60),(4,12,63),(4,13,61),(4,14,58),(4,15,60),(4,16,62),
  (5,11,97),(5,12,98),(5,13,96),(5,14,95),(5,15,97),(5,16,99);
 
-- MATH 181 assignments: hw1-3=17-19, midterm=20, final=21
INSERT OR IGNORE INTO Score(student_id, assignment_id, points_earned) VALUES
  (3,17,88),(3,18,90),(3,19,87),(3,20,85),(3,21,89),
  (4,17,70),(4,18,68),(4,19,72),(4,20,65),(4,21,67),
  (5,17,95),(5,18,97),(5,19,94),(5,20,92),(5,21,96),
  (6,17,78),(6,18,80),(6,19,76),(6,20,74),(6,21,77),
  (7,17,82),(7,18,85),(7,19,80),(7,20,79),(7,21,83);
 
