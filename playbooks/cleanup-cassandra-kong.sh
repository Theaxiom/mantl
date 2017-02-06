base_url=https://k4b4-mantl-control-01.node.c1.io
creds=admin:FlotsamJotsam33
curl -sku $creds -X DELETE -d "{\"name\": \"cassandra\"}"  ${base_url}/api/1/install
