## SS

ss is a command line utility for monitoring sockets. It is a replacement for netstat.

### Usage

**View all listening tcp and udp port**

```bash
[localhost@localhost ~]$ ss -tulanp
Netid  State   Recv-Q  Send-Q       Local Address:Port     Peer Address:Port   Process  
udp    UNCONN  0       0            127.0.0.53%lo:53            0.0.0.0:*               
udp    UNCONN  0       0         10.0.2.15%enp0s3:68            0.0.0.0:*               
tcp    LISTEN  0       4096         127.0.0.53%lo:53            0.0.0.0:*               
tcp    LISTEN  0       128                0.0.0.0:22            0.0.0.0:*               
tcp    ESTAB   0       0                10.0.2.15:22           10.0.2.2:38044           
tcp    LISTEN  0       128                   [::]:22               [::]:*               
tcp    LISTEN  0       511                      *:80                  *:*               
[localhost@localhost ~]$
[localhost@localhost ~]$
[localhost@localhost ~]$ sudo ss -tulanp
Netid   State    Recv-Q   Send-Q          Local Address:Port       Peer Address:Port    Process                                                                                 
udp     UNCONN   0        0               127.0.0.53%lo:53              0.0.0.0:*        users:(("systemd-resolve",pid=564,fd=13))                                              
udp     UNCONN   0        0            10.0.2.15%enp0s3:68              0.0.0.0:*        users:(("systemd-network",pid=562,fd=18))                                              
tcp     LISTEN   0        4096            127.0.0.53%lo:53              0.0.0.0:*        users:(("systemd-resolve",pid=564,fd=14))                                              
tcp     LISTEN   0        128                   0.0.0.0:22              0.0.0.0:*        users:(("sshd",pid=693,fd=3))                                                          
tcp     ESTAB    0        0                   10.0.2.15:22             10.0.2.2:38044    users:(("sshd",pid=1445,fd=4),("sshd",pid=1381,fd=4))                                  
tcp     LISTEN   0        128                      [::]:22                 [::]:*        users:(("sshd",pid=693,fd=4))                                                          
tcp     LISTEN   0        511                         *:80                    *:*        users:(("apache2",pid=751,fd=4),("apache2",pid=750,fd=4),("apache2",pid=748,fd=4))      
```

- `t`: tcp
- `u`: udp
- `l`: listening port
- `a`: all
- `n`: numeric
- `p`: processes

**Note**
- Use root user for view all pid/program name.

### Help

```bash
[local@localhost ~]$ ss --help
Usage: ss [ OPTIONS ]
       ss [ OPTIONS ] [ FILTER ]
   -h, --help          this message
   -V, --version       output version information
   -n, --numeric       don't resolve service names
   -r, --resolve       resolve host names
   -a, --all           display all sockets
   -l, --listening     display listening sockets
   -o, --options       show timer information
   -e, --extended      show detailed socket information
   -m, --memory        show socket memory usage
   -p, --processes     show process using socket
   -i, --info          show internal TCP information
       --tipcinfo      show internal tipc socket information
   -s, --summary       show socket usage summary
       --tos           show tos and priority information
       --cgroup        show cgroup information
   -b, --bpf           show bpf filter socket information
   -E, --events        continually display sockets as they are destroyed
   -Z, --context       display process SELinux security contexts
   -z, --contexts      display process and socket SELinux security contexts
   -N, --net           switch to the specified network namespace name

   -4, --ipv4          display only IP version 4 sockets
   -6, --ipv6          display only IP version 6 sockets
   -0, --packet        display PACKET sockets
   -t, --tcp           display only TCP sockets
   -M, --mptcp         display only MPTCP sockets
   -S, --sctp          display only SCTP sockets
   -u, --udp           display only UDP sockets
   -d, --dccp          display only DCCP sockets
   -w, --raw           display only RAW sockets
   -x, --unix          display only Unix domain sockets
       --tipc          display only TIPC sockets
       --vsock         display only vsock sockets
   -f, --family=FAMILY display sockets of type FAMILY
       FAMILY := {inet|inet6|link|unix|netlink|vsock|tipc|xdp|help}

   -K, --kill          forcibly close sockets, display what was closed
   -H, --no-header     Suppress header line
   -O, --oneline       socket's data printed on a single line
       --inet-sockopt  show various inet socket options

   -A, --query=QUERY, --socket=QUERY
       QUERY := {all|inet|tcp|mptcp|udp|raw|unix|unix_dgram|unix_stream|unix_seqpacket|packet|netlink|vsock_stream|vsock_dgram|tipc}[,QUERY]

   -D, --diag=FILE     Dump raw information about TCP sockets to FILE
   -F, --filter=FILE   read filter information from FILE
       FILTER := [ state STATE-FILTER ] [ EXPRESSION ]
       STATE-FILTER := {all|connected|synchronized|bucket|big|TCP-STATES}
         TCP-STATES := {established|syn-sent|syn-recv|fin-wait-{1,2}|time-wait|closed|close-wait|last-ack|listening|closing}
          connected := {established|syn-sent|syn-recv|fin-wait-{1,2}|time-wait|close-wait|last-ack|closing}
       synchronized := {established|syn-recv|fin-wait-{1,2}|time-wait|close-wait|last-ack|closing}
             bucket := {syn-recv|time-wait}
                big := {established|syn-sent|fin-wait-{1,2}|closed|close-wait|last-ack|listening|closing}
```