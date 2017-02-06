export api=mockbin
export kong_url=kong.service.consul
export kong_admin_port=7173
export kong_api_port=7172
export kong_user=kbroughton
export kong_id=kbroughton_id
# set KONG_VERBOSE=-v to run on debugging
export KONG_VERBOSE=

export galileo_service_token=6cc01000f16711e58a107162457d4292
export galileo_environment=kbroughton

export runscope_bucket_key=cphu6n1nv6ip
export runscope_bucket_name=kbroughton
export runscope_user=kbroughton
export runscope_project_id=cphu6n1nv6ip
export runscope_client_id=4e306c7d-c1ee-46a1-9c7c-b4f7b445dad3
export runscope_client_secret=cfbbee6e-36c9-4c7d-8bb9-2e03fda7d4fd

################################## CONSUMERS ########################

export consumer_username=kbroughton
export consumer_key=${consumer_key:-kbroughton_key}
export consumer_id=${consumer_id:-9aa39e07-d431-4694-86bc-fa2dece6c595}
export consumer_token_id=${consumer_token_id:-4760cd54-459b-43ea-b92f-0c1a57f14cf6}

export rate_limit_minute=${rate_limit_minute:-3}
export rate_limit_hour=${rate_limit_hour:-180}
