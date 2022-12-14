## Nginx Setup - Ubuntu

### Update Repository

    sudo apt update

### Install Nginx

    sudo apt install nginx

## Additional
### Virtualhost
#### Create Virtualhost Root Directory

By default on ubuntu/debian based linux, source of web root directory is `/var/www/html`. 

In this directory include, eg:

- index.html

You can customize web root directory for virtualhost configuration where you like. Eg: `/var/www/yourdomain.com/public_html` or `/srv/www/yourdomain.com/public_html`.

    sudo mkdir -p /var/www/yourdomain.com/public_html

#### Create Simple Website

    cat <<EOF | sudo tee /var/www/yourdomain.com/public_html/index.html > /dev/null
    It Works! This is your simple virtualhost website running on Nginx Webserver.
    Your domain is yourdomain.com
    EOF

#### Create Virtualhost Configuration

Configuration of virtualhost can be created in `/etc/nginx/sites-available/` directory with no extension. By default nginx come with default virtualhost configuration name `default` file. For easy practicing just copy that file for additional virtualhost configuration.

    sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/yourdomain

> yourdomain is just for easyly practicing, that not actual config. You can choose whatever name you like for it.

Edit `yourdomain` with text editor like nano/vim and delete all lines until `# Virtual Host configuration for example.com`.

Uncomment below:

```conf
server {
       listen 80;
       listen [::]:80;

       server_name yourdomain.com; # Replace with your actually domain name

       root /var/www/yourdomain.com; # Replace with your actually right directory
       index index.html;

       location / {
               try_files $uri $uri/ =404;
       }
}
```

#### Disable Default Virtualhost

The new virtualhost can't access yet because the default virtualhost still enabled. Disabled with this command:

    sudo rm /etc/nginx/sites-enabled/default

#### Enable New Virtualhost

Bring up new virtualhost with this command:

    sudo ln -s /etc/nginx/sites-available/yourdomain /etc/nginx/sites-enabled/

#### Restart Nginx

Any changes configuration must be restart/reload service first for take effect.

    sudo systemctl restart nginx

### SSL/TLS Virtualhost

```conf
server {
    # Listeing HTTPS Port
    listen 443 ssl;
    listen [::]:443 ssl ipv6only=on;

    # SSL/TLS Certificate
    ssl_certificate <yourdirectoriy>/fullchain.pem;
    ssl_certificate_key <yourdirectory>/privkey.pem;
    # ssl_dhparam <yourdirectory>/ssl-dhparams.pem;

    # Server Name 
    server_name yourdomain.com;

    # Index File
    index   index.php index.html index.htm;
    
    # Root Directory
    # Set root directory as "public_html"
    set $docroot "public_html";
    # If directory "public" exist, set root directory as "public"
    if (-d "/var/www/yourdomain.com/public_html/public") {
        set $docroot "public_html/public";
    }
    # If directory "wordpress" exist, set root directory as "wordpress"
    if (-d "/var/www/yourdomain.com/public_html/wordpress") {
        set $docroot "public_html/wordpress";
    }
    root "/var/www/yourdomain.com/${docroot}";

    location / {
            try_files $uri $uri/ =404;
    }

    # Htaccess access permission
    location ~ /\.ht {
        deny all;
    }
}
server {
    # Listeing HTTP Port
    listen 80;
    listen [::]:80;

    # Server Name 
    server_name yourdomain.com;

    # Redirect to HTTPS
    if ($host = yourdomain.com) {
        return 301 https://$host$request_uri;
    }
    return 404;
}
```

### Reverse Proxy

```conf
upstream backend {
    server 192.168.30.11;
}
server {
    listen 80;
    listen [::]:80;

    server_name yourdomain.com;

    location / {
        proxy_pass http://backend;
    }
}