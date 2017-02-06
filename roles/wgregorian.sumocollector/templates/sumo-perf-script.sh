# sumo-perf-script.sh
# {{ ansible_managed }}

/usr/bin/sadf -T -j -s $(/bin/date -d "-4 minute" +%T) -- 1 1 -A -dp 