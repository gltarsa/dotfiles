#! /bin/sh
#
# Modification History
# ~~~~~~~~~~~~~~~~~~~~
# 02 Sep-98, Greg Tarsa
#	Changed "Fax:" to "f:"
#
# 01 Jun-98, Greg Tarsa
#	Wrote original code
#
Usage='Usage:
	rotary_reminder -m[ail] -f[ax] file

	Generates a Rotary reminder list for all late submittors from
	        $HOME/pc/data/csd spreadsheets/<file>

	-a causes all three reports to be generated.

	-m causes all unreporting mail addresses to be sent to stdout
	   addresses containing "?" characters will be filtered out.

	-f causes all unreporting fax numbers

	-r causes the specified file to be printed raw to stdout.

	-t or -p causes all unreporting secretaries for which no e-mail or
	   fax can be found to be sent to stdout.
'
nl='
'

filehome="$HOME/pc/data/csd spreadsheets/"
#filehome=""

#
# set default behavior
#


case $# in
    0) echo 1>&2 "?Invalid number of arguments$nl$Usage"; exit 1 ;;
esac

while : true
do
    case $1 in
	-a* ) fax_flag="TRUE" mail_flag="TRUE" phone_flag="TRUE" ;;
	-d*)  debug_flag="TRUE" ;;
	-f*) fax_flag="TRUE" ;;
	-m*)  mail_flag="TRUE" ;;
	-r*) raw_flag="TRUE" ;;
	-p*|-t*) phone_flag="TRUE" ;;
	-*) echo 1>&2 "?Invalid flag specified: $1$nl"; err_flag=TRUE ;;
	*) break ;;
    esac
    shift
done

case $# in
    1) filename=$1;;
    *) echo "?Invalid number of arguments$nl"; err_flag="TRUE" ;;
esac

case $err_flag in
    TRUE) echo 1>&2 "$Usage"; exit 1 ;;
esac

case $debug_flag in
    TRUE) set -x ;;
esac

case $fax_flag$mail_flag$phone_flag in
    "" ) fax_flag="TRUE";mail_flag="TRUE";phone_flag="TRUE" ;;
esac

file="${filehome}${filename}"

case $debug_flag in
    TRUE) test -f "$file" && echo 1>&2 "File was found" ;;
esac

test -f "$file" ||
    {
    echo 1>&2 "?$file not found or not a plain file"
    exit 1
    }

#
# Format of the record is (spaces within quotes are significant):
#  <data><tab>"f: fax-num [e-mail-addr] secy-name+club-name"
#
# fax-num & e-mail-addr can potentially be null
#
# mail_flag prints all non-null e-mail-addr fields
#
# fax_flag  prints all non-null fax-num fields having null e-mail-addr fields
#
# phone_flag prints all secy-name+club-name fields having null fax and
#            e-mail fields.
#

case $mail_flag in
    TRUE*)
        echo "${nl}E-mail addresses of non-reporting secretaries:"
	echo
        # new way, resulting in 'To: <addr> "name, club"'
	sed	'/]/!d
		s/^.*\[/\</
		s/] /\> "/
		/.*<.*\?.*>.*/d
		/<>/d
		s/(.*)//
		s/^/To: /
	' "$file"
       # old way, resulting in addresses only
#	sed	'/]/!d
#		s/^.*\[//
#		s/].*//
#		/^[	 ]*$/d
#		s/$/, /
#	' "$file"
	;;
esac


case $fax_flag in
    TRUE*)
        case $mail_flag in
	   TRUE*)
	      echo "${nl}Fax numbers of non-reporting secretaries (w/o email):"
	      echo
	      sed	'/\[]/!d' "$file" ;;
	   *)
	      echo "${nl}Fax numbers of all non-reporting secretaries:"
	      echo
	      cat "$file" ;;
	esac |
        sed	'1,3p
		/f:  \[/d
		/f:/!d
 		s/.*f: //
		s/\[.*] /  /
		/^[	 ]*$/d'
	;;
esac

case $phone_flag in
    TRUE*)
        echo "${nl}Names of non-reporting secretaries (w/o email or fax):"
        sed	'/\[]/!d
		/f:/!d
 		s/.*f: //
		/[0-9] \[/d
		s/ \[] //
		s/"//g
		/^[	 ]*$/d

	' "$file"
	;;
esac

case $raw_flag in
    TRUE) cat "$file" ;;
esac

