#!/bin/bash

cat /dev/urandom | gzip -9 | gzip -d | gzip -9 | gzip -d > /dev/null
