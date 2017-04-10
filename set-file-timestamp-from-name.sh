for f in *.jpg
do
  # Assumed file name format
  # IMG_20160415_095410983.jpg
  # \1 = year
  # \2 = mm
  # \3 = dd
  # \4 = hh
  # \5 = mm
  case $f in
    IMG_*)
    date=$(printf %s "$f" | sed -E 's|^IMG_(....)(..)(..)_(..)(..).*|\2/\3/\1 \4:\5|')
    SetFile -m "$date" -d "$date" "$f" && mv "$f" "${f#* }"
    ;;
  *)
    echo >&2 "? skipping non IMG_* file: $f"
    ;;
  esac
done
