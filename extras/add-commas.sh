#!/bin/bash
# add commas to any appropriate block of numbers in the standard input stream
# got this from the web, need to figure out why it works
sed -e ': L
s/\([0-9]\{1,19\}\)\([0-9]\{3\}\)/\1,\2/
t L'
