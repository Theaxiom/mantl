
echo "CREATE A CONSUMER ${consumer_username}" 
echo "curl $KONG_VERBOSE -X POST http://${kong_url}:${kong_admin_port}/consumers/ \
    --data \"username=${consumer_username}\""

curl $KONG_VERBOSE -X POST http://${kong_url}:${kong_admin_port}/consumers/ \
    --data "username=${consumer_username}" 
#    --data "custom_id=${consumer_id}"

echo "GET A KEY FOR THE CONSUMER ${consumer_username}"

echo "curl $KONG_VERBOSE -i -X POST \
  --url http://${kong_url}:${kong_admin_port}/consumers/${consumer_username}/key-auth/ \
  --data key=${consumer_key}"

curl $KONG_VERBOSE -i -X POST \
  --url http://${kong_url}:${kong_admin_port}/consumers/${consumer_username}/key-auth/ \
  --data key=${consumer_key}


echo "REGISTER RATE-LIMITING PLUGIN WITH API"
echo "curl $KONG_VERBOSE -X PATCH http://${kong_url}:${kong_admin_port}/apis/${api}/plugins/${consumer_id} \
    --data \"name=rate-limiting\" \
    --data \"config.minute=${rate_limit_minute}\" \
    --data \"config.hour=${rate_limit_hour}\" \
    --data \"consumer_id=${consumer_id}\" "

curl $KONG_VERBOSE -X PATCH http://${kong_url}:${kong_admin_port}/apis/${api}/plugins/${consumer_id} \
    --data "name=rate-limiting" \
    --data "config.minute=${rate_limit_minute}" \
    --data "config.hour=${rate_limit_hour}" \
    --data "consumer_id=${consumer_id}"
