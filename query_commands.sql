-- =========
-- Tasks 4-12: Functionality Commands
-- =========
-- This file contains SQL commands that demonstrate the functionality of the database.
-- Run these commands in the SQLite shell to see how the database works.

PRAGMA foreign_keys = ON;

-- Task 4: Compute the average/highest/lowest score of an assignment;
SELECT
	a.assignment_id,
	a.assignment_name,
	ROUND(AVG(s.points_scored), 2) AS avg_score,
	MAX(s.points_scored) AS highest_score,
	MIN(s.points_scored) AS lowest_score
FROM Assignment a
JOIN Score s ON s.assignment_id = a.assignment_id
JOIN GradeCategory gc ON gc.category_id = a.category_id
JOIN Course c ON c.course_id = gc.course_id
WHERE c.department = 'CSCI'
  AND c.course_number = '375'
  AND a.assignment_name = 'HW1'
GROUP BY a.assignment_id, a.assignment_name;


-- Task 5: List all of the students in a given course;
SELECT
	st.student_id,
	st.first_name,
	st.last_name,
	st.email
FROM Student st
JOIN Enrollment e ON e.student_id = st.student_id
JOIN Course c ON c.course_id = e.course_id
WHERE c.department = 'CSCI'
  AND c.course_number = '375'
  AND c.semester = 'Fall'
  AND c.year = 2025
ORDER BY st.last_name, st.first_name;


-- Task 6: List all of the students in a course and all of their scores on every assignment;
SELECT
	st.student_id,
	st.first_name,
	st.last_name,
	a.assignment_id,
	a.assignment_name,
	a.max_score,
	s.points_scored
FROM Student st
JOIN Enrollment e ON e.student_id = st.student_id
JOIN Course c ON c.course_id = e.course_id
JOIN GradeCategory gc ON gc.course_id = c.course_id
JOIN Assignment a ON a.category_id = gc.category_id
LEFT JOIN Score s
	   ON s.student_id = st.student_id
	  AND s.assignment_id = a.assignment_id
WHERE c.department = 'CSCI'
  AND c.course_number = '375'
  AND c.semester = 'Fall'
  AND c.year = 2025
ORDER BY st.last_name, st.first_name, a.assignment_id;


-- Task 7: Add an assignment to a course;
INSERT INTO Assignment(category_id, assignment_name, max_score)
SELECT gc.category_id, 'HW6', 100
FROM GradeCategory gc
JOIN Course c ON c.course_id = gc.course_id
WHERE c.department = 'CSCI'
  AND c.course_number = '375'
  AND c.semester = 'Fall'
  AND c.year = 2025
  AND gc.category_name = 'Homework';


-- Task 8: Change the percentages of the categories for a course;
UPDATE GradeCategory
SET weight = CASE category_name
	WHEN 'Participation' THEN 10
	WHEN 'Homework' THEN 25
	WHEN 'Tests' THEN 20
	WHEN 'Projects' THEN 45
	ELSE weight
END
WHERE course_id = (
	SELECT c.course_id
	FROM Course c
	WHERE c.department = 'CSCI'
	  AND c.course_number = '375'
	  AND c.semester = 'Fall'
	  AND c.year = 2025
)
AND category_name IN ('Participation', 'Homework', 'Tests', 'Projects');


-- Task 9: Add 2 points to the score of each student on an assignment;
UPDATE Score
SET points_scored = MIN(
	points_scored + 2,
	(
		SELECT a.max_score
		FROM Assignment a
		WHERE a.assignment_id = Score.assignment_id
	)
)
WHERE assignment_id = (
	SELECT a.assignment_id
	FROM Assignment a
	JOIN GradeCategory gc ON gc.category_id = a.category_id
	JOIN Course c ON c.course_id = gc.course_id
	WHERE c.department = 'CSCI'
	  AND c.course_number = '375'
	  AND c.semester = 'Fall'
	  AND c.year = 2025
	  AND a.assignment_name = 'HW1'
);


-- Task 10: Add 2 points just to those students whose last name contains a ‘Q’.
UPDATE Score
SET points_scored = MIN(
	points_scored + 2,
	(
		SELECT a.max_score
		FROM Assignment a
		WHERE a.assignment_id = Score.assignment_id
	)
)
WHERE assignment_id = (
	SELECT a.assignment_id
	FROM Assignment a
	JOIN GradeCategory gc ON gc.category_id = a.category_id
	JOIN Course c ON c.course_id = gc.course_id
	WHERE c.department = 'CSCI'
	  AND c.course_number = '375'
	  AND c.semester = 'Fall'
	  AND c.year = 2025
	  AND a.assignment_name = 'HW1'
)
AND student_id IN (
	SELECT st.student_id
	FROM Student st
	WHERE st.last_name LIKE '%Q%'
);


-- Task 11: Compute the grade for a student;
WITH category_scores AS (
	SELECT
		gc.category_id,
		gc.category_name,
		gc.weight,
		AVG(100.0 * s.points_scored / a.max_score) AS category_percent
	FROM GradeCategory gc
	JOIN Assignment a ON a.category_id = gc.category_id
	LEFT JOIN Score s
		   ON s.assignment_id = a.assignment_id
		  AND s.student_id = (
			  SELECT st.student_id
			  FROM Student st
			  WHERE st.email = 'alie@uni.edu'
		  )
	WHERE gc.course_id = (
		SELECT c.course_id
		FROM Course c
		WHERE c.department = 'CSCI'
		  AND c.course_number = '375'
		  AND c.semester = 'Fall'
		  AND c.year = 2025
	)
	GROUP BY gc.category_id, gc.category_name, gc.weight
)
SELECT
	ROUND(SUM(COALESCE(category_percent, 0) * (weight / 100.0)), 2) AS final_grade_percent
FROM category_scores;


-- Task 12: Compute the grade for a student, where the lowest score for a given category is dropped.
WITH raw_scores AS (
	SELECT
		gc.category_id,
		gc.category_name,
		gc.weight,
		a.assignment_id,
		100.0 * s.points_scored / a.max_score AS score_percent
	FROM GradeCategory gc
	JOIN Assignment a ON a.category_id = gc.category_id
	JOIN Score s
	  ON s.assignment_id = a.assignment_id
	 AND s.student_id = (
		 SELECT st.student_id
		 FROM Student st
		 WHERE st.email = 'alie@uni.edu'
	 )
	WHERE gc.course_id = (
		SELECT c.course_id
		FROM Course c
		WHERE c.department = 'CSCI'
		  AND c.course_number = '375'
		  AND c.semester = 'Fall'
		  AND c.year = 2025
	)
),
ranked AS (
	SELECT
		rs.*,
		ROW_NUMBER() OVER (
			PARTITION BY rs.category_id
			ORDER BY rs.score_percent ASC
		) AS rn,
		COUNT(*) OVER (PARTITION BY rs.category_id) AS cnt
	FROM raw_scores rs
),
category_after_drop AS (
	SELECT
		category_id,
		category_name,
		weight,
		AVG(
			CASE
				WHEN cnt = 1 THEN score_percent
				WHEN rn > 1 THEN score_percent
			END
		) AS category_percent_after_drop
	FROM ranked
	GROUP BY category_id, category_name, weight
)
SELECT
	ROUND(SUM(category_percent_after_drop * (weight / 100.0)), 2) AS final_grade_percent_drop_lowest
FROM category_after_drop;
