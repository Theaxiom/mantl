#!/bin/sh
# {{ ansible_managed }}
FIRST=true
echo -n {\"disk_util_percent\": {
df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print "\""$1"\"" ": " $5 }' | sed s/%// | while read output;
do
  if [[ $FIRST == "true" ]];then
     echo -n $output
     FIRST=false
  else
     echo -n ", $output"
  fi
done
echo }}