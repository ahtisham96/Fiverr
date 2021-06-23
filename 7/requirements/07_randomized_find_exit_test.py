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

    saved_cases_file = "random_find_exit_cases.pkl"
    student_input = "temp_07_randomized_find_exit_input.txt"
    student_output = "temp_07_randomized_find_exit_output.txt"
    try:
        with open(saved_cases_file, "rb") as pickle_in:
            cases = pickle.load(pickle_in)
    except:
        # Hardcode 4 cases for now - should this be random?
        cases = maze_utils.generate_cases(4, student_input)
        with open(saved_cases_file, "wb") as pickle_out:
            pickle.dump(cases, pickle_out)
    result = True
    for case in cases:
        if case.ans != maze.find_exit(
            case.as_char_matrix(), case.start_loc[0], case.start_loc[1]
        ):
            result = False
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
