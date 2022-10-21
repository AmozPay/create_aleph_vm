#!/bin/sh

set -a
source ./.env
set +a

# export TF_LOG=DEBUG

if [[ "$DIGITAL_OCEAN_TOKEN" == "" ]];
then
	echo "value DIGITAL_OCEAN_TOKEN missing in .env"
	exit 1
fi

if [[ "$PROJECT_NAME" == "" ]];
then
	echo "value PROJECT_NAME missing in .env"
	exit 1
fi

if [[ "$DIGITAL_OCEAN_SSH_KEY_ID" == "" ]];
then
	echo "value DIGITAL_OCEAN_SSH_KEY_ID missing in .env"
	exit 1
fi

if [[ "$DOMAIN_NAME" == "" ]];
then
	echo "value DOMAIN_NAME missing in .env"
	exit 1
fi

if [[ "$CERTIFICATE_EMAIL" == "" ]];
then
	echo "value CERTIFICATE_EMAIL missing in .env"
	exit 1
fi

TERRAFORM_VARS="-var ssh_key_id=$DIGITAL_OCEAN_SSH_KEY_ID -var digitalocean_token=$DIGITAL_OCEAN_TOKEN -var domain=$DOMAIN_NAME -var project_name=$PROJECT_NAME"

if [[ $SUBDOMAIN != "" ]];
then
	TERRAFORM_VARS="$TERRAFORM_VARS -var subdomain=$SUBDOMAIN"
fi

if [[ $DIGITAL_OCEAN_REGION != "" ]];
then
	TERRAFORM_VARS="$TERRAFORM_VARS -var region=$DIGITAL_OCEAN_REGION"
fi

if [[ $DROPLET_SIZE != "" ]];
then
	TERRAFORM_VARS="$TERRAFORM_VARS -var size=$DROPLET_SIZE"
fi

cd terraform
terraform init
terraform apply -auto-approve $TERRAFORM_VARS | tee terraform_log.txt

cd ..
IPV4_ADDRESS="$(tail -n 1 ./terraform/terraform_log.txt | cut -d ' ' -f 3)"

echo -ne "[default]\n$IPV4_ADDRESS	ansible_ssh_private_key_file=$HOME/.ssh/id_rsa ansible_user=root\n" | sed 's/"//g' > ansible/hosts.txt

echo -ne "certificate_email: $CERTIFICATE_EMAIL\ndomain_name: vm.$DOMAIN_NAME\ndigitalocean_token: $DIGITAL_OCEAN_TOKEN\n" > ansible/vars.yml

cd ansible
ansible-galaxy install -r requirements.yml
ansible-playbook playbook.yml -K -i ./hosts.txt
