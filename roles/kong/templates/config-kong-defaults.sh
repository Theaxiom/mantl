export api=${api:-mockbin}
export kong_url=${kong_url:-kong.service.consul}
export kong_admin_port=${kong_admin_port:-7172}
export kong_api_port=${kong_api_port:-7173}
export kong_user=${kong_user:-kbroughton}
export kong_id=${kong_id:-kbroughton_id}

#export galileo_service_token=${galileo_service_token:-6cc01000f16711e58a107162457d4292}
export galileo_service_token=${galileo_service_token:-545ad510f6c411e5a9f8a1803ae92d0d}
export galileo_environment=${galileo_environment:-kbroughton}

export runscope_bucket_key=${runscope_bucket_key:-cphu6n1nv6ip}
export runscope_bucket_name=${runscope_bucket_name:-kbroughton}
export runscope_user=${runscope_user:-kbroughton}
export runscope_gateway_url=${runscope_gateway_url:-https://${kong_url}:${kong_port}/${api}-cphu6n1nv6ip.runscope.net/path/}
export runscope_hostname=${runscope_hostname:-https://${kong_url}:${kong_port}/path/${api}}
export runscope_client_id=${runscope_client_id:-4e306c7d-c1ee-46a1-9c7c-b4f7b445dad3}
export runscope_client_secret=${runscope_client_secret:-cfbbee6e-36c9-4c7d-8bb9-2e03fda7d4fd}
export runscope_auth_url=https://www.runscope.com/signin/oauth/authorize
export runscope_auth_token_url=https://www.runscope.com/signin/oauth/access_token
export runscope_access_token=${runscope_access_token:-7846069e-97c0-4906-9867-7802cef82760}
export runscope_gateway_url=${runscope_gateway_url:-https://k4b4-mantl-c1-io-cphu6n1nv6ip.runscope.net/elasticsearch/}


################################## CONSUMERS ########################

export consumer_username=${consumer_username:-kbroughton}
export consumer_key=${consumer_key:-kbroughton_key}
export consumer_id=${consumer_id:-9aa39e07-d431-4694-86bc-fa2dece6c595}
export consumer_token_id=${consumer_token_id:-4760cd54-459b-43ea-b92f-0c1a57f14cf6}

export rate_limit_minute=${rate_limit_minute:-3}
export rate_limit_hour=${rate_limit_hour:-180}
