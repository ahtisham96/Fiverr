#!/usr/bin/python3
# -*- coding: utf-8 -*-

import os
import sys

# Temporarily add the current path to the system path for importing the student's source code.
sys.path.append(
    os.path.join(
        os.path.dirname(os.path.dirname(os.path.abspath(__file__))), ".admin_files"
    )
)
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
# python3 seemingly respects only abspaths, while ipython3 is ok with relative, like '..' here.
import test_utils


@test_utils.test_wrapper
def test() -> bool:
    # To debug in pudb3
    # Highlight the line of code below below
    # Type 't' to jump 'to' it
    # Type 's' to 'step' deeper
    # Type 'n' to 'next' over
    # Type 'f' or 'r' to finish/return a function call and go back to caller

    import maze
    import pickle
    import maze_utils
    from typing import List

    def run_student_main(
        case_file_name: str = "test_cases.txt",
        out_file_name: str = "student_output.txt",
    ) -> List[str]:
        """
        Runs the student main() function (imported from the top-level directory),
        and returns its output.  The student's output is written to a file
        (such that the student can review it)
        @param case_file_name:
            Optional, the name of the text file the cases were written to
        @param out_file_name:
            Optional, the name of the text file to write the student's output to
        """
        with open(case_file_name, "r") as test_input:
            with open(out_file_name, "w") as their_output:
                orig_in = sys.stdin
                orig_out = sys.stdout
                sys.stdin = test_input
                sys.stdout = their_output
                maze.main()
                sys.stdin = orig_in
                sys.stdout = orig_out
        with open(out_file_name, "r") as their_output:
            output_lines = their_output.readlines()
        return output_lines

    saved_cases_file = "random_main_cases.pkl"
    student_input = "temp_06_randomized_input.txt"
    student_output = "temp_06_randomized_output.txt"
    try:
        with open(saved_cases_file, "rb") as pickle_in:
            cases = pickle.load(pickle_in)
    except:
        # Hardcode 4 cases for now - should this be random?
        cases = maze_utils.generate_cases(4, student_input)
        with open(saved_cases_file, "wb") as pickle_out:
            pickle.dump(cases, pickle_out)
    output_lines = run_student_main(student_input, student_output)
    result = maze_utils.validate_student_output(cases, output_lines)
    # If it passed, delete the file - this will cause the generator to
    # generate a new set of cases for the next run
    try:
        os.remove(saved_cases_file)
        os.remove(student_input)
        os.remove(student_output)
    except:
        pass
    return result


if __name__ == "__main__":
    test()
