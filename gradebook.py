#!/usr/bin/env python3

'''
Gradebook Application
'''

import sqlite3, os, textwrap
 
DB_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "gradebook.db")

# Table Creation

SCHEMA = """
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
"""

# Value Insertion

SEED_DATA = """
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
"""

# DB Helpers

def get_conn():
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON")
    conn.row_factory = sqlite3.Row
    return conn
 
def init_db():
    conn = get_conn()
    conn.executescript(SCHEMA)
    conn.executescript(SEED_DATA)
    conn.commit()
    conn.close()
 
def print_table(rows, headers=None):
    if not rows:
        print("  (no results)")
        return
    if headers is None:
        headers = list(rows[0].keys())
    data = [[str(v) if v is not None else "NULL" for v in r] for r in rows]
    widths = [max(len(str(h)), max(len(r[i]) for r in data))
              for i, h in enumerate(headers)]
    sep = "+-" + "-+-".join("-" * w for w in widths) + "-+"
    fmt = "| " + " | ".join(f"{{:<{w}}}" for w in widths) + " |"
    print(sep)
    print(fmt.format(*[str(h) for h in headers]))
    print(sep)
    for row in data:
        print(fmt.format(*row))
    print(sep)
 
def pick_course(conn):
    rows = conn.execute("""
        SELECT c.course_id,
               c.department||' '||c.course_number||' – '||c.course_name
               ||' ('||c.semester||' '||c.year||')' AS label,
               p.first_name||' '||p.last_name AS professor
        FROM Course c
        JOIN Professor p USING(professor_id)
        ORDER BY c.course_id
    """).fetchall()
    print_table(rows, ["ID", "Course", "Professor"])
    return int(input("Enter course_id: ").strip())
 
def pick_assignment(conn, course_id=None):
    q = """
        SELECT a.assignment_id,
               c.department||' '||c.course_number AS course,
               gc.category_name,
               a.assignment_name,
               a.max_score
        FROM Assignment a
        JOIN GradeCategory gc USING(category_id)
        JOIN Course c USING(course_id)
    """
    params = ()
    if course_id:
        q += " WHERE gc.course_id = ?"
        params = (course_id,)
    q += " ORDER BY a.assignment_id"
    rows = conn.execute(q, params).fetchall()
    print_table(rows, ["ID", "Course", "Category", "Assignment", "Max"])
    return int(input("Enter assignment_id: ").strip())
 
def pick_student(conn):
    rows = conn.execute(
        "SELECT student_id, first_name||' '||last_name AS name, email "
        "FROM Student ORDER BY last_name"
    ).fetchall()
    print_table(rows, ["ID", "Name", "Email"])
    return int(input("Enter student_id: ").strip())
 
def letter_grade(score):
    if score >= 90: return 'A'
    if score >= 80: return 'B'
    if score >= 70: return 'C'
    if score >= 60: return 'D'
    return 'F'

# Task Functions

def task3_show_tables(conn):
    """Task 3 – display all table contents."""
    tables = ["Professor", "Course", "Student", "Enrollment",
              "GradeCategory", "Assignment", "Score"]
    for t in tables:
        print(f"\n{'═'*60}\n  TABLE: {t}\n{'═'*60}")
        rows = conn.execute(f"SELECT * FROM {t}").fetchall()
        print_table(rows)
 
def task4_stats(conn):
    """Task 4 – Avg / Highest / Lowest score on an assignment."""
    print("\n── Task 4: Assignment Statistics ──")
    cid = pick_course(conn)
    aid = pick_assignment(conn, cid)
    rows = conn.execute("""
        SELECT a.assignment_name,
               ROUND(AVG(s.points_scored), 2) AS avg_score,
               MAX(s.points_scored)            AS highest_score,
               MIN(s.points_scored)            AS lowest_score
        FROM Score s
        JOIN Assignment a USING(assignment_id)
        WHERE a.assignment_id = ?
    """, (aid,)).fetchall()
    print_table(rows)
 
def task5_list_students(conn):
    """Task 5 – List all students in a given course."""
    print("\n── Task 5: Students in a Course ──")
    cid = pick_course(conn)
    rows = conn.execute("""
        SELECT st.student_id, st.first_name, st.last_name, st.email
        FROM Student st
        JOIN Enrollment e USING(student_id)
        WHERE e.course_id = ?
        ORDER BY st.last_name, st.first_name
    """, (cid,)).fetchall()
    print_table(rows)
 
def task6_all_scores(conn):
    """Task 6 – All students in a course with every score."""
    print("\n── Task 6: All Students & Scores ──")
    cid = pick_course(conn)
    rows = conn.execute("""
        SELECT st.first_name||' '||st.last_name          AS student,
               gc.category_name,
               a.assignment_name,
               COALESCE(CAST(sc.points_scored AS TEXT),'–') AS earned,
               CAST(a.max_score AS INTEGER)                  AS max_score
        FROM Enrollment e
        JOIN Student     st USING(student_id)
        JOIN GradeCategory gc ON gc.course_id = e.course_id
        JOIN Assignment   a  ON a.category_id = gc.category_id
        LEFT JOIN Score   sc ON sc.student_id = st.student_id
                             AND sc.assignment_id = a.assignment_id
        WHERE e.course_id = ?
        ORDER BY st.last_name, gc.category_name, a.assignment_name
    """, (cid,)).fetchall()
    print_table(rows, ["Student", "Category", "Assignment", "Scored", "Max"])
 
def task7_add_assignment(conn):
    """Task 7 – Add an assignment to a course."""
    print("\n── Task 7: Add Assignment ──")
    cid = pick_course(conn)
    cats = conn.execute(
        "SELECT category_id, category_name, weight FROM GradeCategory WHERE course_id=?",
        (cid,)
    ).fetchall()
    print_table(cats, ["category_id", "name", "weight%"])
    catid = int(input("Enter category_id to add assignment to: ").strip())
    name  = input("Assignment name: ").strip()
    maxs  = float(input("Max score [100]: ").strip() or 100)
    conn.execute(
        "INSERT INTO Assignment(category_id, assignment_name, max_score) VALUES(?,?,?)",
        (catid, name, maxs)
    )
    conn.commit()
    print(f"  ✓ Assignment '{name}' added.")
 
def task8_change_weights(conn):
    """Task 8 – Change category percentages for a course."""
    print("\n── Task 8: Update Category Weights ──")
    cid = pick_course(conn)
    cats = conn.execute(
        "SELECT category_id, category_name, weight FROM GradeCategory WHERE course_id=?",
        (cid,)
    ).fetchall()
    print_table(cats, ["category_id", "name", "weight%"])
    new_weights = {}
    for cat in cats:
        w = input(f"  New weight for '{cat['category_name']}' [current={cat['weight']}]: ").strip()
        new_weights[cat['category_id']] = float(w) if w else cat['weight']
    total = sum(new_weights.values())
    if abs(total - 100) > 0.001:
        print(f"  ✗ Weights sum to {total:.2f}, not 100. Aborting.")
        return
    for cid_k, w in new_weights.items():
        conn.execute("UPDATE GradeCategory SET weight=? WHERE category_id=?", (w, cid_k))
    conn.commit()
    print("  ✓ Weights updated.")
 
def task9_add_points_all(conn):
    """Task 9 – Add 2 points to every student on an assignment."""
    print("\n── Task 9: Add 2 Points to All Students ──")
    cid = pick_course(conn)
    aid = pick_assignment(conn, cid)
    conn.execute("""
        UPDATE Score
        SET points_scored = MIN(points_scored + 2,
                                (SELECT max_score FROM Assignment WHERE assignment_id=?))
        WHERE assignment_id = ?
    """, (aid, aid))
    conn.commit()
    print(f"  ✓ +2 pts applied to assignment {aid} for all students.")
    rows = conn.execute("""
        SELECT st.first_name||' '||st.last_name AS student,
             sc.points_scored AS score
        FROM Score sc
        JOIN Student st USING(student_id)
        WHERE sc.assignment_id = ?
        ORDER BY st.last_name
    """, (aid,)).fetchall()
    print_table(rows, ["Student", "Updated Score"])
 
def task10_add_points_Q(conn):
    """Task 10 – Add 2 points to students whose last name contains 'Q'."""
    print("\n── Task 10: Add 2 Points to Students with 'Q' in Last Name ──")
    cid = pick_course(conn)
    aid = pick_assignment(conn, cid)
    conn.execute("""
        UPDATE Score
        SET points_scored = MIN(points_scored + 2,
                                (SELECT max_score FROM Assignment
                                 WHERE assignment_id = Score.assignment_id))
        WHERE assignment_id = ?
          AND student_id IN (
              SELECT student_id FROM Student
              WHERE UPPER(last_name) LIKE '%Q%'
          )
    """, (aid,))
    conn.commit()
    rows = conn.execute("""
        SELECT st.first_name||' '||st.last_name AS student,
             sc.points_scored AS score
        FROM Score sc
        JOIN Student st USING(student_id)
        WHERE sc.assignment_id = ?
          AND UPPER(st.last_name) LIKE '%Q%'
        ORDER BY st.last_name
    """, (aid,)).fetchall()
    print("  ✓ +2 pts applied to 'Q' students:")
    print_table(rows, ["Student", "Updated Score"])
 
def task11_grade(conn):
    """Task 11 – Compute final grade for a student in a course."""
    print("\n── Task 11: Compute Student Grade ──")
    cid  = pick_course(conn)
    sid  = pick_student(conn)
    rows = conn.execute("""
        SELECT gc.category_name,
               ROUND(gc.weight, 1)                                      AS weight_pct,
             ROUND(AVG(sc.points_scored/a.max_score)*100, 2)          AS cat_avg,
             ROUND(gc.weight * AVG(sc.points_scored/a.max_score), 2)  AS contribution
        FROM Enrollment e
        JOIN GradeCategory gc ON gc.course_id  = e.course_id
        JOIN Assignment    a  ON a.category_id = gc.category_id
        JOIN Score         sc ON sc.student_id = e.student_id
                              AND sc.assignment_id = a.assignment_id
        WHERE e.student_id=? AND e.course_id=?
        GROUP BY gc.category_id
    """, (sid, cid)).fetchall()
    if not rows:
        print("  (no scores found)")
        return
    print_table(rows, ["Category", "Weight%", "Avg%", "Contribution"])
    total = sum(r["contribution"] for r in rows)
    # Look up professor for this course
    prof = conn.execute("""
        SELECT p.first_name||' '||p.last_name AS professor, p.department
        FROM Course c JOIN Professor p USING(professor_id)
        WHERE c.course_id = ?
    """, (cid,)).fetchone()
    print(f"\n  ► FINAL GRADE: {total:.2f} / 100  →  {letter_grade(total)}")
    if prof:
        print(f"  ► Professor: {prof['professor']} ({prof['department']})")
 
def task12_grade_drop_lowest(conn):
    """Task 12 – Grade for a student, dropping lowest score per category."""
    print("\n── Task 12: Grade (Drop Lowest per Category) ──")
    cid = pick_course(conn)
    sid = pick_student(conn)
    rows = conn.execute("""
        SELECT gc.category_name,
               ROUND(gc.weight, 1) AS weight_pct,
               COUNT(*)            AS num_scores,
               ROUND(
                 gc.weight * CASE
                                     WHEN COUNT(*) <= 1 THEN AVG(sc.points_scored/a.max_score)
                                     ELSE (SUM(sc.points_scored/a.max_score) - MIN(sc.points_scored/a.max_score))
                        / (COUNT(*) - 1)
                 END
               , 2) AS contribution
        FROM Enrollment e
        JOIN GradeCategory gc ON gc.course_id  = e.course_id
        JOIN Assignment    a  ON a.category_id = gc.category_id
        JOIN Score         sc ON sc.student_id = e.student_id
                              AND sc.assignment_id = a.assignment_id
        WHERE e.student_id=? AND e.course_id=?
        GROUP BY gc.category_id
    """, (sid, cid)).fetchall()
    if not rows:
        print("  (no scores found)")
        return
    print_table(rows, ["Category", "Weight%", "# Scores", "Contribution"])
    total = sum(r["contribution"] for r in rows)
    prof = conn.execute("""
        SELECT p.first_name||' '||p.last_name AS professor, p.department
        FROM Course c JOIN Professor p USING(professor_id)
        WHERE c.course_id = ?
    """, (cid,)).fetchone()
    print(f"\n  ► FINAL GRADE (drop lowest): {total:.2f} / 100  →  {letter_grade(total)}")
    if prof:
        print(f"  ► Professor: {prof['professor']} ({prof['department']})")

# Main Menu

MENU = textwrap.dedent("""
╔══════════════════════════════════════════════════╗
║            G R A D E B O O K  DB                 ║
╠══════════════════════════════════════════════════╣
║  3.  Show all tables                             ║
║  4.  Avg/High/Low score on an assignment         ║
║  5.  List students in a course                   ║
║  6.  Students + all scores in a course           ║
║  7.  Add an assignment to a course               ║
║  8.  Change category weights for a course        ║
║  9.  Add 2 pts to all students on assignment     ║
║  10. Add 2 pts to students with 'Q' in name      ║
║  11. Compute grade for a student                 ║
║  12. Grade (drop lowest per category)            ║
║  0.  Exit                                        ║
╚══════════════════════════════════════════════════╝
""")
 
def main():
    init_db()
    conn = get_conn()
    print("Gradebook DB initialized.")
    dispatch = {
        "3":  task3_show_tables,
        "4":  task4_stats,
        "5":  task5_list_students,
        "6":  task6_all_scores,
        "7":  task7_add_assignment,
        "8":  task8_change_weights,
        "9":  task9_add_points_all,
        "10": task10_add_points_Q,
        "11": task11_grade,
        "12": task12_grade_drop_lowest,
    }
    while True:
        print(MENU)
        choice = input("Choice: ").strip()
        if choice == "0":
            print("Bye!")
            break
        fn = dispatch.get(choice)
        if fn:
            try:
                fn(conn)
            except Exception as e:
                print(f"  ✗ Error: {e}")
        else:
            print("  Invalid choice.")
    conn.close()
 
if __name__ == "__main__":
    main()