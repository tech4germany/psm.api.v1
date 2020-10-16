### <a name="swagger-setup"></a> Swagger einrichten (static) 

Um eine grafische Oberfläche für die nun abrufbare JSON-Swagger-Dokumentation bereitzustellen, kann die SwaggerUI lokal per Webserver installiert werden.

#### Vorbereitung

Unzip installieren:

```bash
[root@centos7 ~] yum install unzip
```

Download Swagger-UI: `https://github.com/swagger-api/swagger-ui`

```bash
[centos@centos7 ~] cd /tmp
[centos@centos7 ~] wget https://github.com/swagger-api/swagger-ui/archive/master.zip
[centos@centos7 ~] unzip master.zip
```

Es wird nur der Ordner `dist` benötigt.

#### <a name="swagger-apache"></a> Betrieb mit Apache2 

```bash
[root@centos7 ~] yum install httpd
[root@centos7 ~] mv /tmp/swagger-ui-master/dist /var/www/psm/
```

Virtuellen Host erstellen und DocumentRoot auf das Swagger-Verzeichnis verweisen:

```bash
<VirtualHost *:80>
    ServerName api-v1-example.de
    DocumentRoot /var/www/psm/dist
    ErrorLog /var/www/psm/api-v1-example.de-error.log
    CustomLog /var/www/example.com/api-v1-example.de-requests.log combined
</VirtualHost>
```
Schreibrechte für die Log-Dateien beachten!

Für den Test-Betrieb ggf. die Indexierung in Suchmaschinen ablehnen, dafür
die Datei `robots.txt` mit folgendem Inhalt erstellen: (bspw. im DocumentRoot)

```bash
User-agent: *
Disallow: /
```

Webserver Konfiguration anpassen:

```bash
root@centos7 ~] nano /etc/httpd/conf/httpd.conf
```

Inhalt:

```bash
<Location "/robots.txt">
    SetHandler None
</Location>
Alias /robots.txt /var/www/dist/robots.txt
```
