for f in $@
do
  test -d $f && {
    echo "Skipping: directory '$f'"
    continue
  }

  date=$(exiftool $f | grep 'Date/Time Original' |
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
