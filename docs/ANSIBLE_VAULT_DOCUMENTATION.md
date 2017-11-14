# Ansible Vault Usage

## Overview
Ansible vault is a tool that allows safe storage of sensitive data via encryption instead of storing a value as plain-text. To use this feature, either a command line tool `ansible-vault` is used, or a command line flag `--ask-vault-pass` is used.

This project uses the latter method and encrypts via an embedded string of characters.  The sensitive data is stored as a vault-encrypted string.

See [Ansible Vault Documentation](https://docs.ansible.com/ansible/2.4/vault.html) for a more comprehensive reading on how vault works.

__Example:__

    .
    .
    user: !vault |
              $ANSIBLE_VAULT;1.1;AES256
              33626263363766393539626263353834396461653233643430373834353337653333373863623265
              6534373932646538323431626132633866343237643538620a343739343766653462653937313061
              66316236386432323863333263643836333861316333613137373939383265353736363861373932
              3663323839613739340a383266373966663161633763353262613638663638623865383530633239
              6361
    password: !vault |
              $ANSIBLE_VAULT;1.1;AES256
              64613237376339323931653762366261336464663735643034613561343437326361623939623661
              6166313638356231323938633636653565316538666239340a633662396433313039363534633666
              66643632313065326562376563656530653463643561623530373533386633333231383664653839
              3132643130326562360a616131393764613865373366653166343438303334326661383431616430
              6464
    validate_certs: No
    port: 0
    .
    .
    .

### Using the variable files
It is simple to run a playbook with the vault-encrypted strings.
When running an ansible playbook, append this command onto the end:
`--ask-vault-pass`

__Example:__
`ansible-playbook -i inventory <nameOfPlaybookToRun>.yml --ask-vault-pass`

Ansible will then issue a prompt at the command line to enter the password.

### Creating a new vault-encrypted value
The user can change the value of a vault-encrypted string by issuing the command:
`ansible-vault `

At some point the user may want to replace the existing password with one of their own choosing.

This can be done from the command line using the ansible-vault encrypt string commands as shown:

`ansible-vault encrypt_string -n <key> <value>`

`ansible-vault encrypt_string -n user admin --output=./test.yml`
`ansible-vault encrypt_string -n password admin --output=./test.yml`
