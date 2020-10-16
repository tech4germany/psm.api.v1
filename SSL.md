### <a name='ssl'></a> SSL einrichten


```bash
[root@centos7 ~] yum install certbot python2-certbot-apache mod_ssl
```

#### <div name='ssl-apache'></a> Apache2

Um vom LetsEncrypt zusätzlich der Zertifikate, auch eine SSL-Konfiguration für den Httpd zu bekommen muss zunächst ein VirtualHost für die domain exisitieren bzw. angelegt werden.

```bash
[root@centos7 ~] nano /etc/httpd/conf.d/api-v1-example.de.conf
```

Inhalt:

```bash
<VirtualHost *:80>
    ServerName api-v1-example.de
    DocumentRoot /var/www/psm/api-v1-example.de/public_html
</VirtualHost>
```

Certbot ausführen:

```bash
[root@centos7 ~] certbot --apache -d api-v1-example.de
```

Output:

```bash
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator apache, Installer apache
Starting new HTTPS connection (1): acme-v02.api.letsencrypt.org
Obtaining a new certificate
Created an SSL vhost at /etc/httpd/conf.d/api-v1-example.de-le-ssl.conf
Deploying Certificate to VirtualHost /etc/httpd/conf.d/api-v1-example.de-le-ssl.conf
Redirecting vhost in /etc/httpd/conf.d/api-v1-example.de.conf to ssl vhost in /etc/httpd/conf.d/api-v1-example.de-le-ssl.conf

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Congratulations! You have successfully enabled https://api-v1-example.de
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/api-v1-example.de/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/api-v1-example.de/privkey.pem
   Your cert will expire on 2021-01-02. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot again
   with the "certonly" option. To non-interactively renew *all* of
   your certificates, run "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Lets Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

Certbot hat die VirtualHost Datei ``api-v1-example.de.conf`` angepasst
und einen permanenten redirect von `http`auf `https` eingerichtet.

```bash
[root@centos7 ~] cat /etc/httpd/conf.d/api-v1-example.de.conf
```

Inhalt:

```bash
<VirtualHost *:80>
    ServerName api-v1-example.de
    DocumentRoot /var/www/psm/api-v1-example.de/public_html
    RewriteEngine on
    RewriteCond %{SERVER_NAME} = api-v1-example.de
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>
```

Die Konfiguration für` https` hat certbot unter ``api-v1-example.de-le-ssl.conf`` erstellt. 

```bash
[root@centos7 ~] cat /etc/httpd/conf.d/api-v1-example.de-le-ssl.conf
```

Inhalt:

```bash
<IfModule mod_ssl.c>
<VirtualHost *:443>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/api-v1-example.de
    ServerName api-v1-example.de
    SSLCertificateFile /etc/letsencrypt/live/api-v1-example.de/cert.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/api-v1-example.de/privkey.pem
    Include /etc/letsencrypt/options-ssl-apache.conf
    SSLCertificateChainFile /etc/letsencrypt/live/api-v1-example.de/chain.pem
</VirtualHost>
</IfModule>
```

Port 443 für SSL freigeben:

```bash
[root@centos7 ~] firewall-cmd --zone=public --add-service=https
```
Seite testen: `https://api-v1-example.de`

#### <a name='ssl-tomcat'></a> Tomcat 

Für den tomcat können die von LetsEncrypt ausgestellten Zertifikatsdateien
kopiert werden. 

```bash
[root@centos7 ~] cd /etc/letsencrypt/live/api-v1-example.de
[root@centos7 ~] cp *.pem /opt/tomcat/latest/conf
[root@centos7 ~] chown tomcat:tomcat *.pem
```

Einen Connector in Tomcats ``server.xml`` mit den Zertifikaten konfigurieren

```bash
[root@centos7 ~] nano /opt/tomcat/latest/conf/server.xml
```

Inhalt:

```bash
<Connector  port="8443" 
            protocol="org.apache.coyote.http11.Http11NioProtocol"
            maxThreads="150" 
            SSLEnabled="true">
    <SSLHostConfig>
        <Certificate certificateKeyFile="conf/privkey.pem"
                     certificateFile="conf/cert.pem"
                     certificateChainFile="conf/chain.pem" />
    </SSLHostConfig>
</Connector>
```
