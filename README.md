# BGP ECMP Ansible Playbooks
## Repository Directory
[Network Configuration Listing](docs/NETWORK_CONFIGURATION.md)<br />
[Ansible Environment Setup](docs/ANSIBLE_ENVIRONMENT_SETUP.md)<br />
[Playbook Documentation](docs/ANSIBLE_BGP-ECMP_PLAYBOOK_DOCUMENTATION.md)<br />
[Ansible Vault Details](docs/ANSIBLE_VAULT_DOCUMENTATION.md)<br />
[Ansible F5 Module Documentation](docs/MODULES.md)<br />
[ZebOS Script Documentation](docs/ZEB_OS_DOCUMENTATION.md)<br />
[Ansible Variable Precedence](docs/VARIABLE_PRECEDENCE.md)<br />

## Contents
[tmsh](#tmsh) <br />
[Creating the Playbooks](#playbook-creation) <br />
[Modifying the Configuration](#modify-config) <br />

[Running The Playbooks](#running-the-playbooks) <br />
[Running The](#running-the) <br />
[Running The Playbooks](#running-the-playbooks) <br />
[Running The Playbooks](#running-the-playbooks) <br />



## Overview
This repository contains Ansible playbooks as well as some other scripts and inventory files that allows the automated configuration of a network.  The network has a preset configuration and those settings are detailed in the [Network Configuration Listing](docs/NETWORK_CONFIGURATION.md) file.  However all settings can be overridden to suit the needs of the User.

## Getting Started
The playbooks in this repo are meant to configure F5 Big-IP Traffic Management devices.  In its initial creation, three Big-IP devices were configured, but as we will discuss, it is possible to have Ansible easily configure any number of these devices in a network.

The best place to get started depends on what is required.  
reviewing the current network configuration is a good first step.  If that is satisfactory, then __[setting up the Ansible environment](docs/ANSIBLE_ENVIRONMENT_SETUP.md)__ would be the next best procedure.

(#running-the-playbooks)
## Running the Playbooks
Once the Ansible Environment has been setup, the playbooks can be executed. This can be done by either manually issuing each of the following, or by using the helper script `BGP_Config.sh`.  On the Ansible host server, run the playbooks in the following order:

In a Command Line Interface (CLI)

* Note that after running each playbook, you should check the settings of each Big-IP to ensure you are getting exactly the results you anticipated.

  1) `ansible-playbook -i inventory vlan_playbook.yml --ask-vault-pass`
  2) `ansible-playbook -i inventory selfip_playbook.yml --ask-vault-pass`
  3) `ansible-playbook -i inventory routedomain_playbook.yml --ask-vault-pass`
  4) `ansible-playbook -i inventory vServer_playbook.yml --ask-vault-pass`
  5) `ansible-playbook -i inventory vAddr_playbook.yml --ask-vault-pass`
  6) `ansible-playbook -i inventory command_playbook.yml --ask-vault-pass`
  7)
  # needs work: makeRoutingConfigFile_playbook.yml

The BGP_Config.sh contains:

    ansible-playbook vlan_playbook.yml -i inventory --ask-vault-pass
    ansible-playbook selfip_playbook.yml -i inventory --ask-vault-pass
    ansible-playbook routedomain_playbook.yml -i inventory --ask-vault-pass
    ansible-playbook vServer_playbook.yml -i inventory --ask-vault-pass
    ansible-playbook vAddr_playbook.yml -i inventory --ask-vault-pass
    ansible-playbook command_playbook.yml -i inventory --ask-vault-pass

(#running-the)
## Process for creating the playbooks
These playbooks were made from a set of data given for a particular network configuration.

The data was derived from a testing environment.  

This data was viewed using the TMSH or Traffic Management Shell, developed by F5.

All aspects of the network can be configured differently if the user supplies different values in
the variable files.  

(#tmsh)
### TRAFFIC MANAGEMENT SHELL (TMSH)

F5 developed tmsh to allow complete access to all advanced features of F5 devices. Using tmsh you
can configure and manage the system from the command line. You can also configure BIG-IP to manage
local and global traffic, as well as view system performance data.

The specific commands used to view the data needed for creating the playbooks were:

If running commands from BASH:
`tmsh list net vlan`<br />`tmsh list net self-ip`<br />`tmsh list net route-domain`<br />`tmsh list ltm virtual`<br />`tmsh list ltm virtual-address`<br />

#### or

type in `tmsh` at the BASH prompt to enter the shell and use all the commands as above without the tmsh, i.e:<br /> `list net vlan`.

to exit the TMSH, type `exit`

These commands will display the current configuration for each aspect of the network and allow
verification as to whether all the settings are correct.  

__Example output for `tmsh list net self-ip`:__

    net self 10.1.30.20 {
        address 10.1.30.20/24
        allow-service all
        traffic-group traffic-group-local-only
        vlan Internal
    }
    net self 10.1.20.20 {
        address 10.1.20.20/24
        allow-service all
        traffic-group traffic-group-local-only
        vlan External
    }

(#modify-config)
### Modifying the Configuration
The configuration can be altered from that specified in the provided variable files.  All Ansible playbooks are designed to be independent of hard-coded values.  They are all referencial to either a group_var file or a specific host_var file.

1. Open the group_var file `bigip.yml` and edit whichever settings that are to be common across the Big-IP devices.

2. Open the host_var files `bigipa.yml`, `bigipb.yml`, `bigipc.yml` and make specific changes to each device if needed.

The Ansible scripts should still run and configure according to the new settings.
