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
    from typing import List

    passed = False
    matrix: List[List[str]] = pickle.load(open("unit_tests/example_matrix.pkl", "rb"))

    # positive
    if maze.valid_move(matrix, 1, 2, "EAST") is True:
        passed = True

    # negative
    if maze.valid_move(matrix, 11, 17, "NORTH") is False:
        passed = True

    return passed


if __name__ == "__main__":
    test()
