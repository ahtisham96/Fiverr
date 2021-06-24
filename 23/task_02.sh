#!/bin/bash
awk '$5 >= 5000 {print} ' cars.txt # It will display all the lines where price > $5000