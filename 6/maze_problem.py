from math import sqrt


class Seat:
    def __init__(self, x, y):
        self.x = x
        self.y = y
        self.allocated = 0


def calculate_distance(x_one, y_one, x_two, y_two):
    # calculate euclidean distance
    # O(1) complexity
    return sqrt((x_two - x_one) ** 2 + (y_two - y_one) ** 2)


# reads the instance data from test_instance.txt

def read_data():
    data = []  # O(1)
    with open("test_instance.txt", "r") as file:  # O(1)
        file.readline()  # O(1)
        for line in file.readlines():  # O(n) + 1
            chunk = line.strip().split('\t')  # O(n)
            data.append(Seat(int(chunk[1]), int(chunk[2])))  # O(n)
    return data  # O(1)


# gets count of filled seats

def get_filled_seats(seats):
    count = 0  # O(1)
    for seat in seats:  # O(n) + 1
        if seat.allocated == 1:  # O(n)
            count += 1  # O(n)
    return count  # O(1)


# arrange the seats based on the euclidean distance between two seats and beta_value

def arrange_seats(seats, beta_value):
    previous_allocated = seats[0]  # O(1)
    for i in range(1, len(seats)):  # O(n)
        if calculate_distance(previous_allocated.x, previous_allocated.y, seats[i].x,
                              seats[i].y) > beta_value:  # O (n) - 1
            seats[i].allocated = 1  # O(n) - 1
            previous_allocated = seats[i]  # O(n) - 1


# swap the allocated seats and non-allocated

def swap_allocated_seats(seats):
    for seat in seats:  # O(n) + 1
        if seat.allocated == 1:  # O(n)
            seat.allocated = 0  # O(n)
        else:  # O(n)
            seat.allocated = 1  # O(n)


# reset seat objects for next beta value testing

def reset_data(data):
    for seat in data:  # O(n) + 1
        seat.allocated = 0  # O(n)


beta_values = [100, 120, 140, 160, 180, 200]
data = read_data()

for beta_value in beta_values:  # O(n) + 1
    arrange_seats(data, beta_value)  # O(n)
    print("beta = " + str(beta_value) + " , Total Allocated Seats: " + str(get_filled_seats(data)))  # O(n)
    swap_allocated_seats(data)  # O(n)
    print("beta = " + str(beta_value) + " , Total Allocated Seats after swap: " + str(get_filled_seats(data)))  # O(n)
    reset_data(data)  # O(n)
