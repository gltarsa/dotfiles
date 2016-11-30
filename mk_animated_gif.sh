#!/bin/sh
dest=/Users/tarsa/Desktop/animated.gif
Usage="
  `basename $0` file [file ...]

  Converts the list of files into an animated gif.

  Destination is $dest.
"
case $# in
  0)
    echo >&2 "? Usage: $Usage"
    exit 1
    ;;
esac
set -x
convert -delay 20 -loop 0 $@ $dest
set +x
echo "Animated gif is at $dest"
