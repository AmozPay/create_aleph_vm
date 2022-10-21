# Aleph vm
Automatically create a machine on digital ocean and deploy an Aleph Vm on it.

## Requirements

- A Digital Ocean account, with your domain name record on it
- Install Terraform and Ansible
- Your `.env` at the root of the repository, based on `.env.example`


## Usage

Running `./scripts/create_aleph_vm.sh` will:
- Create a machine using terraform
- Create corresponding A records for your domain name
- Install and run the latest aleph-vm release on your machine
- Create ssl certificates
- Install caddy, set it up and run it as a reverse proxy

## Uninstall

You can destroy simply your machine with `./scripts/destroy_aleph_vm.sh`