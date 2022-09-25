## MariaDB Setup - Ubuntu

### Update Repository

```bash
sudo apt update
```

### Install MariaDB

```bash
sudo apt install mariadb-server mariadb-client
```

### Remove MariaDB

```bash
sudo apt-get purge 'mariadb*' -y && \
echo "/usr/sbin/mysqld { }" | sudo tee /etc/apparmor.d/usr.sbin.mysqld && \
sudo ln -sf /etc/apparmor.d/usr.sbin.mysqld /etc/apparmor.d/disable/usr.sbin.mysqld
```

### Configuration

#### MariaDB Setup

```bash
sudo mysql_secure_installation
```

#### Disable root login without password from console

```bash
sudo mysql -u root -e "UPDATE mysql.user SET plugin='mysql_native_password' WHERE User='root' AND host = 'localhost';" && \
sudo mysql -u root -e "FLUSH PRIVILEGES;"
```

#### Create MariaDB User

```sql
CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';
```

#### Remove MariaDB User

```sql
DROP USER 'user'@'localhost';
```

#### Create Database

```sql
CREATE DATABASE mydb;
```

#### Remove Database

```sql
DROP DATABASE mydb;
```

#### Grant Privileges

```sql
GRANT ALL PRIVILEGES ON mydb.* TO 'user'@'localhost';
```

#### Flush Privileges

```sql
FLUSH PRIVILEGES;
```