## Database-Systems-Team-Project
Grade Book Database Project
Team Members: CHRISTOPHER REID, XAVIER GREEN, JAMARRI MEZIER

This project implements a relational database to keep track of student grades for several courses taught by a professor. It calculates final grades based on weighted categories (e.g., Participation, Homework, Tests, Projects) that sum to 100%.


## Files Included
* `gradebook.py`: The executable Python application with an interactive menu.
* `test_gradebook.py`: The automated Python unit test suite.
* `table_creation.sql`: Commands for creating the database schema.
* `value_insertion.sql`: Commands for seeding the database with initial data.
* `show_tables.sql`: Commands to display table contents.
* `query_commands.sql`: The SQL commands used to fulfill Tasks 4 through 12.
* `Grade Book ER Diagram.drawio.pdf`: The Entity-Relationship diagram for the database.


## Instructions to Compile and Execute

### Option 1: Interactive Python Application 
1. Open your terminal or command prompt.
2. Navigate to the directory containing `gradebook.py`.
3. Run the application:
   `python3 gradebook.py`
4. The script will automatically initialize the database (`gradebook.db`), execute the table creation, and insert the seed values. 
5. Follow the on-screen menu to test tasks 3 through 12 by typing the corresponding number and pressing Enter.

### Option 2: SQLite Command Line
1. Open your terminal in the project directory.
2. Open the database using SQLite:
   `sqlite3 gradebook.db`
3. Run the table creation and insertion scripts:
   `.read table_creation.sql`
   `.read value_insertion.sql`
4. Execute the specific query commands to test tasks 4-12:
   `.read query_commands.sql`

### Running Automated Tests
To run the automated test suite without manual interaction:
1. Open your terminal in the project directory.
2. Run the test script:
   `python3 test_gradebook.py`
3. The test framework will spin up an isolated in-memory database, run the automated scenarios, and print a pass/fail report to the console.

---

## Test Cases & Documented Results

### Part A: Database Query Tasks (Tasks 4-12)
These test cases explicitly verify the functionality requested in the project rubric based on the initial seed data.

* **Task 4 (Statistics):** Target `CSCI 375` -> `HW1`. 
  * *Result:* Average Score: 76.57, Highest Score: 90, Lowest Score: 55.
* **Task 5 (Course Roster):** Target `CSCI 375`. 
  * *Result:* Successfully lists Alie Anderson, Xavier Green, Divine Jones, Grace Kellies, Jamarri Mezier, Billy Quinn, and Chris Reid.
* **Task 6 (All Scores Matrix):** Target `CSCI 375`. 
  * *Result:* Maps every student to assignments. Example: Alie Anderson shows 95 on Participation, 88 on HW1, 92 on HW2. Unattempted assignments display as NULL/blank.
* **Task 7 (Add Assignment):** Target `CSCI 375`. Add `HW6` to "Homework".
  * *Result:* `HW6` is successfully inserted into the `Assignment` table constrained to a max score of 100.
* **Task 8 (Update Weights):** Target `CSCI 375`. Change percentages to Participation 10%, Homework 25%, Tests 20%, Projects 45%.
  * *Result:* The `GradeCategory` table updates correctly, assigning new weights while ensuring the total equals 100%.
* **Task 9 (Universal Bonus Points):** Target `HW1` in `CSCI 375`. Add 2 points to all students.
  * *Result:* All scores for HW1 are incremented by 2 points. The MIN() logic correctly caps any overflow at the max score of 100.
* **Task 10 (Conditional Bonus Points):** Target `HW1` in `CSCI 375`. Add 2 points only to students with 'Q' in their last name.
  * *Result:* The SQL `LIKE '%Q%'` filter isolates Billy Quinn. Only his score for HW1 increments by 2; others remain unchanged.
* **Task 11 (Compute Final Grade):** Target student `alie@uni.edu` in `CSCI 375`.
  * *Result:* Final grade calculates accurately to **31.81** out of 100 based on the current weighting.
* **Task 12 (Compute Grade w/ Dropped Score):** Target student `alie@uni.edu` in `CSCI 375`.
  * *Result:* Dropping the lowest score in each category improves the final grade to **32.17** out of 100.

### Part B: Automated Unit Tests (`test_gradebook.py`)
The automated test script uses Python `unittest` library and `unittest.mock.patch` to simulate user input against an isolated in-memory database to prevent corrupting the local `.db` file. 

* **Test: `test_task4_stats`**
  * *Action:* Simulates inputs `['1', '2']` to select CSCI 375 and HW1.
  * *Assertion:* Output must contain "90.0" (High), "55.0" (Low), and "76.57" (Avg).
  * *Result:* **PASS**.
* **Test: `test_task5_list_students`**
  * *Action:* Simulates input `['1']` to list the roster for CSCI 375.
  * *Assertion:* Output must contain specific known emails (`alie@uni.edu`, `xavier@uni.edu`, `billy@uni.edu`).
  * *Result:* **PASS**.
* **Test: `test_task9_add_bonus_points`**
  * *Action:* Verifies Student 1's score for HW1 is 88.0. Runs the bonus point function. Re-queries the database.
  * *Assertion:* Student 1's new score must strictly equal 90.0.
  * *Result:* **PASS**.
* **Test: `test_task11_compute_grade`**
  * *Action:* Simulates inputs `['1', '1']` to compute the final grade for Student 1 in Course 1.
  * *Assertion:* Output must contain the specific string "32"(calculated purely from the fresh seed data before any weights were changed).
  * *Result:* **PASS**.