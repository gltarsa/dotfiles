Usage="
Usage: $0 <count> <cmd>

Action: run the specified <cmd> <count> times and write a log to status.out.
"
case $# in
  0|1) echo 1>&2 "?Usage: $Usage"; exit 1 ;;
esac

repeat=$1; shift
case $repeat in
  [0-9]|[0-9][0-9]) ;;
  *)
    echo 1>&2 "?<count> must be a number."
    exit 1 ;;
esac

cmd=$@
echo "Starting a $repeat iteration run at `date`" >> status.out
for ((i = 1; i <= $repeat; i++))
do
  echo iteration $i
  echo $@
  echo "Iteration $i: $@" >> status.out
  if $@
  then
    echo "   Iteration $i PASSED at `date`" >> status.out
  else
    echo "   Iteration $i FAILED at `date`" >> status.out
  fi
done
