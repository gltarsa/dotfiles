#! /bin/sh
#
# Script to read a list of names and send out license notification letters
#
# Modification History
# ~~~~~~~~~~~~~~~~~~~~
# 01	Jul-99, Greg Tarsa
#	Wrote original code.
#

Usage='
    cpu2000lic.sh < input_file

    input file consists of data sets of 5 lines each:

    <e-mail-address>
    <firstname>
    username: <username>
    password: <password>
    <blank>

    e-mail will be sent to each person in the list.
'
nl='
'

case $# in
    0) ;;
    *) echo 1>&2 "?$Usage$nl"; exit 0 ;;
esac

while :
do
     read email || break
     error=1
     read firstname || break
     read dummy username || break
     read dummy password || break
     read blank
     error=0

     echo Sending to $email
     sed "s/+Firstname+/$firstname/
          s/+Username+/$username/
	  s/+Password+/$password/" $HOME/templates/cpu2000-kit-key.txt |
	  Mail -s "Access to CPU2000 kit" $email
     echo "--- Sent ---"
     echo
done

case $error in
    0) ;;
    *) echo 1>&2 "?Not enough data." ;;
esac











