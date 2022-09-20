## Mysql Setup - Alpine Linux (v3.15)


### Update Repository

```bash
sudo apk update
```

### Install Mysql

```bash
sudo apk add mysql mysql-client
```

### Configuration

**Create Mysql Directory**

```bash
sudo mkdir -p /run/mysqld /var/lib/mysql
```

**Change Directory Ownership to Mysql**

```bash
sudo chown mysql:mysql -R /run/mysqld /var/lib/mysql
```

**Enable Mysql Connection Through Ip & Port**

```bash
sudo sed -i -e 's/skip-networking/skip-networking=0/' /etc/my.cnf.d/mariadb-server.cnf
```

**Mysql Setup**

```bash
sudo mysql_install_db --user=mysql --datadir=/var/lib/mysql && \
sudo /etc/init.d/mariadb start && \
sudo mysql_secure_installation
```

### Create Mysql User

User can be created by two method:

1. Bash

    Setup env variables for easy use.

    ```bash
    MYSQL_USER=
    MYSQL_PASSWORD=
    MYSQL_DATABASE=
    ```

    ```bash
    sudo mysql -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    ```

2. Mysql Console

    ```bash
    sudo mysql -u root
    ```
    ```sql
    CREATE USER 'youruser'@'%' IDENTIFIED BY 'yourpassword';
    ```

### Create Mysql Database

```sql
GRANT ALL PRIVILEGES ON *.* TO 'youruser'@'%';
FLUSH PRIVILEGES;
CREATE DATABASE yourdb;
exit
```

### Mysql Service

**Start**

```bash
sudo rc-service mariadb start
```

**Status**

```bash
sudo rc-service mariadb status
```

**Stop**

```bash
sudo rc-service mariadb stop
```

**Restart**

```bash
sudo rc-service mariadb restart
```

### Runlevel

Normally you want to start service when the system is launching. This is done by adding to the needed runlevel.

```bash
sudo rc-update add mariadb default
```
