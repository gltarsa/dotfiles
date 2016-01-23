#! /bin/sh
#
# Filter to remove an Exchange Forward header from an incoming message and
# store the result in the specified folder as a new message.
# Modification History
# ~~~~~~~~~~~~~~~~~~~~
# 01 Greg Tarsa, July 1999
#    Wrote original code.
#

# Verify # of arguments
case $# in
    1) folder=$1; break;;
    *) echo 1>&2 "? Usage: joke-store.sh +foldername"; exit 0;;
esac

# ensure that the folder has an starting "+"
case $folder in
    +*) ;;
    *) folder="+$folder" ;;
esac

# First, delete all lines up to, and including, "Blind-Carbon-Copy"
# Then, delete the first line of what remains, if it is blank.
# Store what is left in the specified folder
sed '	1,/------- Blind-Carbon-Copy/d' |
	sed '1{
		    /^[ 	]*$/d
	      }
	      /------- End of Blind-Carbon-Copy/d
	      /- ------- Forwarded Message/d
	      /- ------- End of Forwarded Message/d
	      ' |
	uniq |
	/usr/lib/mh/rcvstore $folder


