## PHP-FPM7 Setup - Alpine Linux (v3.15)


### Update Repository

```
apk update
```

### Install PHP7
PHP packages is available in the Alpine Linux repositories. To install php7 with modules run: 

```
apk add php7 php7-fpm php7-mcrypt php7-soap php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype php7-xmlwriter php7-tokenizer php7-mbstring php7-phar
```

Perhaps you do not need all these PHP modules. Install modules according to your needs.

### Configuration of PHP7

Defining ENV variables which will be used in configuration. You can do this e.g. in `/etc/profile.d/php7.sh`. 

```bash
cat <<EOF | tee /etc/profile.d/php7.sh > /dev/null
PHP_FPM_USER="nginx"
PHP_FPM_GROUP="nginx"
PHP_FPM_LISTEN_MODE="0660"
PHP_MEMORY_LIMIT="512M"
PHP_MAX_UPLOAD="50M"
PHP_MAX_FILE_UPLOAD="200"
PHP_MAX_POST="100M"
PHP_DISPLAY_ERRORS="On"
PHP_DISPLAY_STARTUP_ERRORS="On"
PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
PHP_CGI_FIX_PATHINFO=0
EOF
```

Modify variables according to your needs. After that load the script.

```bash
source /etc/profile.d/php7.sh
```

**Modifying configuration file www.conf**

```bash
sed -i "s|\[www\]|\[${PHP_FPM_USER}\]|g" /etc/php7/php-fpm.d/www.conf && \
sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/www.conf && \
sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/www.conf && \
sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php7/php-fpm.d/www.conf && \
sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/www.conf && \
sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/www.conf && \
sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php7/php-fpm.d/www.conf 
```

**Modifying configuration file php.ini**

```bash
sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php7/php.ini && \
sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php7/php.ini && \
sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php7/php.ini && \
sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini && \
sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php7/php.ini && \
sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini && \
sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini && \
sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php7/php.ini
```

### Timezone

For configuring Timezone you may use tzdata package which can be installed by running:

```bash
apk add tzdata
```

**Timezone configuration**

```bash
TIMEZONE="Asia/Jakarta" && \
cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
echo "${TIMEZONE}" > /etc/timezone && \
sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php7/php.ini
```

### PHP-FPM Service

**Start**

```bash
rc-service php-fpm7 start
```

**Status**

```bash
rc-service php-fpm7 status
```

**Stop**

```bash
rc-service php-fpm7 stop
```

**Restart**

```bash
rc-service php-fpm7 restart
```

### Runlevel

Normally you want to start service when the system is launching. This is done by adding to the needed runlevel.

```bash
rc-update add php-fpm7 default
```


### Sample PHP page

For checking php from web

```php
<?php
	phpinfo();
?>
```
