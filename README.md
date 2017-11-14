# BGP ECMP Ansible Playbooks
## Repository Directory
[Playbook Documentation](docs/ANSIBLE_BGP-ECMP_PLAYBOOK_DOCUMENTATION.md)
[Ansible Vault Details](docs/ANSIBLE_VAULT_DOCUMENTATION.md)
[Ansible F5 Module Documentation](docs/MODULES.md)
[Network Configuration Listing](docs/NETWORK_CONFIGURATION.md)
[Ansible Variable Precedence](docs/VARIABLE_PRECEDENCE.md)


## Summary
This repository contains Ansible playbooks as well as some other scripts and inventory files that allows the automated configuration of a network.  The network has a preset configuration and those settings are detailed in the NetworkConfig.md file.  However all settings can be overridden to suit the needs of the User.

## Getting Started
The playbooks in this repo are meant to configure F5 Big-IP Traffic Management devices.  In its initial creation, three Big-IP devices were configured, but as we will discuss, it is possible to have Ansible easily configure any number of these devices in a network.

### Ansible
Ansible is a provisioning and automated network configuration software.  It uses scripts called __Plays__ which declare a particular state to which elements of the  network need to be set.  The modules invoked in these Plays take care of the execution of these states.  An Ansible __Playbook__ comprises one or many Plays.  

#### Benefits of Ansible:
- __Agentless__ - only Python is truly required to run Ansible in any environment.  F5's playbooks require a little extra to use the modules for configuring Big-IP devices.
- __Idempotence__ - In most cases Ansible Plays can be run over and over without risking redundant changes or installations.  Idempotency means that a particular element of a set will not change in value when multiplied or otherwise operated on by itself.
- __Declarative__ - The desired state of computer systems and services is described in Ansible's resource model.  The Plays work to transform the state of the target host to that specified in the script.  This allows reliable and repeatable IT infrastructure.
- __Robust__ - Ansible comes with a large library of pre-built modules to configure a network or system.  F5 has its own comprehensive set of modules for configuring their specific systems.

#### Environment
The Playbooks are executed from the command line interface of the Ansible Server and Ansible connects via SSH to the host devices to be configured.

### Ansible Server
A dedicated machine will be needed to act as the hub of operations for running the Ansible playbooks to configure the network.  

Ansible runs best through a Unix-like command line interface and is therefore best run on either a Linux-based machine, or a Mac. 

## Prerequisites
Ansible needs to be installed on your Ansible Server.
Running the Playbooks.

In order to install Ansible, there are a couple steps needed.
