echo "LIST CONSUMERS"
curl $KONG_VERBOSE -X GET http://${kong_url}:${kong_admin_port}/consumers/

echo "GET TOKEN FOR CONSUMER ${consumer_username}"
echo "curl $KONG_VERBOSE -X POST http://${kong_url}:${kong_admin_port}/consumers/${consumer_username}/key-auth"
curl $KONG_VERBOSE -X POST http://${kong_url}:${kong_admin_port}/consumers/${consumer_id}/key-auth
