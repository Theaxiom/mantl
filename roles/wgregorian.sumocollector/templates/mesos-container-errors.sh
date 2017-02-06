#!/bin/sh

# mesos-container-errors.sh
# {{ ansible_managed }}

#/usr/bin/journalctl -u docker --since "{{ sumologic_mesos_error_seconds }} seconds ago" --no-pager

/usr/bin/journalctl --since "{{ sumologic_mesos_error_seconds }} seconds ago" -o json | jq -c '. | select(._COMM | . and contains ("docker")) | {"__REALTIME_TIMESTAMP":.__REALTIME_TIMESTAMP,"C12E_SOURCE":"{{deployment_id}}/infra/mesos","CONTAINER_TAG":.CONTAINER_TAG, "_HOSTNAME":._HOSTNAME,"MESSAGE":."MESSAGE", "CONTAINER_ID":.CONTAINER_ID,"CONTAINER_NAME":.CONTAINER_NAME}' | grep "ERR"