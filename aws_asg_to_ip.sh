#!/usr/bin/env sh
# This script will take an AWS Auto-Scaling Group Name Tag and return the ip of the first
# running instance it finds.  The intent is that you alias it as follows:
# alias ip=~/location/dir/aws_asg_to_ip.sh
#
# it prints error messages and returns non-zero if there are no instances
# available.
#
# if the --test option is set, then the script will expect $2 to be the
# name of a file containing json similar to that output by the aws ec2
# describe-instances command.
#

case $1 in
  --test|--t*)
    cmd="cat $2"
    ;;
  *)
    cmd="aws ec2 describe-instances --filters Name=tag:Name,Values=$1"
    ;;
esac

eval $( $cmd |
        jq '.Reservations[].Instances[] | .PublicIpAddress,.State.Name' |
        awk '/^null/{ next }
             /^.[0-9]/{ ip=$0; next }
             /^.[a-z]/{ last_status=$0
                        if ($0 == "\"running\"") { saved_ip = ip; saved_status=$0}
                      }
             END {if (saved_ip)
                   { printf "ip=%s status=%s\n", saved_ip, saved_status }
                  else
                   { printf "ip=none status=%s\n", last_status }
            }')

  case $status in
    running)
      ;;
    stopped|terminated)
      echo 2>&1 "?no running instances ($status)"
      ;;
    "")
      echo 2>&1 "? no instances found"
      exit 1
      ;;
    *)
      echo 2>&1 "? instance(s) in unexpected state $(status)"
      exit 2
      ;;
  esac
  case $ip in
    "null"|"" )
      ;;
    *)
      echo $ip
      ;;
  esac
  exit 0

