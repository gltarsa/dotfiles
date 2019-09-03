#! /bin/bash
# dl-blame.sh
#
# Scan the dataloader container log and distill all the pertinent ERRORS and WARNINGS,
# plus a report showing the likely perpetrator for each problem area.o
#
# This will use the DATASETS_DIR environments variable as the home of the datasets files
# for svn ownership purposes if that is set.  "../data" otherwise.
#
nl='
'
tmpfile=/tmp/dl-blame$$.tmp
tmpscript=/tmp/dl-blame-person$$.sh

case "$DATASETS_DIR" in
  "") svn_dir=$(dirname $0)/.. ;;
  *) svn_dir=$DATASETS_DIR ;;
esac

repo_root=$(cd $svn_dir && svn info --show-item repos-root-url 2> /dev/null)
if test -z "$repo_root" -o "$(basename $repo_root 2> /dev/null)" != "datasets"
then
  echo 1>&2 "?Unable to determine blame because $svn_dir was not found."
  echo 1>&2 " Set the DATASETS_DIR environment variable to the proper svn repo directory."
  exit 1
fi

trap 'rm $tmpfile $tmpscript' 0

# Build an ad-hoc script that will identify the engineer who last touched the first line
# It expects to filter an input stream where each line has 5 arguments:
#    1. svn repo dir path
#    2. File name (unused)
#    3. line number (surrounded by colons)
#    4. ERROR/WARNING (i.e., message type)
#    5. text of message
# And then output a "blame line" for that line
cat <<-'EOF' > $tmpscript
  #! /bin/bash
  svn_dir=$1
  basefile=$3
  tab="	" # tab character, inserted with ^V^T
  linenum=`echo "$4" | sed 's/://g'`
  shift; shift; shift; shift
  echo "--"
  echo "$*"
  echo "$basefile, line $linenum":
  svn blame --verbose "$svn_dir/$basefile" | cat -n | grep " `echo $linenum | sed 's/://g'`$tab"
EOF

chmod +x $tmpscript

echo "All Errors and Warnings:"

# Note we key in on ERROR/WARNING lines containing embedded line numbers (:[0-9][0-9]*:),
# others are ignored.  Then we distill into relevant lines, split those to put file and
# linenums in separate cols, awk them into presentable format, and save _the first
# error/warning in each file_ in a tmp file for later display.
#
# This is the Principal of Last-Touch Ownership, the assumption is that the owner of the
# first error in a file owns them all :-)
docker logs dataloader 2>&1  |
  egrep "ERROR:|WARNING:.*:[0-9][0-9]*:" |
  sed '
       s/^WARNING:\(.*\)\(:[0-9][0-9]*:\)/\1 \2 WARNING:/
       s=ateb-deploy/datasets/=& =
       s=:[0-9][0-9]*:= & =
      ' |
  awk '
       BEGIN      { file = "" }
       $2 != file { file = $2; print $0 }
      ' > $tmpfile

cat $tmpfile

echo "=======================${nl}Blame summary  (one entry per file, to keep it uncluttered)"

test -s $tmpfile || {
  echo >&2 "No errors found; no one to blame"
  exit 0
}

cat $tmpfile | xargs -L 1 $tmpscript $svn_dir
exit 1
