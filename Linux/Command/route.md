## ROUTE

route is a command line tool for manipulating the IP routing table.

### Usage

```bash
[local@localhost ~]$ route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         139.59.112.1    0.0.0.0         UG    0      0        0 eth0
10.15.0.0       0.0.0.0         255.255.0.0     U     0      0        0 eth0
10.104.0.0      0.0.0.0         255.255.240.0   U     0      0        0 eth1
10.161.97.0     0.0.0.0         255.255.255.0   U     0      0        0 lxdbr0
139.59.112.0    0.0.0.0         255.255.240.0   U     0      0        0 eth0
172.17.0.0      0.0.0.0         255.255.0.0     U     0      0        0 docker0
192.168.33.0    0.0.0.0         255.255.255.0   U     0      0        0 vboxnet0
192.168.122.0   0.0.0.0         255.255.255.0   U     0      0        0 virbr0
```

### Help

```bash
[local@localhost ~]$ route --help
Usage: route [-nNvee] [-FC] [<AF>]           List kernel routing tables
       route [-v] [-FC] {add|del|flush} ...  Modify routing table for AF.

       route {-h|--help} [<AF>]              Detailed usage syntax for specified AF.
       route {-V|--version}                  Display version/author and exit.

        -v, --verbose            be verbose
        -n, --numeric            don't resolve names
        -e, --extend             display other/more information
        -F, --fib                display Forwarding Information Base (default)
        -C, --cache              display routing cache instead of FIB

  <AF>=Use -4, -6, '-A <af>' or '--<af>'; default: inet
  List of possible address families (which support routing):
    inet (DARPA Internet) inet6 (IPv6) ax25 (AMPR AX.25) 
    netrom (AMPR NET/ROM) ipx (Novell IPX) ddp (Appletalk DDP) 
    x25 (CCITT X.25) 
```