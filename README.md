# SSH Host Finder

Command line tool to find SSH hosts in a specified IP range and and test if login is successful with given username and password.

**Problem**: When the IP address on the robot is set to dynamic, it occasionally may change. With this small helper script, you can find the IP with the given username and password.

## Prerequisites

    sudo apt-get install nmap sshpass

## Usage
    
    ./ssh_host_finder.sh <username> <password> [ip_range]

e.g.,

    ./ssh_host_finder.sh jetson yahboom 192.168.1.0/24


## Issue

If 
```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
```
you need to try to login manually because you need to erase the existing ssh key.