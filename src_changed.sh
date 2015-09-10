#!/bin/sh
#
# Use git ls-tree + git blame to scan all the lines in the repository branch specified
# and count how many lines are owned by Greg Tarsa.
#
# Display a list of those files ordered by the files with largest number of changes.
#
count=0

case "$1" in
  "" )
    echo 1>&2 "?Argument required: branch name"
    exit $1
    ;;
esac

branch="$1"

# filtering out pkg-config-[0.23] is a hack for the Decks project.  No more Decks?  Delete the grep filter.
files=`git ls-tree -r --name-only $branch | grep -v "pkg-config-"`

for i in $files
do
  count=`git blame $i | grep Greg | wc -l `
  test $count -ne 0 && {
    echo "$count : $i"
  }
done | sort -r
