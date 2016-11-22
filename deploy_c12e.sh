
# eg. $1 = ../ansible-cognitivecloud/deploy_vars/galaxy/k9b9/k9b9.yml

ansible_cognitive_config_dir=${1}

ansible-playbook -i plugins/inventory/terraform.py addons/elk.yml -e @security.yml -e @${ansible_cognitive_config_dir}
ansible-playbook -i plugins/inventory/terraform.py playbooks/c12e_customize.yml -e @security.yml -e @${ansible_cognitive_config_dir}

