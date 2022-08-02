# Stake Wars III

This is a repository containing scripts and automation for NEAR StakeWars part3:

https://near.org/stakewars/

### Progress so far:

- Terraform : defined a resource using Hetzner cloud


- Ansible: defined four playbooks:
  - setup_node.yml - deploys all required packages and configurations for challenges 001-006. User then must do the near-cli parts manually (login, create pool, etc.)
  - start_node.yml - starts the validating of blocks/chunks, after registering stake pool
  - hardfork.yml - redownloads nearcore, genesis etc. Automates hard fork of shardnet
  - newbinary.yml - only recompiles nearcore to new commit

## How-To:

1. Create a Hetzner account, generate an API key through cloud panel.
2. Create a 'terraform.tfvars' file with the API key and hostname (it will be used for PTR record):
```
hcloud_token = "xxxxxxxxxxxxxxxxxxxxxxx"
server_hostname = <your hostname>
```
3. Run Terraform
4. Log into the server(root), create ansible sudo user:
```
ssh root@<server_ip>
useradd -m <youruser>
usermod -aG sudo <youruser>
passwd <youruser>
chsh <youruser> // /bin/bash
```
5. Populate ansible/hosts file with your variables
6. Run ansible playbook:
```
ansible-playbook -i hosts setup_node.yml --ask-become-pass
```
7. Proceed to initialize stake pool etc.
8. Run another playbook:
```
ansible-playbook -i hosts start_node.yml --ask-become-pass
```