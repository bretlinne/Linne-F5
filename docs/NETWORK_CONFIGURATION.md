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

    net vlan External {
        if-index 144
        interfaces {
            1.1 { }
        }
        tag 20
    }

    net vlan Internal {
        if-index 128
        interfaces {
            1.2 { }
        }
        tag 30
    }

### Self-IP Configuration


### Route-Domain Configuration

### Virtual Server Configuration

### Virtual Address Configuration
