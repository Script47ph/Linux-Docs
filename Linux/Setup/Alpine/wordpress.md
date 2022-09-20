## Wordpress Setup - Alpine Linux (v3.15)

### Prerequisite

- Nginx
- Mariadb
- PHP-FPM

> Please install prerequisite before jump to the wordpress installation below.

### Install Wordpress

```bash
rm -rf /var/www/localhost/htdocs/* && \
wget https://wordpress.org/latest.tar.gz  && \
tar -xf latest.tar.gz -C /var/www/localhost/htdocs
```

### Configure Wordpress Database

> Create database name, password, and user you like.

Login to mysql conseole `mysql -u root`

```sql
CREATE DATABASE wordpress;
CREATE USER wordpress@localhost IDENTIFIED BY '<your-password>';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost;
FLUSH PRIVILEGES;
```

Or create with bash command

```bash
export WORDPRESS_DB=wordpress
export WORDPRESS_USER_DB=wordpress
export WORDPRESS_PW_DB=1234567
sudo mysql -u root -e "CREATE DATABASE $WORDPRESS_DB;"
sudo mysql -u root -e "CREATE USER $WORDPRESS_USER_DB@localhost IDENTIFIED BY '$WORDPRESS_PW_DB';"
sudo mysql -u root -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON $WORDPRESS_DB.* TO $WORDPRESS_USER_DB@localhost;"
sudo mysql -u root -e "FLUSH PRIVILEGES;"
```

### Configure WordPress to connect to the database

Copy the sample configuration file to wp-config.php.

```bash
cp /var/www/localhost/htdocs/wordpress/wp-config-sample.php /var/www/localhost/htdocs/wordpress/wp-config.php
```

**Generate Wordpress Secret Key**

Visit [here](https://api.wordpress.org/secret-key/1.1/salt/)

**Configure Credentials**

1. Edit `wp-config.php` using your favorite text editor.
2. Replace below value with your right value:
    - database_name_here "replace with your database name, eg: wordpress"
    - username_here "replace with your wordpress database user, eg: wordpress"
    - password_here "replace with your right database password"
3. Find and delete the following:
    ```php
    define( 'AUTH_KEY',         'put your unique phrase here' );
    define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
    define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
    define( 'NONCE_KEY',        'put your unique phrase here' );
    define( 'AUTH_SALT',        'put your unique phrase here' );
    define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
    define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
    define( 'NONCE_SALT',       'put your unique phrase here' );
    ```
4. Insert wordpress secret key from "Generate Wordpress Secret Key" section above.
    Eg:
    ```php
    define('AUTH_KEY',         'N5BCj!5q?Pb8iqiH*H4 N{sT>lt1_<qo+#fVA`rb2x._#6X&ywzdHFo.=VfC=m?|');
    define('SECURE_AUTH_KEY',  'XF-b8i`a+$L`T9nlO7<cH[5<so+=To!xEGf1-]9>H=v4w CetB<.(xk&Mj7]{kg6');
    define('LOGGED_IN_KEY',    '6XB_7K=k,ZD0HeOYYhq%W/Q@S5[y4(H*-pw:T3`ThuRDEZcJ+Y/01j+IiWucmYxR');
    define('NONCE_KEY',        'A!X<Z-B*:%e[:l+i1vP2@mt0]3|NDiF8}0~q2(0y08.$_>y5>,CK![bleUXv>CL2');
    define('AUTH_SALT',        'Ki%%w&X%]O$R.V&$:Jq2d^3i8T.U;Sx7suZ]N:u,]AR}J7y6(QkX^L;x;#.FqS&.');
    define('SECURE_AUTH_SALT', '$w~s(GLKs)PF+LHta?lYh}/BnUd?5@_Im+KQwa$=NzQ+q^[sueD;a?YE#l-+9l0^');
    define('LOGGED_IN_SALT',   '0 4fu.Z)IF2OmHNKah.LP>K0zk)n+)@rf@i.|#Ua4DgIOgLd@`*/VA&Q;d/Dw#+C');
    define('NONCE_SALT',       'P|$J|XfYuLcX;^oW7}q#-m3Po9FQRjH{-^ZJ7`M+i;E|`>sr(s02GNI2FrPZL+h+');
    ```

### Done

For now, just access the ip server to configure wordpress.
