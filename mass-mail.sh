#! /bin/sh
#
# Script to read a list of names and send out appropriately customized form
# letters.
#
# Modification History
# ~~~~~~~~~~~~~~~~~~~~
# 01	May-2010, Greg Tarsa
#	Adapted from peer-input script written in 1999
#
Usage='
    USAGE: mass-mail [-option] input_file

    Generate customized e-mail messages for the addressees in the input_file.

    Default is to print the e-mail to stdout.

    Options include:
	-se[nd]	  	actually send the e-mail messages.
	-d[ebug]	enable debug messages
        -su[bject] "subject line"
        -t[emplate]     path to the template file

    ----
    input file consists of data sets of a single line w/ fields
    delimited by tabs:

    <desc>\t<last>\t<first>\t<email>\t<list>

       <desc>	(unused) must be non-null
       <last>	(unused) last name of recipient
       <first>	first name of recipient
       <email>	email of recipient
       <first_para>
	        introductory paragraph (or "none")

    e-mail will be sent to each address in the list.

    The list of people you want input on should be comma delimited and
    fit in a sentence like: "I would like input on <list>."

    The format of the file lends itself to an excel spreadsheet
    written out as a tab-delimited file.
'
nl='
'

myemail="gltarsa@gmail.com"
send="no"
input_file=""
debug="no"
template_file=""
# old template_file="$HOME/templates/peer-input-request-fy08.txt"

while :
do
    # No more arguments?  All Done.
    case $# in
       0) break ;;
    esac

    # process the switches
    case $1 in
       # set the "really send" flag
       -send|-se*)
            send="yes"
	    ;;
	    
       # set the subject
       -subject|-su*)
	    shift
	    case $# in
		0) echo 1>&2 "?Subject text is missing."; exit 1
		   ;;
	    esac
            subject_line=$"1"
	    ;;
	    
       # set the debug flag
       -debug|-d*)
            debug="yes"
	    ;;
	    
       -*) echo 1>&2 "?Invalid switch: $1"; errflg=yes ;;
        *) input_file="$1"
	   ;;
    esac
    shift
done

case $input_file in
    "") echo 1>&2 "?No input file specified"; errflg=yes ;;
esac

case $template_file in
    "") echo 1>&2 "?No template file specified"; errflg=yes ;;
esac

case $subject_line in
    "") echo 1>&2 "?No subject specified"; errflg=yes ;;
esac

case $errflg in
   yes) echo 1>&2 "$Usage$nl"; exit 0 ;;
esac

if test ! -s $input_file
then
    echo 1>&2 "?data file is empty."
    errflg=yes
fi

if test ! -s $template_file
then
    echo 1>&2 "?template file, $template_file, is empty."
    errflg=yes
fi

case $errflg in
   yes) echo 1>&2 "$Usage$nl"; exit 0 ;;
esac

case $send in
    yes) echo "Mail will be sent when you hit Enter: "; read dummy ;;
esac

# remove quote marks from the file and pipe to the big filter
sed '	s/"//g
 	s/\.//g' $input_file |
while : 
do
     # read the data line, break it into arguments
     read data || break

     IFS="	"
     set $data

     desc=$1
     last=$2
     first=$3
     email="$4"
     list=`echo "$5" | sed 's///'`

     # sanity check the arguments
     case $first in "") echo 1>&2 "?first name is null: '$*'"; errflg=1;; esac
     case $email in "") echo 1>&2 "?email addr is null: '$*'"; errflg=1;; esac
     case $first_para in "") echo 1>&2 "?first_para is null: '$*'"; errflg=1;; esac
     case $errflg in
         "") ;;
	 *) break ;;
     esac

     case $debug in
        yes)
	    echo "desc= $desc"
	    echo "first last= $first $last"
	    echo "email= $email"
	    echo "list= $list"
	    echo "cmd: Mail -b $myemail -s '$subject_line' $email
	    ;;
	*)
	    # in real production, skip the header row.
	    case $first$last$desc in
	        firstlastdesc) continue ;;
	    esac
	    echo Input for: $subject_line
	    echo "${email}: \c"
	    ;;
     esac

     sed "s=+first_para+=$first_para=
	  s/+Firstname+/$first/" $template_file |
	  fmt -w 63 |
	  sed 's/^\.//' |
	  case $send in
	      yes) Mail -b $myemail -s "$subject_line" $email ;;
	      *) case $debug in yes) ;; *) more;; esac ;;
	  esac

     case $debug in
        yes) echo "------" ;;
	*)   case $send in
	         yes) echo "Sent." ;;
		 no)  echo "Not Sent." ;;
	     esac
	     ;;
     esac
     echo
done
