#!/bin/bash
docker_compose_home=~/src/work/dc
dc_filename_default=docker-compose.yml
dc_filename_prefix=docker-compose.
dc_filename_suffix=.yml
myxtmpfile=/tmp/start-myx$$
debug=false

trap "test -f $myxtmpfile && rm $myxtmpfile" 0

Usage="$0 [--help] [-c|--container container-list] [version-string]

    version-string is an optional string used to specify a different docker-compose file.
    It will be used to generate a file name of the form:
              ${dc_filename_prefix}'version-string'${dc_filename_suffix}

    Default filename is ${dc_filename_default}

    Options:
      --help       display this message
      --container  restart the given container list, typically just 'myx'.  This
                   option is not fully implemented.  Stick with just 'myx'.
"
#
# This restarts all of my local containers.  There may be more efficient ways to do this
# but this way works consistently
containers=`docker ps -a --format '{{.Names}}'`
case $1 in
  --help)
    echo 1>&2 "? ${Usage}"
    filespec=${docker_compose_home}/${dc_filename_prefix}
    echo 1>&2 "    Known suffixes are:" $(echo ${filespec}* | sed "s=${filespec}==g;s=.yml==g")
    exit 2
    ;;

    # Simplistic processing.  If we have this flag, we assume we are not asking for help
    # as well.
  -c|--co*)
    shift
    containers=$1
    shift
esac

version=$1
case $# in
  0) docker_compose_filename=$dc_filename_default ;;
  1) docker_compose_filename=${dc_filename_prefix}$version${dc_filename_suffix}
     full_name=${docker_compose_home}/${docker_compose_filename}
     test -r ${full_name} ||
       {
         echo 1>&2 "? docker-compose file not found: ${full_name}${Usage}"
         exit 1
       }
     ;;

  *) echo 1>&2 "? ${Usage}"
     exit 2
     ;;
esac

case $debug in
  true) say 'Debugging' ;;
esac

say "${version:-"default"}"  # if version is not set, say "default"

echo "Restarting [#{containers}] using $docker_compose_home/$docker_compose_filename"

echo `date +'%D %I:%M%p'`: Operating on these containers: $containers
test -z "$containers" || {
  echo "docker rm -r $containers"
  case $debug in
    false)
      docker rm -f $containers
      ;;

    *)
    echo "Debugging, so not executing 'docker rm -r $containers'"
    ;;
  esac
}
(
  cd $docker_compose_home
  case $debug in
    false)
      set -x
      docker-compose -f $docker_compose_filename up -d dataloader
      docker-compose -f $docker_compose_filename up -d myx
      docker-compose -f $docker_compose_filename up -d obcgui
      set +x
      ;;

    true)
      echo "Debugging, so not executing"
      echo "'docker-compose -f $docker_compose_filename up -d dataloader'"
      echo "'docker-compose -f $docker_compose_filename up -d myx'"
      echo "'docker-compose -f $docker_compose_filename up -d obcgui'"
      ;;
  esac
)

case $containers in
  *dataloader*)
    echo "Waiting for dataloader startup to finish. . ."
    last_msg="Sleeping forever to keep this container alive..."
    seconds=0
    pause=15
    # NOTE: consider changing code to spawn N bkg jobs that exit when $last_msg is displayed and do a wait on the result
    while true
    do
      test "$(docker logs --tail 1 dataloader 2>&1)" = "$last_msg" && break
      seconds=$((seconds + $pause))
      sleep $pause
      echo -ne "$(($seconds / 60)) min, $(($seconds % 60)) seconds  \r"
    done

    # grep '00_prod_ddl.sqitch sqitch runner failed:' && {
    #   say 'Failed due to skitch problem. Restarting'
    #   exec $0 $@
    # }

    echo ""
    say "Data loaded"
    exit 0
    ;;

  myx)
    say "mix restart" # mispelled for correct pronunciation
    echo "Waiting for myx startup to finish. . ."
    last_msg="Sleeping forever to keep this container alive..."
    seconds=0
    pause=15
    while true
    do
      test "$(docker logs --tail 1 myx 2>&1)" = "$last_msg" && break
      seconds=$((seconds + $pause))
      sleep $pause
      echo -ne "$(($seconds / 60)) min, $(($seconds % 60)) seconds  \r"
    done
    echo ""
    echo "Myx container has booted"

    # Once started, it takes time for myx to be ready for business.
    # So, this code waits for the "open" sign to appear
    ping_count=0
    while true
    do
      curl -S localhost:18181/cxf/api/pmap/ping > $myxtmpfile 2>&1
      case $? in
        0)   # success...we are up and running
          break ;;
        52)  # empty reply from server...try again
          count=$(($count + 1))
          test $count -ge 20 && {
            echo 1>&2 "?Myx does not seem to have come up properly"
            say "Mix not started"
            exit 2
          }
          ;;
        *)
          echo 1>&2 "? Unexpected return from curl/ping:"
          cat 1>&2 $myxtmpfile
          break ;;
      esac
      seconds=$((seconds + $pause))
      sleep $pause
      echo -ne "$(($seconds / 60)) min, $(($seconds % 60)) seconds  \r"
    done
    echo ""

    say "Mix service restarted"
    exit 0
    ;;

  "obcgui myx ateb-amq identity")
    echo 1>&2 "== restarting with 'quick' db"
    echo 1>&2 "Wait for a bit to see if the db comes up properly"
    echo 1>&2 "When a pattern is clear, add a check to this code."
    ;;

  *)
    echo 1>&2 "?? Unexpected value for containers list: '$containers'"
    exit 1
    ;;

  esac
