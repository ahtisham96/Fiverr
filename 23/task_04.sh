#!/bin/bash
cat cars.txt  | sed '/^$/d'  # It will shows all the contents of the files by removing empty lines
