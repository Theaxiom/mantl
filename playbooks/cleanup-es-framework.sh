export creds='admin:FlotsamJotsam33'
export url=https://k4b4-mantl-control-01.node.c1.io
export control_node=k4b4-mantl-control-01.node.c1.io

# remove scheduler from marathon
curl -sku $creds -XDELETE $url/marathon/v2/apps/elasticsearch

# find the mesos framework id
frameworkId=$(curl -sku $creds $url/api/1/frameworks | jq -r '.[] | select(.name == "elasticsearch") | .id')

# remove the mesos framework
curl -sku $creds -XDELETE $url/api/1/frameworks/$frameworkId

# clean up mesos framework state from zookeeper
ansible $control_node -s -m shell -a 'zookeepercli -servers zookeeper.service.consul -force -c rmr /elasticsearch'

# delete all elasticsearch data (optional)
ansible 'role=worker' -s -m shell -a 'rm -rf /data'
