import unittest
import sqlite3
import io
import sys
from unittest.mock import patch

# Import main application
import gradebook

class TestGradebook(unittest.TestCase):
    
    def setUp(self):
        """Runs before every test. Sets up a fresh, in-memory database."""
        self.conn = sqlite3.connect(':memory:')
        self.conn.row_factory = sqlite3.Row
        self.conn.execute("PRAGMA foreign_keys = ON")
        
        # Load the schema and seed data from gradebook.py file
        self.conn.executescript(gradebook.SCHEMA)
        self.conn.executescript(gradebook.SEED_DATA)

    def tearDown(self):
        """Runs after every test to clean up."""
        self.conn.close()

    @patch('builtins.input', side_effect=['1', '2']) 
    def test_task4_stats(self, mock_input):
        """
        Test Case 4: Tests stats for course 1 (CSCI 375), assignment 2 (HW1).
        We mock the inputs to simulate the user typing '1' then '2'.
        """
        # Capture the terminal output
        captured_output = io.StringIO()
        sys.stdout = captured_output
        
        # Run the function
        gradebook.task4_stats(self.conn)
        
        # Restore normal terminal output
        sys.stdout = sys.__stdout__
        output = captured_output.getvalue()
        
        # Verify the expected math based on the seed data
        self.assertIn("90.0", output, "Highest score should be 90")
        self.assertIn("55.0", output, "Lowest score should be 55")
        self.assertIn("76.57", output, "Average score should be 76.57")

    @patch('builtins.input', side_effect=['1'])
    def test_task5_list_students(self, mock_input):
        """
        Test Case 5: Tests listing students for course 1 (CSCI 375).
        """
        captured_output = io.StringIO()
        sys.stdout = captured_output
        
        gradebook.task5_list_students(self.conn)
        
        sys.stdout = sys.__stdout__
        output = captured_output.getvalue()
        
        # Check if the known students are printed in the output
        self.assertIn("alie@uni.edu", output)
        self.assertIn("xavier@uni.edu", output)
        self.assertIn("billy@uni.edu", output)

    @patch('builtins.input', side_effect=['1', '1'])
    def test_task11_compute_grade(self, mock_input):
        """
        Test Case 11: Tests final grade computation for Course 1, Student 1 (Alie)
        """
        captured_output = io.StringIO()
        sys.stdout = captured_output
        
        gradebook.task11_grade(self.conn)
        
        sys.stdout = sys.__stdout__
        output = captured_output.getvalue()
        
        # Verify Alie's computed grade is correct based on the seed data
        self.assertIn("32.00", output, "Final grade calculation is incorrect")

    @patch('builtins.input', side_effect=['1', '2'])
    def test_task9_add_bonus_points(self, mock_input):
        """
        Test Case 9: Tests adding 2 bonus points to HW1 in CSCI 375.
        """
        # First, grab a student's score before the change (Student 1, Assignment 2 is 88)
        before_score = self.conn.execute(
            "SELECT points_scored FROM Score WHERE student_id=1 AND assignment_id=2"
        ).fetchone()[0]
        
        self.assertEqual(before_score, 88.0)

        # Suppress the print output so the test console stays clean
        sys.stdout = io.StringIO()
        gradebook.task9_add_points_all(self.conn)
        sys.stdout = sys.__stdout__

        # Check the score after the function runs
        after_score = self.conn.execute(
            "SELECT points_scored FROM Score WHERE student_id=1 AND assignment_id=2"
        ).fetchone()[0]
        
        self.assertEqual(after_score, 90.0, "Score should have increased by exactly 2 points")

if __name__ == '__main__':
    unittest.main(verbosity=2)