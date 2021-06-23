#!/usr/bin/python3
# -*- coding: utf-8 -*-


import random
from typing import List, Tuple, Callable
import sys

min_dimension = 4
max_dimension = 20
# Number of random walks to take
max_num_walks = 5
# Number of steps to take when walking straight
max_path_len = 5
# Number of turns to make
max_dir_len = 10
max_num_cases = 5


def replace_pos_str(inpt: str, pos: int, replace_item: str) -> str:
    return inpt[:pos] + replace_item + inpt[pos + 1 :]


class MazeCase:
    # East, West, South, North
    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]

    def __init__(self, idx: int = 0) -> None:
        self.width = random.randint(min_dimension * 2, max_dimension)
        self.height = random.randint(min_dimension, max_dimension)
        self.grid = ["|" * self.width for _ in range(self.height)]
        for _ in range(random.randint(2, max_num_walks)):
            self.random_walk()

        # Knowing the graph's connected components lets us find out whether
        # there's a solution without giving away the answer
        connected_components: List[List[Tuple[int, int]]] = []
        # For each tile, check if it's already been checked, if not, it's the start
        # of a new connected component
        for i in range(1, self.height):
            for j in range(1, self.width):
                if self.grid[i][j] == " ":
                    # A disjoint set would be better here
                    if not any(
                        (i, j) in component for component in connected_components
                    ):
                        connected_components.append(bfs(self.grid, i, j))
        # Pick random components for start and end
        # Filter out any components of size 1
        connected_components = [
            component for component in connected_components if len(component) > 1
        ]
        start_idx = random.randint(0, len(connected_components) - 1)
        end_idx = random.randint(0, len(connected_components) - 1)
        self.start_loc = random.choice(connected_components[start_idx])
        # Remove the one we picked so we don't pick it twice
        connected_components[start_idx].remove(self.start_loc)
        self.end_loc = random.choice(connected_components[end_idx])
        self.grid[self.start_loc[0]] = replace_pos_str(
            self.grid[self.start_loc[0]], self.start_loc[1], "N"
        )
        self.grid[self.end_loc[0]] = replace_pos_str(
            self.grid[self.end_loc[0]], self.end_loc[1], "E"
        )
        # There will only be a solution if the start and the end are in the
        # same connected component
        self.ans = start_idx == end_idx
        self.soln_str = "Map {} -- {} found:\n".format(
            idx, ("No solution", "Solution")[self.ans]
        )

    def random_walk(self) -> None:
        i = random.randint(1, self.height - 2)
        j = random.randint(1, self.width - 2)
        self.grid[i] = replace_pos_str(self.grid[i], j, " ")
        # See how many of the neigboring spaces are empty
        # (we don't want large empty blocks)
        empty_neighbors: Callable[[int, int], int] = lambda i, j: (
            "".join(
                [self.grid[i + coord[0]][j + coord[1]] for coord in MazeCase.directions]
            ).count(" ")
        )
        # Must leave a boarder, not have already been visited, and above cond
        valid: Callable[[int, int], bool] = (
            lambda i, j: (i > 1)
            and (j > 1)
            and (i < (self.height - 1))
            and (j < (self.width - 1))
            and (self.grid[i][j] != " ")
            and (empty_neighbors(i, j) < 2)
        )
        # Make between 1 and max_dir_len "turns"
        num_turns = random.randint(1, max_dir_len)
        dirs_moved = 0
        while dirs_moved < num_turns:
            random.shuffle(MazeCase.directions)
            # See if we can go in any direction
            move_dirs = [
                cand_dir
                for cand_dir in MazeCase.directions
                if valid(i + cand_dir[0], j + cand_dir[1])
            ]
            if not move_dirs:
                break
            move_dir = move_dirs[0]
            spaces_moved = 0
            # Take between 1 and max_path_len "steps" in given direction
            num_steps = random.randint(1, max_path_len)
            while valid(i + move_dir[0], j + move_dir[1]) and spaces_moved < num_steps:
                i += move_dir[0]
                j += move_dir[1]
                self.grid[i] = replace_pos_str(self.grid[i], j, " ")
                spaces_moved += 1
            dirs_moved += 1

    def validate(self, other_grid: List[str]) -> bool:
        result = True
        for i in range(self.height):
            for j in range(self.width):
                # The only modification we allow is the replacing of spaces
                # with the @ symbol
                if self.grid[i][j] == " " and (other_grid[i][j] not in " @"):
                    result = False
                elif self.grid[i][j] != " " and self.grid[i][j] != other_grid[i][j]:
                    result = False
        return result

    def as_char_matrix(self) -> List[List[str]]:
        """
        Oops, the 1575 version of this assignment used 1D vectors of strings...
        """
        return [list(row) for row in self.grid]

    def __str__(self) -> str:
        return "{}\n{}\n".format(len(self.grid), "\n".join([row for row in self.grid]))


# A disjoint set would be faster...
def bfs(
    grid: List[str], i: int, j: int, valid_spaces: str = " "
) -> List[Tuple[int, int]]:
    result: List[Tuple[int, int]] = []
    queue = [(i, j)]
    # directions = [(0,1), (0,-1), (1,0), (-1,0)]
    while queue:
        ele = queue.pop(0)
        if ele not in result:
            # We check in all directions
            for direction in MazeCase.directions:
                # Must be an empty space and not already checked by us
                if (
                    grid[ele[0] + direction[0]][ele[1] + direction[1]] in valid_spaces
                ) and (ele[0] + direction[0], ele[1] + direction[1]) not in result:
                    queue.append((ele[0] + direction[0], ele[1] + direction[1]))
        result.append(ele)
    return result


def generate_cases(num_cases: int, file_name: str = "test_cases.txt") -> List[MazeCase]:
    """
    Generates a set of mazes and writes them to a file in the format that student
    implementations are expecting
    @param num_cases: The number of cases to generate
    @param file_name: Optional, the name of the text file to write the cases to
    """
    cases: List[MazeCase] = []
    with open(file_name, "w") as test_input:
        for i in range(num_cases):
            case = MazeCase(i)
            cases.append(case)
            test_input.write(str(case) + "\n")
        test_input.write("0\n")
    return cases


def validate_student_output(cases: List[MazeCase], output_lines: List[str]) -> bool:
    result = True
    for case_idx, case in enumerate(cases):
        print("Checking maze #{}...".format(case_idx))
        num_lines = len(case.grid) + 2
        this_case_output = output_lines[:num_lines]
        output_lines = output_lines[num_lines:]
        if this_case_output[0] != case.soln_str:
            print("Solution output incorrect!")
            result = False
        soln_grid = this_case_output[1:-1]
        # print(''.join(soln_grid))
        # Make sure they didn't modify the maze in any way
        if not case.validate(soln_grid):
            print("Maze walls were modified!")
            result = False
        reachable = bfs(soln_grid, case.start_loc[0], case.start_loc[1], "E@")
        if case.ans and (case.end_loc not in reachable):
            print("There was a solution, but your code did not find it!")
            result = False
        elif not case.ans and (case.end_loc in reachable):
            print("There was not a solution, but your code found it anyways!")
            result = False
    return result


def should_be_recursive(
    stack_limit: int,
) -> Callable[[Callable[[], bool]], Callable[[], bool]]:
    def stack_checker(test: Callable[[], bool]) -> Callable[[], bool]:
        def wrapper() -> bool:
            if test():
                init_limit = sys.getrecursionlimit()
                sys.setrecursionlimit(stack_limit)
                try:
                    test()
                    # If we get to here, then the stack limit was not reached, so
                    # we reset and return False
                    sys.setrecursionlimit(init_limit)
                    print("Your solution is not recursive!")
                    return False
                # If recursion is detected, reset the limit and run the test
                except RecursionError:
                    sys.setrecursionlimit(init_limit)
                    return True
            return False

        return wrapper

    return stack_checker
