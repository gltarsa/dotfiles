Usage="
   $(basename $0) filenames. . .

   This will look at the name of the file for recognized patterns of name/date and attempt
   to set the file's modication/create date to that value.

   Recognized patterns ("xxxxx" and ".*" = any number of any characters)

   IMG_xxxxx_YYYYMMDD_hhmmss.*
   IMG-xxxxx_YYYYMMDD_hhmmss.*
   xxxxIMG_xxxxx_YYYYMMDD_hhmmss.*
   Resized_xxxxx_YYYYMMDD_hhmmss.*
   VID_xxxxx_YYYYMMDD_hhmmss.*
"
case $# in
  0)
    echo 2>&1 "?Usage ${Usage}"
    exit 1
    ;;
esac

for f in "$@"
do
  # Assumed file name format
  # IMG_20160415_095410983.jpg
  # \1 = year
  # \2 = mm
  # \3 = dd
  # \4 = hh
  # \5 = mm

  # echo="echo"
  echo=""
  case $f in
    IMG-*)
      # IMG-yyyymmdd-WAoooo.jpg: Turn the ordinal sequence number into a minutes after midnight value
      date=$(printf %s "$f" | sed -E 's|^IMG-(....)(..)(..)-WA0*(....)|\2/\3/\1 00:0\4|')
      $echo SetFile  -m "$date" -d "$date" "$f" && mv "$f" "${f#* }"
      ;;

    IMG_*)
      # Standard Android name format: IMG_yyyymmdd_hhmmssxxx[_HDR].jpg: set date-time to the second
      date=$(printf %s "$f" | sed -E 's|^IMG_(....)(..)(..)_(..)(..)(..).*|\2/\3/\1 \4:\5:\6|')
      $echo SetFile -m "$date" -d "$date" "$f" && mv "$f" "${f#* }"
      ;;

    *IMG_*)
      # When std Android name is prefixed: my_picture.IMG_yyyymmdd_hhmmssxxx[_HDR].jpg: set date-time to the second
      date=$(printf %s "$f" | sed -E 's|^.*IMG_(....)(..)(..)_(..)(..).*|\2/\3/\1 \4:\5|')
      $echo SetFile -m "$date" -d "$date" "$f" && mv "$f" "${f#* }"
      ;;

    Resized_*)
      # Name given by Mark for some files format: Resized_yyyymmdd_hhmmssxxx[_HDR].jpg: set date-time to the second
      date=$(printf %s "$f" | sed -E 's|^Resized_(....)(..)(..)_(..)(..)(..).*|\2/\3/\1 \4:\5:\6|')
      $echo SetFile -m "$date" -d "$date" "$f" && mv "$f" "${f#* }"
      ;;

    VID_*)
      # Standard Android name format: VID_yyyymmdd_hhmmssxxx[_HDR].jpg: set date-time to the second
      date=$(printf %s "$f" | sed -E 's|^VID_(....)(..)(..)_(..)(..)(..).*|\2/\3/\1 \4:\5:\6|')
      $echo SetFile -m "$date" -d "$date" "$f" && mv "$f" "${f#* }"
      ;;

    *)
      echo >&2 "? skipping non IMG_* file: $f"
      ;;
  esac
done
