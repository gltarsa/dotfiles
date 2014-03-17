#/bin/bash
egrep -v "dhclient: *last|dhclient: *DHCPREQ|FTP *session [oc]|connect from|postfix/anvil|CRON" syslog

