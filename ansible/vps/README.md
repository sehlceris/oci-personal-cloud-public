# vps provisioning with ansible

```shell
# copy and edit the hosts file to your needs
cp inventory/hosts.example inventory/hosts

# copy and edit the vars file to your needs
cp vars.example.yml vars.yml

# install roles
ansible-galaxy install -r requirements.yml

# run playbook
ansible-playbook -i inventory/hosts main.yml
```