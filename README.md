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
[Summary](#Summary)<br />
[Ansible](#ansible)<br />

## Overview
This repository contains Ansible playbooks as well as some other scripts and inventory files that allows the automated configuration of a network.  The network has a preset configuration and those settings are detailed in the [Network Configuration Listing](docs/NETWORK_CONFIGURATION.md) file.  However all settings can be overridden to suit the needs of the User.

## Getting Started
The playbooks in this repo are meant to configure F5 Big-IP Traffic Management devices.  In its initial creation, three Big-IP devices were configured, but as we will discuss, it is possible to have Ansible easily configure any number of these devices in a network.
