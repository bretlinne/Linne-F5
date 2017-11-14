# Network Configuration

## F5 Devices
### Big-IP A

__Subnets__

    Management  
      10.1.1.0/24
      10.1.1.7 Primary
    Subnet 10:
      10.1.10.0/24
    Subnet 20:
      10.1.20.0/24
      10.1.20.20 Primary
    Subnet 30:
      10.1.30.0/24
      10.1.30.20 Primary

### Big-IP B

__Subnets__

    Management  
      10.1.1.0/24
      10.1.1.8 Primary
    Subnet 10:
      10.1.10.0/24
    Subnet 20:
      10.1.20.0/24
      10.1.20.30 Primary
    Subnet 30:
      10.1.30.0/24
      10.1.30.30 Primary

### Big-IP C
__Subnets__

    Management  
      10.1.1.0/24
      10.1.1.9 Primary
    Subnet 10:
      10.1.10.0/24
    Subnet 20:
      10.1.20.0/24
      10.1.20.40 Primary
    Subnet 30:
      10.1.30.0/24
      10.1.30.40 Primary

### ECMP Router
__Subnets__

    10.1.1.6
    Subnet 10:
      10.1.10.0/24
      10.1.10.10 Primary
    Subnet 20:
      10.1.20.0/24
      10.1.20.10 Primary
      10.1.20.11
    Subnet 30:
      10.1.30.0/24

## Subnet Layout

### Management

    Hosts   ECMP Router:  10.1.1.6
            Big-IP A:     10.1.1.7
            Big-IP B:     10.1.1.8
            Big-IP C:     10.1.1.9

### Subnet 10
    Hosts   ECMP Router:  10.1.10.10
            Big-IP A:     Not Bound
            Big-IP B:     Not Bound
            Big-IP C:     Not Bound

### Subnet 20
    Hosts   ECMP Router:  10.1.10.10
                          10.1.20.11
            Big-IP A:     10.1.20.20 Primary
            Big-IP B:     10.1.20.30 Primary
            Big-IP C:     10.1.20.40 Primary

### Subnet 30
    Hosts   ECMP Router:  Not Bound
            Big-IP A:     10.1.30.20
            Big-IP B:     10.1.30.30
            Big-IP C:     10.1.30.40

## TMSH Network Listings
Using the traffic manager shell (TMSH), the particular settings of the network can be viewed.  This
document lists the target network configuration that the ansible playbooks and inventory files aim
to achieve.


### Vlan Configuration

#### All BigIP
    list net vlan
    net vlan External {
        if-index 128
        interfaces {
            1.1 { }
        }
        tag 20
    }
    net vlan Internal {
        if-index 144
        interfaces {
            1.2 { }
        }
        tag 30
    }

### Self-IP Configuration
#### BigIP A Self-IP
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

#### BigIP B Self-IP
    net self 10.1.30.30 {
        address 10.1.30.30/24
        allow-service all
        traffic-group traffic-group-local-only
        vlan Internal
    }
    net self 10.1.20.30 {
        address 10.1.20.30/24
        allow-service all
        traffic-group traffic-group-local-only
        vlan External
    }
#### BigIP C Self-IP
    net self 10.1.30.40 {
        address 10.1.30.40/24
        allow-service all
        traffic-group traffic-group-local-only
        vlan Internal
    }
    net self 10.1.20.40 {
        address 10.1.20.40/24
        allow-service all
        traffic-group traffic-group-local-only
        vlan External
    }
### Route-Domain Configuration
#### All BigIP
    net route-domain 0 {
        id 0
        routing-protocol {
            BFD
            BGP
        }
        vlans {
            Internal
            http-tunnel
            socks-tunnel
            External
        }
    }

### Virtual Server Configuration
#### All BigIP
    ltm virtual VS_80 {
        destination 172.16.20.100:any
        mask 255.255.255.255
        profiles {
            fastL4 { }
        }
        source 0.0.0.0/0
        translate-address enabled
        translate-port enabled
        vs-index 2
    }

### Virtual Address Configuration
#### All BigIP
    ltm virtual-address 172.16.20.100 {
        address 172.16.20.100
        arp enabled
        icmp-echo enabled
        mask 255.255.255.255
        route-advertisement enabled
        traffic-group /Common/traffic-group-1
    }

### Routing Configurations
Viewed using:
`imish`
`enable`
`show run`

#### BigIP A Routing Configuration

    !
    no service password-encryption
    !
    interface lo
    !
    interface tmm
    !
    interface External
    !
    interface Internal
    !
    router bgp 26277
     bgp router-id 10.1.20.20
     bgp graceful-restart restart-time 120
     network 10.1.30.0/32
     redistribute kernel
     neighbor 10.1.20.10 remote-as 25788
     neighbor 10.1.20.10 soft-reconfiguration inbound
    !
    bfd gtsm enable
    !
    line con 0
     login
    line vty 0 39
     login
    !
    end

#### BigIP B Routing Configuration
    !
    no service password-encryption
    !
    interface lo
    !
    interface tmm
    !
    interface External
    !
    interface Internal
    !
    router bgp 26277
     bgp router-id 10.1.20.30
     bgp graceful-restart restart-time 120
     network 10.1.30.0/32
     redistribute kernel
     neighbor 10.1.20.10 remote-as 25788
     neighbor 10.1.20.10 soft-reconfiguration inbound
    !
    bfd gtsm enable
    !
    line con 0
     login
    line vty 0 39
     login
    !
    end
#### BigIP C Routing Configuration
    !
    no service password-encryption
    !
    interface lo
    !
    interface tmm
    !
    interface External
    !
    interface Internal
    !
    router bgp 26277
     bgp router-id 10.1.20.40
     bgp graceful-restart restart-time 120
     network 10.1.30.0/32
     redistribute kernel
     neighbor 10.1.20.10 remote-as 25788
     neighbor 10.1.20.10 soft-reconfiguration inbound
    !
    bfd gtsm enable
    !
    line con 0
     login
    line vty 0 39
     login
    !
    end
