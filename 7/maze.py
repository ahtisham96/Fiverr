#!/usr/bin/python3
# -*- coding: utf-8 -*-


from typing import List, Tuple
import sys

assert (
    "linux" in sys.platform
), "This code should be run on Linux"

global_solution =[]

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
    
    #maze = matrix
    #no_of_rows = len(maze)
    #columns = len(maze[0])

    #row = int(input("Enter row_no you want to edit"))
    #col = int(input("Enter col_no you want to edit"))
#
    #if(row<= no_of_rows and col<= columns):
    #    matrix[row][col] = input("Enter the value you want to replate")
    #    print_matrix(matrix)

    row = int(input("Enter number of rows of your matrix"))
    col = int(input("Enter number of columns of your matrix"))

    i = 0
    while i < row:
        j = 0
        while j < col:
            print('Enter value for row: ',i,' column: ',j,' :')
            matrix[i][j] = input()
            j += 1
        i +=1
    

    #print_matrix(matrix)

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

    for i in matrix:
        for j in i:
            print(j, end ='')
        print('')

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

    r =0
    sta_point_row = 0
    sta_point_col = 0
    start_tuple = []

    while r<rows:
        #print(matrix[r])
        if 'N' in matrix[r]:
            c=0
            var = 'n'
            while var != 'N':
                var = matrix[r][c]
                c += 1
            start_tuple.append(r)
            start_tuple.append(c - 1)
        r += 1

    return start_tuple

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

    # assigning matrix to maze_matrix
    maze = matrix
    no_of_rows = len(maze)
    columns = len(maze[0])
    print('no_of_rows: ',no_of_rows,' columns: ',columns)
    #list to store the matrix to check visted path
    solution = [['0']*columns for _ in range(no_of_rows)]

    #function to solve the maze
    #using backtracking    
    
    r = row
    c = col
    
 

    def solvemaze(r, c):
        #if destination is reached, maze is solved
        #destination is where it find E
        if maze[r][c] == 'E':        
            solution[r][c] = '1'
            return True
        #checking if we can visit in this cell or not
        #the indices of the cell must be in (0,SIZE-1)
        #and solution[r][c] == 0 is making sure that the cell is not already visited
        #maze[r][c] == 0 is making sure that the cell is not blocked
       
        if r>=0 and c>=0 and r<no_of_rows and c<columns and solution[r][c] == '0' and maze[r][c] == ' ' or maze[r][c] == 'N' :
            #if safe to visit then visit the cell
            
            solution[r][c] = '1'
            #going down
            if solvemaze(r+1, c):           
                return True
            #going right
            if solvemaze(r, c+1):           
                return True
            #going up
            if solvemaze(r-1, c):           
                return True
            #going left
            if solvemaze(r, c-1):         
                return True
            #backtracking
            solution[r][c] = 1
            
            return False
        return 0
    
   

    if(solvemaze(row,col)):
        #print('True')
        return True
    else:
        #print('False')
        return False

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
    r = row
    c = col
    maze = matrix
    no_of_rows = len(maze)
    columns = len(maze[0])

    if direction == 'SOUTH':
        if r>=0 and c>=0 and r+1<no_of_rows and c<columns and maze[r][c] == ' ' or maze[r][c] == 'N' :
            return True
        else:
                return False
    elif direction == 'EAST':
        if r>=0 and c>=0 and r<no_of_rows and c+1<columns and maze[r][c] == ' ' or maze[r][c] == 'N' :
            return True
        else:
            return False  
    elif direction == 'NORTH':
            if r>=0 and c>=0 and r-1<no_of_rows and c<columns and maze[r][c] == ' ' or maze[r][c] == 'N' :
                return True
            else:
                return False 
    elif direction == 'WEST':
            if r>=0 and c>=0 and r<no_of_rows and c-1<columns and maze[r][c] == ' ' or maze[r][c] == 'N' :
                return True
            else:
                return False 
    else:
        return False
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
    # assigning matrix to maze_matrix
    maze = matrix
    no_of_rows = len(maze)
    columns = len(maze[0])
    #list to store the matrix to check visted path
    solution = [['0']*columns for _ in range(no_of_rows)]

    #function to solve the maze
    #using backtracking

    
    r = row
    c = col

    def solvemaze(r, c):
        #if destination is reached, maze is solved
        #destination is where it find E
        if maze[r][c] == 'E':        
            solution[r][c] = '1'
            return True
        #checking if we can visit in this cell or not
        #the indices of the cell must be in (0,SIZE-1)
        #and solution[r][c] == 0 is making sure that the cell is not already visited
        #maze[r][c] == 0 is making sure that the cell is not blocked
        #print(r,' ',c)
        if r>=0 and c>=0 and r<no_of_rows and c<columns and solution[r][c] == '0' and maze[r][c] == ' ' or maze[r][c] == 'N' :
            #if safe to visit then visit the cell
            
            solution[r][c] = '1'
            #going down
            if solvemaze(r+1, c):           
                return True
            #going right
            if solvemaze(r, c+1):           
                return True
            #going up
            if solvemaze(r-1, c):           
                return True
            #going left
            if solvemaze(r, c-1):         
                return True
            #backtracking
            solution[r][c] = 1
            
            return False
        return 0

    if(solvemaze(row,col)):
        #print('True')
        return True
    else:
        #print('False')
        return False

    pass


#user defined funcation you can remove it if you want
def read_matrix_from_file(file_name):

    t = open(str(file_name), 'r').readlines()
    i=1
    c = 0
    dc = 0
    var2 = (t[c])

    mazelists = []

    while i != 0:        
        #print('\nt: ',t[c]) 
        var = int(t[c])
        #print('start: ',dc)
        #print('end:   ',var2)
        rows = int(var2)
        count = int(dc)
        
        mazelist = []
        while count <= int(var2):
            count += 1
            list1 = []
            try:
                for char in t[count]:
                    if char != '\n':
                        list1.append(char)
                if len(list1) != 0:
                    mazelist.append(list1)
                #print(t[count])
            except:
                print('')
        mazelists.append(mazelist)
            
            
        i = dc+int(t[c])+2
        #print("i: ",i)
        
        dc = dc+int(t[c])+2
        #print('dc: ',dc)
        var2 = dc
        c = i
        i = var
        try:
            var2 = dc+int(t[c])
        except:
            print("")
    
    return mazelists


def show_menue():
    print('1: fill_matrix ')
    print('2: print_matrix ')
    print('3: find_start ')
    print('4: at_end ')
    print('5: valid_move ')
    print('6: find_exit')
    print('7: Exit')



def main() -> None:

    file_name = 'input0.txt'

    #file_name = input('Enter File name in which there are metrixs: ')
    lists = read_matrix_from_file(file_name)
    
        


    var = 0
    while var != 7:
        show_menue()
        var = int(input("Enter number from 1-7 for particulat funcation: "))
        while var<1 or var>7:
            var = int(input("Please enter valid number from 1-7 for particulat funcation: "))
        
        if var == 1:
            matrix_no  = int(input('Enter matrix number you want to fill: '))
            matrix_row = int(input('Enter matrix rows: '))
            fill_matrix(lists[matrix_no], matrix_row)
            pass
        
        elif var == 2:
            matrix_no  = int(input('Enter matrix number you want to print: '))
            print_matrix(lists[matrix_no])
            pass

        elif var == 3:
            matrix_no  = int(input('Enter matrix number whose start you want to find: '))
            matrix_row = int(input('Enter matrix rows: '))
            l = find_start(lists[matrix_no], 4)
            print('row: ',l[0],' col: ',l[1])
            pass

        elif var == 4:
            matrix_no  = int(input('Enter matrix number whose end you want to reach: '))
            x = int(input('Enter x axix w.r.t 0: '))
            y = int(input('Enter y axix w.r.t 0: '))
            

            True_False = at_end(lists[matrix_no], x, y)

            if(True_False == True):
                print('True')
            else:
                print("False")

            pass

        elif var == 5:
            matrix_no  = int(input('Enter matrix number whose valid move you want to check: '))
            x = int(input('Enter x axix w.r.t 0: '))
            y = int(input('Enter y axix w.r.t 0: '))
            direction  = input('Enter direction in which you want to move in captile: ')
            
            True_False = valid_move(lists[matrix_no],  x, y, direction)

            if(True_False == True):
                print('True')
            else:
                print("False")

            pass
        elif var == 6:
            matrix_no  = int(input('Enter matrix number whose Exit you want to find: '))
            x = int(input('Enter x axix w.r.t 0: '))
            y = int(input('Enter y axix w.r.t 0: '))
            
            True_False = find_exit(lists[matrix_no], x, y)

            if(True_False == True):
                print('True')
            else:
                print("False")
            pass
        else:
            exit()
        
  
    
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
