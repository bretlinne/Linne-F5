## Ansible Environment Setup

Ansible manages connections over SSH protocol.
Ubuntu 16.04.3 LTS

#ansible
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

Ansible runs best through a Unix-like command line interface and is therefore best run on either a Linux-based machine, or a Mac. It is possible to do this through a virtual machine as well as a physical one.

## Prerequisites
In general there are only a few requirements:
[Ansible 2.2.0 or greater][installing]
Advanced shell for user account enabled - Note this requierment it caught me and took me a while to realize.
[bigsuds Python Client 1.0.4 or later][bigsuds]
[f5-sdk Python Client, latest available][f5-sdk]

Ansible needs to be installed on your Ansible Server.
In order to install Ansible, there are a couple steps needed.
Its always prudent to run apt-get updates when doing some new configuring on a server, even an established one.
Run:
`sudo apt-get update`
`sudo apt-get upgrade`

If working on an established server, it might work better to use:
`sudo apt-get dist-upgrade`
