## NETSTAT

netstat is print  network connections, routing tables, interface statistics, masquerade connections, and multicast memberships.

### Usage

**View all listening tcp and udp port**

```bash
[localhost@localhost ~]$ netstat -tulanp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      -                   
tcp        0    164 10.0.2.15:22            10.0.2.2:53538          ESTABLISHED -                   
tcp6       0      0 :::22                   :::*                    LISTEN      -                   
tcp6       0      0 :::80                   :::*                    LISTEN      -                   
udp        0      0 127.0.0.53:53           0.0.0.0:*                           -                   
udp        0      0 10.0.2.15:68            0.0.0.0:*                           -
[localhost@localhost ~]$ 
[localhost@localhost ~]$
[localhost@localhost ~]$ sudo netstat -tulanp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      850/sshd: /usr/sbin 
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      575/systemd-resolve 
tcp        0      0 10.0.2.15:22            10.0.2.2:53538          ESTABLISHED 3090/sshd: vagrant  
tcp6       0      0 :::22                   :::*                    LISTEN      850/sshd: /usr/sbin 
tcp6       0      0 :::80                   :::*                    LISTEN      2801/apache2        
udp        0      0 127.0.0.53:53           0.0.0.0:*                           575/systemd-resolve 
udp        0      0 10.0.2.15:68            0.0.0.0:*                           572/systemd-network
```

- `t`: tcp
- `u`: udp
- `l`: listening port
- `a`: all
- `n`: numeric
- `p`: program

**Note**
- By default, locate is not pre-installed on linux. Install net-tools package for using netstat command.
- Use root user for view all pid/program name.

### Help

```bash
[local@localhost ~]$ netstat --help
usage: netstat [-vWeenNcCF] [<Af>] -r         netstat {-V|--version|-h|--help}
    netstat [-vWnNcaeol] [<Socket> ...]
    netstat { [-vWeenNac] -i | [-cnNe] -M | -s [-6tuw] }

        -r, --route              display routing table
        -i, --interfaces         display interface table
        -g, --groups             display multicast group memberships
        -s, --statistics         display networking statistics (like SNMP)
        -M, --masquerade         display masqueraded connections

        -v, --verbose            be verbose
        -W, --wide               don't truncate IP addresses
        -n, --numeric            don't resolve names
        --numeric-hosts          don't resolve host names
        --numeric-ports          don't resolve port names
        --numeric-users          don't resolve user names
        -N, --symbolic           resolve hardware names
        -e, --extend             display other/more information
        -p, --programs           display PID/Program name for sockets
        -o, --timers             display timers
        -c, --continuous         continuous listing

        -l, --listening          display listening server sockets
        -a, --all                display all sockets (default: connected)
        -F, --fib                display Forwarding Information Base (default)
        -C, --cache              display routing cache instead of FIB

<Socket>={-t|--tcp} {-u|--udp} {-U|--udplite} {-S|--sctp} {-w|--raw}
        {-x|--unix} --ax25 --ipx --netrom
<AF>=Use '-6|-4' or '-A <af>' or '--<af>'; default: inet
List of possible address families (which support routing):
    inet (DARPA Internet) inet6 (IPv6) ax25 (AMPR AX.25) 
    netrom (AMPR NET/ROM) rose (AMPR ROSE) ipx (Novell IPX) 
    ddp (Appletalk DDP) x25 (CCITT X.25)
```