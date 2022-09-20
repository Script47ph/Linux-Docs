## Apache2 Setup - Ubuntu

### Update Repository

    sudo apt update

### Install Apache

    sudo apt install apache2

## Additional
### Virtualhost

Virtual Host refers to the practice of running more than one web site (such as company1.example.com and company2.example.com) on a single machine. Virtual hosts can be "IP-based", meaning that you have a different IP address for every web site, or "name-based", meaning that you have multiple names running on each IP address. The fact that they are running on the same physical server is not apparent to the end user.

Apache was one of the first servers to support IP-based virtual hosts right out of the box. Versions 1.1 and later of Apache support both IP-based and name-based virtual hosts (vhosts). The latter variant of virtual hosts is sometimes also called host-based or non-IP virtual hosts.

#### Create Virtualhost Root Directory

By default on ubuntu/debian based linux, source of web root directory is `/var/www/html`. 

In this directory include, eg:

- index.html

You can customize web root directory for virtualhost configuration where you like. Eg: `/var/www/yourdomain.com/public_html` or `/srv/www/yourdomain.com/public_html`.

    sudo mkdir -p /var/www/yourdomain.com/public_html

#### Create Simple Website

    cat <<EOF | sudo tee /var/www/yourdomain.com/public_html/index.html > /dev/null
    It Works! This is your simple virtualhost website running on Apache Webserver.
    Your domain is yourdomain.com
    EOF

#### Create Virtualhost Configuration

Configuration of virtualhost can be created in `/etc/apache2/sites-available/` directory with `.conf` extension. By default apache come with default virtualhost configuration name `000-default.conf` file. For easy practicing just copy that file for additional virtualhost configuration.

    sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/yourdomain.conf

> yourdomain.conf is just for easyly practicing, that not actual config. You can choose whatever name you like for it.

Edit `yourdomain.conf` with text editor like nano/vim and change the following with the right value:

```conf
ServerAdmin webmaster@localhost # Change localhost with your domain or just disabled it
ServerName yourdomain.com # Add and change with your actually domain name
DocumentRoot /var/www/html # Replace with your root virtualhost directory contain html file
```

#### Disable Default Virtualhost

The new virtualhost can't access yet because the default virtualhost still enabled. Disabled with this command:

    cd /etc/apache2/sites-available/
    sudo a2dissite 000-default.conf

#### Enable New Virtualhost

Bring up new virtualhost with this command:

    sudo a2ensite yourdomain.conf

#### Reload or Restart Apache

Any changes configuration must be restart/reload service first for take effect.

    sudo systemctl reload apache2
    sudo systemctl restart apache2


### SSL Configuration

#### Manual

Add the following to your virtualhost configuration file:

```conf
<VirtualHost *:443>
    ServerAdmin webmaster@yourdomain.com
    ServerName yourdomain.com
    ServerAlias www.yourdomain.com
    DocumentRoot /var/www/yourdomain.com/public_html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    SSLEngine on
    SSLCertificateFile /directory/where/you/save/certificate/yourcrt.pem
    SSLCertificateKeyFile /directory/where/you/save/certificate/privkey.pem
</VirtualHost>
```

#### Using Certbot

Reference from [DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-secure-apache-with-let-s-encrypt-on-ubuntu-20-04)

**Install Dependencies**

    sudo apt install certbot python3-certbot-apache

**Obtaining an SSL Certificate**

Certbot provides a variety of ways to obtain SSL certificates through plugins. The Apache plugin will take care of reconfiguring Apache and reloading the configuration whenever necessary. To use this plugin, type the following:

    sudo certbot --apache

This script will prompt you to answer a series of questions in order to configure your SSL certificate. First, it will ask you for a valid e-mail address. This email will be used for renewal notifications and security notices:

    Output
    Saving debug log to /var/log/letsencrypt/letsencrypt.log
    Plugins selected: Authenticator apache, Installer apache
    Enter email address (used for urgent renewal and security notices) (Enter 'c' to
    cancel): you@yourdomain.com

After providing a valid e-mail address, hit ENTER to proceed to the next step. You will then be prompted to confirm if you agree to Let’s Encrypt terms of service. You can confirm by pressing A and then ENTER:

    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Please read the Terms of Service at
    https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf. You must
    agree in order to register with the ACME server at
    https://acme-v02.api.letsencrypt.org/directory
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    (A)gree/(C)ancel: A

Next, you’ll be asked if you would like to share your email with the Electronic Frontier Foundation to receive news and other information. If you do not want to subscribe to their content, type N. Otherwise, type Y. Then, hit ENTER to proceed to the next step.

    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Would you be willing to share your email address with the Electronic Frontier
    Foundation, a founding partner of the Let's Encrypt project and the non-profit
    organization that develops Certbot? We'd like to send you email about our work
    encrypting the web, EFF news, campaigns, and ways to support digital freedom.
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    (Y)es/(N)o: N

The next step will prompt you to inform Certbot of which domains you’d like to activate HTTPS for. The listed domain names are automatically obtained from your Apache virtual host configuration, that’s why it’s important to make sure you have the correct ServerName and ServerAlias settings configured in your virtual host. If you’d like to enable HTTPS for all listed domain names (recommended), you can leave the prompt blank and hit ENTER to proceed. Otherwise, select the domains you want to enable HTTPS for by listing each appropriate number, separated by commas and/ or spaces, then hit ENTER.

    Which names would you like to activate HTTPS for?
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    1: yourdomain.com
    2: www.yourdomain.com
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Select the appropriate numbers separated by commas and/or spaces, or leave input
    blank to select all options shown (Enter 'c' to cancel): 

You’ll see output like this:

    Obtaining a new certificate
    Performing the following challenges:
    http-01 challenge for yourdomain.com
    http-01 challenge for www.yourdomain.com
    Enabled Apache rewrite module
    Waiting for verification...
    Cleaning up challenges
    Created an SSL vhost at /etc/apache2/sites-available/yourdomain.com-le-ssl.conf
    Enabled Apache socache_shmcb module
    Enabled Apache ssl module
    Deploying Certificate to VirtualHost /etc/apache2/sites-available/yourdomain.com-le-ssl.conf
    Enabling available site: /etc/apache2/sites-available/yourdomain.com-le-ssl.conf
    Deploying Certificate to VirtualHost /etc/apache2/sites-available/yourdomain.com-le-ssl.conf

Next, you’ll be prompted to select whether or not you want HTTP traffic redirected to HTTPS. In practice, that means when someone visits your website through unencrypted channels (HTTP), they will be automatically redirected to the HTTPS address of your website. Choose 2 to enable the redirection, or 1 if you want to keep both HTTP and HTTPS as separate methods of accessing your website.

    Please choose whether or not to redirect HTTP traffic to HTTPS, removing HTTP access.
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    1: No redirect - Make no further changes to the webserver configuration.
    2: Redirect - Make all requests redirect to secure HTTPS access. Choose this for
    new sites, or if you're confident your site works on HTTPS. You can undo this
    change by editing your web server's configuration.
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Select the appropriate number [1-2] then [enter] (press 'c' to cancel): 2

After this step, Certbot’s configuration is finished, and you will be presented with the final remarks about your new certificate, where to locate the generated files, and how to test your configuration using an external tool that analyzes your certificate’s authenticity:

    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Congratulations! You have successfully enabled https://yourdomain.com and
    https://www.yourdomain.com

    You should test your configuration at:
    https://www.ssllabs.com/ssltest/analyze.html?d=yourdomain.com
    https://www.ssllabs.com/ssltest/analyze.html?d=www.yourdomain.com
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    IMPORTANT NOTES:
    - Congratulations! Your certificate and chain have been saved at:
    /etc/letsencrypt/live/yourdomain.com/fullchain.pem
    Your key file has been saved at:
    /etc/letsencrypt/live/yourdomain.com/privkey.pem
    Your cert will expire on 2020-07-27. To obtain a new or tweaked
    version of this certificate in the future, simply run certbot again
    with the "certonly" option. To non-interactively renew *all* of
    your certificates, run "certbot renew"
    - Your account credentials have been saved in your Certbot
    configuration directory at /etc/letsencrypt. You should make a
    secure backup of this folder now. This configuration directory will
    also contain certificates and private keys obtained by Certbot so
    making regular backups of this folder is ideal.
    - If you like Certbot, please consider supporting our work by:

    Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
    Donating to EFF:                    https://eff.org/donate-le

Your certificate is now installed and loaded into Apache’s configuration. Try reloading your website using https:// and notice your browser’s security indicator. It should point out that your site is properly secured, typically by including a lock icon in the address bar.

You can use the SSL Labs Server Test to verify your certificate’s grade and obtain detailed information about it, from the perspective of an external service.

In the next and final step, we’ll test the auto-renewal feature of Certbot, which guarantees that your certificate will be renewed automatically before the expiration date.

**Verifying Certbot Auto-Renewal**

Let’s Encrypt’s certificates are only valid for ninety days. This is to encourage users to automate their certificate renewal process, as well as to ensure that misused certificates or stolen keys will expire sooner rather than later.

The certbot package we installed takes care of renewals by including a renew script to /etc/cron.d, which is managed by a systemctl service called certbot.timer. This script runs twice a day and will automatically renew any certificate that’s within thirty days of expiration.

To check the status of this service and make sure it’s active and running, you can use:

    sudo systemctl status certbot.timer

You’ll get output similar to this:

    Output
    ● certbot.timer - Run certbot twice daily
        Loaded: loaded (/lib/systemd/system/certbot.timer; enabled; vendor preset: enabled)
        Active: active (waiting) since Tue 2020-04-28 17:57:48 UTC; 17h ago
        Trigger: Wed 2020-04-29 23:50:31 UTC; 12h left
    Triggers: ● certbot.service

    Apr 28 17:57:48 fine-turtle systemd[1]: Started Run certbot twice daily.

To test the renewal process, you can do a dry run with certbot:

    sudo certbot renew --dry-run

If you see no errors, you’re all set. When necessary, Certbot will renew your certificates and reload Apache to pick up the changes. If the automated renewal process ever fails, Let’s Encrypt will send a message to the email you specified, warning you when your certificate is about to expire.

### Reverse Proxy

Reference from [DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-use-apache-http-server-as-reverse-proxy-using-mod_proxy-extension-ubuntu-20-04)

**Enable Apache Modules**

    sudo a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests

**Proxy Configuration**

Add the following to the virtualhost configuration files.

    <VirtualHost *:80>
        ProxyPreserveHost On

        ProxyPass / http://127.0.0.1:8080/
        ProxyPassReverse / http://127.0.0.1:8080/
    </VirtualHost>

There are three directives represented, here’s a brief overview of what they’re doing:

- ProxyPreserveHost: makes Apache pass the original Host header to the backend server. This is useful, as it makes the backend server aware of the address used to access the application.
- ProxyPass: the main proxy configuration directive. In this case, it specifies that everything under the root URL (/) should be mapped to the backend server at the given address. For example, if Apache gets a request for /example, it will connect to http://your_backend_server/example and return the response to the original client.
- ProxyPassReverse: should have the same configuration as ProxyPass. It tells Apache to modify the response headers from the backend server. This makes sure that if the backend server returns a location redirect header, the client’s browser will be redirected to the proxy address and not the backend server address, which would not work as intended.

**Double Proxy/Load Balancing Across Multiple Backend Servers Configuration**

Add the following to the virtualhost configuration files.

    <VirtualHost *:80>
    <Proxy balancer://mycluster>
        BalancerMember http://127.0.0.1:8080
        BalancerMember http://127.0.0.1:8081
    </Proxy>

        ProxyPreserveHost On

        ProxyPass / balancer://mycluster/
        ProxyPassReverse / balancer://mycluster/
    </VirtualHost>

The configuration is similar to the previous one, but instead of specifying a single backend server directly, these directives are doing the following:

- Proxy: this additional Proxy block is used to define multiple servers. The block is named balancer://mycluster (the name can be freely altered) and consists of one or more BalancerMembers, which specify the underlying backend server addresses.
- ProxyPass and ProxyPassReverse: these directives use the load balancer pool named mycluster` instead of a specific server.

If you followed along with the example servers in Step 2, use 127.0.0.1:8080 and 127.0.0.1:8081 for the BalancerMember directives, as written in the block above. If you have your own application servers, use their addresses instead.

Once you’re done adding this content, save and exit the file.
