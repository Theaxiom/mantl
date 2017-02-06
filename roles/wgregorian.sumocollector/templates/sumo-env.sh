# sumo-env.sh

# {{ ansible_managed }}

# For use with docker sumologic container

SUMO_ACCESS_ID="{{ sumologic_collector_accessid }}"
SUMO_ACCESS_KEY="{{ sumologic_collector_accesskey }}"
# also defined in /etc/sumo/sumo.conf
SUMO_COLLECTOR_NAME={{ inventory_hostname }}
{% if sumologic_single_source_file == "yes" %}
SUMO_SOURCES_JSON=/etc/sumo/sumologic-collector.json
{% else %}
SUMO_SOURCES_JSON=/etc/sumo/sumo.d
{% endif %}
SUMO_SYNC_SOURCES=true
SUMO_CLOBBER=true
SUMO_COLLECTOR_NAME_PREFIX=
