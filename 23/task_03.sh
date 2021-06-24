#!/bin/bash
cat cars.txt | sed '/today/d' # It will print all the contents of the files excluding those lines starting with "today" word