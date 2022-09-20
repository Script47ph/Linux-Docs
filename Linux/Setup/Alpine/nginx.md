## Nginx Setup - Alpine Linux (v3.15)


### Update Repository

```
sudo apk update
```

### Install Nginx

```
sudo apk add nginx
```

### Configure Virtualhost

Configure nginx virtualhost setting at `/etc/nginx/http.d/default.conf`

```
sudo vim /etc/nginx/http.d/default.conf
```

```conf
server {
    # Listen Port
    listen 80;
    listen [::]:80;

    # Server Name
    server_name _;

    # Index File
    index   index.php index.html index.htm;
    
    # Root Directory
    set $docroot "htdocs";
    if (-d "/var/www/localhost/htdocs/public") {
        set $docroot "htdocs/public";
    }
    if (-d "/var/www/localhost/htdocs/wordpress") {
        set $docroot "htdocs/wordpress";
    }
    root "/var/www/localhost/${docroot}";

    # Error Page
    error_page              500 502 503 504  /50x.html;
    location = /50x.html {
        root /var/lib/nginx/html;
    }

    # Enable below for activate php website
    # Url rewrite php
    #if (!-e $request_filename) {
    #    rewrite ^.*$ /index.php last;
    #}
    # Location
    #location / {
    #    try_files $uri $uri/ /index.php?$query_string;
    #}
    #location ~ \.php$ {
    #    fastcgi_pass 0.0.0.0:9000;
    #    fastcgi_index index.php;
    #    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    #    fastcgi_param PATH_INFO $fastcgi_path_info;
    #    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    #    fastcgi_buffers 16 16k;
    #    fastcgi_buffer_size 32k;
    #    include fastcgi_params;
    #}

    # Htaccess access permission
    location ~ /\.ht {
        deny all;
    }

}
```

### Add Simple Index Page

Create index page at `/var/www/localhost/htdocs/index.html`

```bash
cat <<EOF | sudo tee /var/www/localhost/htdocs/index.html > /dev/null
<!DOCTYPE html>
<html>
<head>
    <title>Alpine Linux</title>
</head>
<body>
    <h1>Alpine Linux</h1>
</body>
</html>
EOF
```

### Nginx Service

**Start**

```bash
sudo rc-service nginx start
```

**Status**

```bash
sudo rc-service nginx status
```

**Stop**

```bash
sudo rc-service nginx stop
```

**Restart**

```bash
sudo rc-service nginx restart
```

### Runlevel

Normally you want to start service when the system is launching. This is done by adding to the needed runlevel.

```bash
sudo rc-update add nginx default
```
