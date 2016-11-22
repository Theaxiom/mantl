#!/bin/bash

function handle_input {
  if [[ $1 == 'q' ]];then
    exit 0
  elif [[ $1 == "" ]];then
    echo "continuing..."
    echo ""
  else
    echo "please type q to quit or enter to continue"
    read input
    handle_input $input
  fi
}

function get_input {
echo "enter 'q' to quit, 'enter' to continue"
read input
handle_input $input
}

# register galileo plugin with api
echo "curl -X POST http://${kong_url}:${kong_admin_port}/apis/${api}/plugins/ \
    --data \"name=mashape-analytics\" \
    --data \"config.service_token=${galileo_service_token}\" \
    --data \"config.environment=${galileo_environment}\" "

curl -X POST http://${kong_url}:${kong_admin_port}/apis/${api}/plugins/ \
    --data "name=mashape-analytics" \
    --data "config.service_token=${galileo_service_token}" \
    --data "config.environment=${galileo_environment}"

##################### TO UPDATE #####
#curl -X PATCH http://${kong_url}:${kong_admin_port}/apis/${api}/plugins/d16be953-7dcc-4e60-9072-58e546b9025b \
#    --data "name=mashape-analytics" \
#    --data "config.service_token=${galileo_service_token}" \
#    --data "config.environment=${galileo_environment}"

get_input

# register key-auth plugin with api
echo "curl -X POST http://${kong_url}:${kong_admin_port}/apis/${api}/plugins/ \
    --data \"name=key-auth\" "

curl -X POST http://${kong_url}:${kong_admin_port}/apis/${api}/plugins/ \
    --data "name=key-auth"

get_input

# register rate-limiting plugin with api
echo "curl -X POST http://${kong_url}:${kong_admin_port}/apis/${api}/plugins/ \
    --data \"name=rate-limiting\" \
    --data \"config.minute=30\" \
    --data \"config.hour=500\" "

curl -X POST http://${kong_url}:${kong_admin_port}/apis/${api}/plugins/ \
    --data "name=rate-limiting" \
    --data "config.minute=100" \
    --data "config.hour=1000"

get_input


# register external galileo plugin with api
echo "curl -X POST http://${kong_url}:${kong_admin_port}/apis/${api}/plugins/ \
    --data \"name=mashape-analytics\" \
    --data \"config.service_token=${galileo_service_token}\" \
    --data \"config.environment=${galileo_environment}\" "

curl -X POST http://${kong_url}:${kong_admin_port}/apis/${api}/plugins/ \
    --data "name=mashape-analytics" \
    --data "config.service_token=${galileo_service_token}" \
    --data "config.environment=${galileo_environment}"

get_input

# register ip-restriction with api
#curl -X POST http://${kong_url}:${kong_admin_port}/apis/${api}/plugins \
#    --data "name=ip-restriction" \
#    --data "config.whitelist=54.13.21.1, 143.1.0.0/24"

# register ssl plugin with api
if [[ ${kong_do_ssl} == 'yes' ]];then

  echo "curl -X POST http://${kong_url}:${kong_admin_port}/apis/${api}/plugins \
    --form \"name=ssl\" \
    --form \"config.cert=@/path/to/cert.pem\" \
    --form \"config.key=@/path/to/cert.key\" \
    --form \"config.only_https=true\" "

  curl -X POST http://${kong_url}:${kong_admin_port}/apis/${api}/plugins \
    --form "name=ssl" \
    --form "config.cert=@/path/to/cert.pem" \
    --form "config.key=@/path/to/cert.key" \
    --form "config.only_https=true"
else
  echo "skipping ssl"
fi

# register runscope with api
echo " curl -X POST http://${kong_url}:${kong_admin_port}/apis/${api}/plugins/ \
    --data \"name=runscope\" \
    --data \"config.bucket_key=cphu6n1nv6ip\" \
    --data \"config.access_token=7846069e-97c0-4906-9867-7802cef82760\" "

curl -X POST http://${kong_url}:${kong_admin_port}/apis/${api}/plugins/ \
    --data "name=runscope" \
    --data "config.bucket_key=cphu6n1nv6ip" \
    --data "config.access_token=7846069e-97c0-4906-9867-7802cef82760"

