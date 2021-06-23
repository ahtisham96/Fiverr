#!/usr/bin/python3
# -*- coding: utf-8 -*-


from typing import List, Tuple
import sys

assert (
    "linux" in sys.platform
), "This code should be run on Linux"


def fill_matrix(matrix: List[List[str]], rows: int) -> None:
    '''
    Purpose:        generate the matrix that is inputted via standard input

    Parameters:     matrix as a list of lists of strings, and rows as an int.
    User Input:     yes, std in the matrix itself
    Prints:         nothing
    Returns:        nothing
    Modifies:       matrix is modified
    Calls:          standard python, input
    Tests:          00_fill_matrix_test.py
    '''
 
    deletemeandwriterealcode: str = 0
    pass


def print_matrix(matrix: List[List[str]]) -> None:
    """
    Purpose:        prints the matrix and nothing else!

    Parameters:     matrix as a list of lists of strings
    User Input:     no
    Prints:         the matrix (see sample_outputs/ for format)
    Returns:        nothing
    Modifies:       nothing
    Calls:          standard python
    Tests:          01_print_matrix_test.py
    """

    pass


def find_start(matrix: List[List[str]], rows: int) -> Tuple[int, int]:
    """
    Purpose:        Finds Niobe's starting location (row, col)

    Parameters:     matrix as a list of lists of strings, row as int
    User Input:     no
    Prints:         nothing
    Returns:        (row, col) as a tuple of ints
    Modifies:       nothing
    Calls:          standard python
    Tests:          02_find_start_test.py
    Notes:          Double-for loop?
    """

    pass


def at_end(matrix: List[List[str]], row: int, col: int) -> bool:
    """
    Purpose:        Determines if Niobe has reached the exit

    Parameters:     matrix as a list of lists of strings, row as int
    User Input:     no
    Prints:         nothing
    Returns:        True if at the exit, False otherwise
    Modifies:       nothing
    Calls:          standard python
    Tests:          03_at_end_test.py
    """

    pass


def valid_move(matrix: List[List[str]], row: int, col: int, direction: str) -> bool:
    """
    Purpose:        checks AHEAD in direction if move is ok
                    (not row col itself, but the next move)

    Parameters:     matrix as a list of lists of strings,
                    row, col as ints, and
                    direction as str, e.g.,
                    'NORTH', 'SOUTH', 'EAST', 'WEST'
    User Input:     no
    Prints:         nothing
    Returns:        True if move is valid False otherwise
    Modifies:       nothing
    Calls:          standard python
    Tests:           04_valid_move_test.py
    """

    pass



def find_exit(matrix: List[List[str]], row: int, col: int) -> bool:
    """
    Purpose:        Recursively draw a path to the exit

    Parameters:     matrix as a list of lists of strings,
                    row, col as ints
    User Input:     no
    Prints:         nothing
    Returns:        True if at the exit, False otherwise
    Modifies:       nothing
    Calls:          at_end, valid_move, find_exit, standard python
    Tests:          05_find_exit_test.py
    """

    pass


def main() -> None:
    """
    Purpose:        Driver for your maze game.

    Parameters:     None
    User Input:     Yes
    Prints:         Yes
    Returns:        None
    Modifies:       Game parameters
    Calls:          fill_matrix, find_start, and find_exit
    Tests:          stdio_tests/*
    """

    pass


# Do NOT edit below this line:
if __name__ == "__main__":
    main()
