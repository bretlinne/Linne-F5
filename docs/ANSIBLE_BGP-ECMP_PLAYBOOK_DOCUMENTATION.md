# Ansible BGP-ECMP Playbook Documentation

There are 6 playbooks used to configure the network environment's settings.
There are 4 variable files where values are defined that are used in those playbooks.  If any changes are desired to the
settings applied to the network, they should be made in the variable files.

## Playbook listing and Summary:

### Variable Files
[Big-IP A](#bigipa)
[Big-IP B](#bigipb)
[Big-IP C](#bigipc)
[Big-IP Group Vars](#bigip)

### Playbook Section
[vlan playbook](#vlan)
[selfip playbook](#self)
[routedomain playbook](#route)
[vServer playbook](#vserver)
[vAddr playbook](#vaddress)
[command playbook](#command)

## Variable File listing and Summary:

#### <a name="bigipa"></a>bigipa.yml
- Holds the variables local to the first of three Big-IP's on the network. Contains IP addresses, and self-ip external and internal designations.
```
# variable file for bigip-a
address: 10.1.1.7
ansible_host: 10.1.1.7
#ansible_ssh_pass: "{{ vault_ansible_ssh_pass }}"
#ansible_ssh_user: "{{ vault_ansible_ssh_user }}"
selfAddrExt: 10.1.20.20
selfAddrInt: 10.1.30.20
```
#### <a name="bigipb"></a>bigipb.yml
- Holds the variables local to the second of three Big-IP's on the network. Contains IP addresses, and self-ip external and internal designations.
```
# variable file for bigip-b
address: 10.1.1.8
ansible_host: 10.1.1.8
#ansible_ssh_pass: "{{ vault_ansible_ssh_pass }}"
#ansible_ssh_user: "{{ vault_ansible_ssh_user }}"
selfAddrExt: 10.1.20.30
selfAddrInt: 10.1.30.30
```
#### <a name="bigipc"></a>bigipc.yml
- Holds the variables local to the third of three Big-IP's on the network. Contains IP addresses, and self-ip external and internal designations.
```
# variable file for bigip-c
address: 10.1.1.9
ansible_host: 10.1.1.9
#ansible_ssh_pass: "{{ vault_ansible_pass }}"
#ansible_ssh_user: "{{ vault_ansible_user }}"
selfAddrExt: 10.1.20.40
selfAddrInt: 10.1.30.40
```
#### <a name="bigip"></a>bigip.yml [group_var]
Holds all variables commonly shared between Big-IP machines.
Contains a grouping of designations as well as common settings:
```
# bigip group vars
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
vlanExtName: External
vlanIntName: Internal
interface11: 1.1
interface12: 1.2
rProtocols:
  - BFD
  - BGP
id: 0
vAddress: 172.16.20.100
vAddressName: VS-80
vAddrAvailability: yes
profiles: fastL4
netmask: 255.255.255.0
tagExt: 20
tagInt: 30
```
__port:__ 0
    This is how to designate that `any` port is available.  If a specific port number is given here instead of `0`, __only__ that port will be available.

__interface11:__ 1.1

__interface12:__ 1.2

Desginations for the Big-IP's interfaces

__rProtocols:__
    The accepted routing protocols are listed here.  By default they are set to `BGP` and `BFD`.

__vAddress__
    The default virtual address is designated here.  Default is `172.16.20.100`

__vAddrAvailability__
    Virtual Address Availability is set by default to `yes`.

__profiles__
    Profiles designations are given here.  Default is set to `fastL4`

__netmask__
    The netmask is set to a 24 bit mask, or `255.255.255.0`

## Common to all playbooks in this set:

### Playbook-level fields:

__hosts:__ bigip
  This field refers to the hosts file which groups all the bigip devices under this alias.  This means that when this playbook is run, it will be executed for each Bip-IP device defined under the alias [bigip].

__connection:__ local
This field specifies that the process will be running on (or delegated to) the machine where this playbook is executed.


### Task-level fields:

__validate_certs:__ "{{ validate_certs }}"
This is set to `no` or `false` by default.

__user:__ "{{ username }}"
This field takes in the username.
This is an Ansible vault-encrypted string.

__password:__ "{{ password }}"
This field takes in the password.
This is an Ansible vault-encrypted string.

__server:__ "{{ inventory_hostname }}"
The name of the host. By default this is set to `ansible_host`
`ansible_host` is variably defined inside the host_var files as device-specific IP addresses.

## <a name="playbooks"></a>Ansible Playbook Documentation

### <a name="vlan"></a>VLAN_PLAYBOOK

There are two Ansible Plays in this playbook.  One configures the internal VLAN of each Big-IP
device that it's invoked upon.  The other configures the external VLAN for each device.  The
functionality and fields specified in the Plays are identical.  The differentiation lies in the
reference to variables in the host_vars file for each Big-IP device.  Several fields are common
between both Plays and reference the group_vars file.
```
# vlan playbook
---
- name: vlan_playbook
hosts: bigip
connection: local
tasks:
- name: Create Internal VLAN on the BIG-IP
  bigip_vlan:
    name: "{{ vlanIntName }}"
    server: "{{ ansible_host }}"
    tag: "{{ tagInt }}"
    untagged_interfaces: "{{ interface12 }}"
    user: "{{ user }}"
    password: "{{ password }}"
    validate_certs: "{{ validate_certs }}"

- name: Create External VLAN on the BIG-IP
  bigip_vlan:
    name: "{{ vlanExtName }}"
    server: "{{ ansible_host }}"
    tag: "{{ tagExt }}"
    untagged_interfaces: "{{ interface11 }}"
    user: "{{ user }}"
    password: "{{ password }}"
    validate_certs: "{{ validate_certs }}"
    ```

#### VLAN Playbook fields

__[bigip_vlan](https://f5-ansible.readthedocs.io/en/devel/modules/bigip_vlan_module.html):__
This is the name of a predefined __module__ in Ansible, built by F5.

__name:__ "{{ vlanIntName }}"
This field is the label given to the Internal VLAN.  This value is used elsewhere in other Ansible
playbooks to reference these VLANs.

__tag:__ "{{ tagInt }}"
__tag:__ "{{ tagExt }}"
These fields take in the tag value for the internal and external VLANs, respectively.

__untagged_interfaces:__ "{{ interface11 }}"
__untagged_interfaces:__ "{{ interface12 }}"
These fields take in untagged interface values.  Interface 1.1 for the internal, 1.2 for external.


## <a name="self"></a>SELFIP_PLAYBOOK

There are two Ansible Plays in this playbook.  One configures the internal Self-IP of each Big-IP
device that it's invoked upon.  The other configures the external Self-IP for each device.  The
functionality and fields specified in the Plays are identical.  The differentiation lies in the
reference to variables in the host_vars file for each Big-IP device.  Several fields are common
between both Plays and reference the group_vars file.
```
# selfip playbook
---
- name: selfip_playbook
  hosts: bigip
  connection: local
  tasks:
  - name: Create Internal SELF-IPs on the BIG-IP
    bigip_selfip:
      name: "{{ selfAddrInt }}"
      address: "{{ selfAddrInt }}"
      netmask: "{{ netmask }}"
      server: "{{ ansible_host }}"
      user: "{{ user }}"
      password: "{{ password }}"
      validate_certs: "{{ validate_certs }}"
      vlan: "{{ vlanIntName }}"

  - name: Create External SELF-IPs on the BIG-IP
    bigip_selfip:
      # 'name' can just be the IP
      name: "{{ selfAddrExt }}"
      address: "{{ selfAddrExt }}"
      netmask: "{{ netmask }}"
      server: "{{ ansible_host }}"
      user: "{{ user }}"
      password: "{{ password }}"
      validate_certs: "{{ validate_certs }}"
      vlan: "{{ vlanExtName }}"
```
#### Self-IP Playbook fields

__[bigip_selfip](https://f5-ansible.readthedocs.io/en/devel/modules/bigip_selfip_module.html):__
This is the name of a predefined module in Ansible, built by F5.

__name:__ "{{ selfAddrInt }}"
__name:__ "{{ selfAddrExt }}"
*Host specific variable*. This field is the address assigned to the Internal or External self-ip, respectively.

__netmask:__ "{{ netmask }}"
This field specifies a particular netmask.  By default its set to `255.255.255.0`

__vlan:__ "{{ vlanIntName }}"
__vlan:__ "{{ vlanExtName }}"
These fields take in a name label for the internal and external vlan's, respectively. These are the
same names specified in teh VLAN_PLAYBOOK and we're using them to directly call those VLANs for
linkage with the Self-IPs.

## <a name="route"></a>ROUTEDOMAIN_PLAYBOOK

There is one Ansible Play in this playbook.  It configures the route domain of each Big-IP
device that it's invoked upon.  Several fields are common between both Plays and reference the
group_vars file.
```
# routedomain playbook
---
- name: Route Domain Playbook
  hosts: bigip
  connection: local
  tasks:
  # need to include dynamic routing protocols - is this satisfied? Ask Tony
  - name: Modify route domains on the BIG-IP
    bigip_routedomain:
      id: "{{ id }}"
      user: "{{ user }}"
      password: "{{ password }}"
      server: "{{ ansible_host }}"
      validate_certs: "{{ validate_certs }}"
      routing_protocol: "{{ rProtocols }}"
```

#### Route Domain Playbook fields

__[bigip_routedoamin](http://f5-ansible.readthedocs.io/en/devel/modules/bigip_routedomain_module.html)__:
This is the name of a predefined module in Ansible, built by F5.

__id:__ "{{ id }}"
This field is the identification number of the route domain.  It is set initially to `0`.

__routing_protocol:__ "{{ rProtocols }}"
This is set to allow both `BFD` and `BGP`.

## <a name="vserver"></a>VSERVER_PLAYBOOK

There is one Ansible Play in this playbook.  It configures the virtual server of each Big-IP
device that it's invoked upon.  Several fields are common between both Plays and reference the
group_vars file.
```
# vServer playbook
---
- name: Add Virtual Server Playbook
  hosts: bigip
  connection: local
  tasks:
  - name: Add Virtual Server
    bigip_virtual_server:
        server: "{{ ansible_host }}"
        user: "{{ user }}"
        password: "{{ password }}"
        name: "{{ vAddressName }}"
        destination: "{{ vAddress }}"
        port: "{{ port }}"
        description: Test Virtual Server
        all_profiles: "{{ profiles }}"
        validate_certs: "{{ validate_certs }}"
```
#### Virtual Server Playbook fields

__[bigip_virtual_server](https://f5-ansible.readthedocs.io/en/devel/modules/bigip_virtual_server_module.html):__
This is the name of a predefined module in Ansible, built by F5.

__name:__ "{{ vAddressName }}"
#  FIX THIS - 'vAddressName' should be 'vServerName'
This is the name of the Virtual Server.  Set initially to 'VS-80'.

__destination:__ "{{ vAddress }}"
This is the virtual address.  Its initially set to `172.16.20.100`.

__port:__ "{{ port }}"
Initially set to `0` to allow any port.

__all_profiles:__ "{{ profiles }}"
Sets the profile for the Virtual Server to be `FastL4`.

### <a name="vaddress"></a>VADDR_PLAYBOOK

There is one Ansible Play in this playbook.  It configures the virtual address of each Big-IP
device that it's invoked upon.  Several fields are common between both Plays and reference the
group_vars file.
```
# vAddress Playbook
---
- name: Virtual Address Playbook
  hosts: bigip
  connection: local
  tasks:
  - name: Modify Virtual Address
    bigip_virtual_address:
      use_route_advertisement: "{{ vAddrAvailability }}"
      address: "{{ vAddress }}"
      server: "{{ ansible_host }}"
      user: "{{ user }}"
      password: "{{ password }}"
```
#### Virtual Address Playbook fields

__[bigip_virtual_address](http://f5-ansible.readthedocs.io/en/devel/modules/bigip_virtual_address_module.html):__
This is the name of the F5 module.

__address:__ "{{ vAddress }}"
This field takes in the IP address to which the virtual address will be set. It's initially set to `172.16.20.100`.

__use_route_advertisement:__ "{{ vAddrAvailability }}"
This is set to 'yes' initially.


## <a name="command"></a>COMMAND_PLAYBOOK

There is one Ansible Play in this playbook.  This one issues an arbitrary command to the Big-IP
to modify the local traffic manager's IP-Protocol to be 'any'.
```
# BigIP Command Playbook
---
- name: Bigip Command Playbook
  hosts: bigip
  connection: local
  tasks:
  - name: Modify the ltm
    bigip_command:
      commands: modify ltm virtual "{{ vAddressName }}"
        ip-protocol any profiles replace-all-with { ipother }
      server: "{{ ansible_host }}"
      password: "{{ password }}"
      user: "{{ user }}"
      validate_certs: "{{ validate_certs }}"
```
#### Command Playbook Field:
__[bigip_command](http://f5-ansible.readthedocs.io/en/devel/modules/bigip_command_module.html)__:
The name of the F5 module.

__commands:__
`modify ltm virtual "{{ vAddressName }}" ip-protocol any profiles replace-all-with { ipother }`
This field defines the command that will be invoked.  To have an ip-protocol set to `any`, a specific protocol needs to be set.  That profile is `{ ipother }`.

It is possible that Ansible will issue a warning that this Play is not __Idempotent__.
