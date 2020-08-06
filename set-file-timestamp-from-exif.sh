Usage="
   $(basename $0) filenames. . .

   This will look at the Exif values for date taken in each file and set the file's
   modication/create date to that value.
"
case $# in
  0)
    echo 2>&1 "?Usage ${Usage}"
    exit 1
    ;;
esac

for f in "$@"
do
  test -d "$f" && {
    echo "Skipping: directory '$f'"
    continue
  }

  date=$(exiftool "$f" | grep 'Date/Time Original' |
    sed 's/^.*: 2/2/g;s/ /:/' |
    awk -F: '{ printf "%s/%s/%s %s:%s:%s\n", $2, $3, $1, $4, $5, $6 }')

  case $date in
    *:*)
      echo "Setting '$f' to '$date'"
      SetFile -m "$date" -d "$date" "$f"
      ;;
    *)
      echo "Warning: no EXIF data found in '$f', found '$date'"
      ;;
  esac
done
