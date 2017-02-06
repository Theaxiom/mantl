#!/bin/bash

FILTERS='[{"name":"instance-id", "values":["i-0bdd70830cd1a3ac0"]}]'
TF_FILE=aws.tf.terraforming
TF_STATE_FILE=aws.tfstate.terraforming

VPC_ID=vpc-fda45199

if [[ -f ${TF_FILE} ]];then
    rm ${TF_FILE}
fi

if [[ -f ${TF_STATE_FILE} ]];then
    rm ${TF_STATE_FILE}
fi

touch ${TF_FILE}
touch ${TF_STATE_FILE}

#bin/terraforming ec2 --filters '[{"name":"vpc_id", "values":["vpc-fda45199"]}]'

for resource in ec2 vpc eip elb igw nac nif r53r r53z rt rta s3 sg;do
  if $resource in igw nac rt rta sg;do
    TF_STATE_FILTERS="--filters '[{\"name\":\"vpc_id\", \"values\":[\"$VPC_ID\"}]'"
  terraforming $resource >> $TF_FILE
  if [[  "${resource}" == "ec2" ]];then
    terraforming $resource --tfstate > ${TF_STATE_FILE}
  else
    terraforming $resource --filters = ${FILTERS} --tfstate --overwrite --merge=${TF_STATE_FILE}
  fi
done


# ec2 tenancy default / dedicated
# vpc id vpc-fda45199 / vpc-6b32e00f
# igw vpc_id
# nac vpc_id
# nif tags 
# r53r zone_id, id, name  
# r53z vpc_id, tags, zone_id     
# rt vpc_id, tags
# rta vpc_id, tags
# sg vpc_id, tags