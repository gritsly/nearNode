# Stake Wars III

This is a repository containing scripts and automation for NEAR StakeWars part3:

https://near.org/stakewars/

### Progress so far:

- Terraform : defined three resources - two main nodes and one monitoring node using Hetzner cloud


- Ansible: defined multiple playbooks:
  - setup_user.yml - connects to root and sets up non-root sudo user on all servers
  - setup_node.yml - deploys all required packages and configurations for running the node including prometheus exporter. User then must do the near-cli parts manually (login, create pool, etc.)
  - setup_monit.yml - deploys prometheus and grafana on monit node.
  - configure_postfix.yml - configures postfix for use with amazon SES service for sending emails.
  - generate_keys.yml - generates validator_key.json and node_key.json for active and backup nodes and syncs all to both
  - start_active_node.yml - starts validating on node defined in ansible inventory as "active"
  - stop_backup_node.yml - stops validating on node defined in ansible inventory as "backup"
  - hardfork.yml - redownloads nearcore, genesis etc. Automates hard fork of shardnet
  - newbinary.yml - only recompiles nearcore to new commit and backs up old version

  > Disclaimer! If you want to make a failover then the right order of running operations is:
  > 1. Switch nodes in ansible inventory
  > 2. Run stop_backup_node.yml
  > 3. Run start_active_node.yml
  > 4. Manually start neard service on backup node (after checking if everything went well)

## How-To:

1. Create a Hetzner account, generate an API key through cloud panel.
2. Create a 'terraform.tfvars' file with the API key and hostname (it will be used for PTR record):
```
hcloud_token = "xxxxxxxxxxxxxxxxxxxxxxx"
server_hostname = <your hostname>
```
3. Run Terraform
4. Populate ansible/hosts file with your variables
5. Run ansible playbooks:
```
ansible-playbook -i hosts setup_user.yml
ansible-playbook -i hosts setup_node.yml --ask-become-pass
ansible-playbook -i hosts setup_monit.yml --ask-become-pass
ansible-playbook -i hosts configure_postfix.yml --ask-become-pass    #optional
ansible-playbook -i hosts generate_keys.yml --ask-become-pass
```
6. Proceed to initialize stake pool etc.
7. Run another playbook:
```
ansible-playbook -i hosts start_active_node.yml --ask-become-pass
```
8. Check up on your node - journalctl, email sending, set up grafana dashboards etc.
