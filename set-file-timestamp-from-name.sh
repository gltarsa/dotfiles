for f in *.jpg
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

    VID_*)
      # Standard Android name format: IMG_yyyymmdd_hhmmssxxx[_HDR].jpg: set date-time to the second
      date=$(printf %s "$f" | sed -E 's|^VID_(....)(..)(..)_(..)(..)(..).*|\2/\3/\1 \4:\5:\6|')
      $echo SetFile -m "$date" -d "$date" "$f" && mv "$f" "${f#* }"
      ;;

    *)
      echo >&2 "? skipping non IMG_* file: $f"
      ;;
  esac
done
