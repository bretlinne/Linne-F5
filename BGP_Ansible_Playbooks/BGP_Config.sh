ansible-playbook vlan_playbook.yml -i inventory --ask-vault-pass
ansible-playbook selfip_playbook.yml -i inventory --ask-vault-pass
ansible-playbook routedomain_playbook.yml -i inventory --ask-vault-pass
ansible-playbook vServer_playbook.yml -i inventory --ask-vault-pass
ansible-playbook vAddr_playbook.yml -i inventory --ask-vault-pass
ansible-playbook command_playbook.yml -i inventory --ask-vault-pass

