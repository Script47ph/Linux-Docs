## Setup Proxmox on Debian Bullseye

### Prerequisites

**Add an /etc/hosts entry for your IP address**

The hostname of your machine must be resolvable via /etc/hosts. This means that in /etc/hosts you need one of the following entries for your hostname:

* 1 IPv4 or
* 1 IPv6 or
* 1 IPv4 and 1 IPv6

Note: This also means removing the address 127.0.1.1 that is present as default.

For instance, if your IP address is 192.168.15.77, and your hostname prox4m1, then your /etc/hosts file could look like:

```
127.0.0.1       localhost
192.168.15.77   prox4m1.proxmox.com prox4m1

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouter
```

You can test if your setup is ok using the hostname command: 

```
hostname --ip-address
192.168.15.77 # should return your IP address here
```

### Install Proxmox VE

**Adapt your sources.list**

Add the Proxmox VE repository:

```
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
```

Add the Proxmox VE repository key as root (or use sudo):

```
wget https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg && \
sha512sum /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
```

Update your repository and system by running:

```
apt update && apt full-upgrade
```

**Install Proxmox VE packages**

```
apt install proxmox-ve postfix open-iscsi
```

Configure packages which require user input on installation according to your needs.

If you have a mail server in your network, you should configure postfix as a satellite system. Your existing mail server will then be the relay host which will route the emails sent by Proxmox VE to their final recipient. If you don't know what to enter here, choose local only and leave the system name as is. 

**Reboot your System into Proxmox VE**

```
systemctl reboot
```

**Remove the Debian Kernel**

Proxmox VE ships its own kernel and keeping the Debian default kernel can lead to trouble on upgrades, for example, with Debian point releases. Therefore, you must remove the default Debian kernel:

```
apt remove linux-image-amd64 'linux-image-5.10*'
```

Update and check grub2 config by running:

```
update-grub
```

**Recommended: Remove the os-prober Package**

The `os-prober` package scans all the partitions of your host to create dual-boot GRUB entries. But the scanned partitions can also include those assigned to virtual machines, which one doesn't want to add as boot entry.

If you didn't install Proxmox VE as dual boot beside another OS, you can safely remove the `os-prober` package: 

```
apt remove os-prober
```

### Connect to the Proxmox VE web interface

Connect to the admin web interface (https://your-ip-address:8006). If you have a fresh install and have not added any users yet, you should select PAM authentication realm and login with root user account. 

**Create a Linux Bridge**

Once logged in, create a Linux Bridge called vmbr0, and add your first network interface to it.

![images](https://pve.proxmox.com/mediawiki/images/8/84/Screen-vmbr0-setup-for-ext6.png)

**Create a Linux Bridge on one public ip address**

If you want to create a Linux Bridge on one public ip address, you can use the following example configuration in `/etc/network/interfaces`:

```
auto lo
iface lo inet loopback

auto eno1
#real IP address
iface eno1 inet static
        address  198.51.100.5/24 # Your real public ip
        gateway  198.51.100.1 # Your real public gateway

auto vmbr0
#private sub network
iface vmbr0 inet static
        address  10.10.10.1/24 # Your private sub network
        bridge-ports none
        bridge-stp off
        bridge-fd 0

        post-up   echo 1 > /proc/sys/net/ipv4/ip_forward
        post-up   iptables -t nat -A POSTROUTING -s '10.10.10.0/24' -o eno1 -j MASQUERADE
        post-down iptables -t nat -D POSTROUTING -s '10.10.10.0/24' -o eno1 -j MASQUERADE
        post-up   iptables -t raw -I PREROUTING -i fwbr+ -j CT --zone 1
    	post-down iptables -t raw -D PREROUTING -i fwbr+ -j CT --zone 1

```

### Activate DHCP Server

**Install dnsmasq**

```
sudo apt install dnsmasq -y
```

**Configure dnsmasq**

Add the following configuration in the end of line `/etc/dnsmasq.conf`:

```
# My Config
# Your proxmox interface, eg: 'vmbr0'
interface=vmbr0
# Change with your favorite range
dhcp-range=10.10.10.2,10.10.10.100,12h
# Configure ip option with ipv4 vmbr0 interface, eg: 10.10.10.1
dhcp-option=vmbr0,3,10.10.10.1
# public dns
server=8.8.8.8
server=8.8.4.4
# DHCP lease database file path
dhcp-leasefile=/var/lib/misc/dnsmasq.leases
```

Save configuration and check with this command:

```
dnsmasq --test
```

**Services**

```
# Restart services
sudo systemctl restart dnsmasq
# Enable services
sudo systemctl enable dnsmasq
```

### Iptables for port forwarding

**Install iptables-persistent**

```
sudo apt install iptables-persistent -y
```

**Add new rules port forward to iptables**

```
sudo iptables -t nat -A PREROUTING -p tcp --dport listen_hostport -j DNAT --to-destination ip_vm:listen_guestport
```

**Save iptables rules**

```
sudo iptables-save > /etc/iptables/rules.v4
```

**Check iptables rules**

```
sudo iptables -t nat -L --line-numbers
```

**Delete rules from iptables**

```
sudo iptables -t nat -D PREROUTING list_number 
```