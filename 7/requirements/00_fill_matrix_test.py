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
    from typing import List

    rows: int = 27
    matrix: List[List[str]] = []

    with open("unit_tests/example_matrix.txt", "r") as sample_in:
        orig_in = sys.stdin
        sys.stdin = sample_in
        maze.fill_matrix(matrix, rows)
        sys.stdin = orig_in
        # temporary:
        # import pickle
        # pickle.dump(matrix, open("matrix.pkl", "wb"))

        if matrix[5][12] == "|" and matrix[13][49] == "E" and matrix[11][19] == "N":
            return True
        else:
            return False


if __name__ == "__main__":
    test()


