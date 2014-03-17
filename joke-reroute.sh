#! /bin/sh
#
# Filter to remove an Exchange Forward header from an incoming message and
# store the result in the +inbox folder as a new message.
#
# Assumes that the message is embedded as a MSFT attachment.
#
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

# First, delete all lines up to, and including, "Original Message"
# Then, delete the first line of what remains, if it is blank.
# Fix any multi-line "to:" entries.
# Store what is left in the +jokes folder

sed '	1,/^-----Original Message/d' |
	sed '1{
	      s/\[mailto:/</
	      s/]/>/
	      }
	     2,5s/^Sent/Date/' |
	sed '/^To:/,/^Subject:/{
		/^Subject:/b end
		s/; $//
		/^To:/n
		s/^/To: /
	    }
	    : end' |
       sed '/^To: Subject:/,$s/^To: //' |
       /usr/lib/mh/rcvstore $folder

#sed '1,/^[ 	]*$/d' |
#	uniq |
#	/usr/lib/mh/rcvstore $folder

#mark it for reading
mark $folder -add -seq unseen last
true
