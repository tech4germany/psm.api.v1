# Tomcat 9 installieren 

Tomcat Benutzer anlegen:

```bash
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
```

Tomcat Download:

```bash
cd /tmp
wget https://www-eu.apache.org/dist/tomcat/tomcat-9/v9.0.37/bin/apache-tomcat-9.0.37.tar.gz
tar -xf apache-tomcat-9.0.37.tar.gz
sudo mv apache-tomcat-9.0.37 /opt/tomcat/
```

Tomcat 9 wird regelmäßig upgedatet. Um mehr Kontrolle über Versionen und Updates zu haben, erstellen wir einen Symbolic Link, der `latest` heißt, der auf den Tomcat Installationsordner zeigt:

```bash
sudo ln -s /opt/tomcat/apache-tomcat-9.0.37 /opt/tomcat/latest
```

User/Group setzen, Berechtigungen vergeben:

```bash
sudo chown -R tomcat: /opt/tomcat
sudo sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'
```

Service Unit Datei erstellen:

```bash
sudo nano /etc/systemd/system/tomcat.service
```

Ändere `/etc/systemd/system/tomcat.service`:

```bash
[Unit]
Description=Tomcat 9 servlet container
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/jre"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"

Environment="CATALINA_BASE=/opt/tomcat/latest"
Environment="CATALINA_HOME=/opt/tomcat/latest"
Environment="CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/latest/bin/startup.sh
ExecStop=/opt/tomcat/latest/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
```

Änderungen für systemd sichtbar machen:

```bash
sudo systemctl daemon-reload
```

URI Sonderzeichen für Query-Filter Parameter erlauben:

```bash
<Valve className="org.apache.catalina.valves.AccessLogValve"
       directory="logs" 
       prefix="localhost_access_log" 
       suffix=".txt" 
       rotatable="false" 
       resolveHost="false" 
       pattern="%h %l %u %t "%r" %s %b "%{Referer}i" "%{User-Agent}i""/>
```

#### <a name='logging'></a> Logging 

log rotation mit cron konfigurieren:

```bash
[root@centos7 ~] nano /opt/tomcat/latest/conf/server.xml
```

Inhalt:

```bash
<Valve className="org.apache.catalina.valves.AccessLogValve" 
    directory="logs"
    prefix="localhost_access_log" 
    suffix=".txt" 
    rotatable="false"   
    resolveHosts="false"
    pattern="%a %l %u %t &quot;%r&quot; %s %b &quot;%{Referer}i&quot; &quot;%{User-Agent}i&quot;" />
```

cron job für log file rotation erstellen:

```bash
[root@centos7 ~] crontab -e
```

Inhalt:

```bash
00 00 * * * /bin/cp /var/log/tomcat7/localhost_access_log.txt /var/log/tomcat7/localhost_access_log.$(/bin/date +\%Y-\%m-\%d -d "yesterday").txt && /usr/bin/truncate -s 0 /var/log/tomcat7/localhost_access_log.txt
```

Tomcat Service starten:

```bash
[root@centos7 ~] service tomcat restart
```

Gegebenfalls Tomcat in den Autostart einfügen

```bash
sudo systemctl enable tomcat
```

Tomcat starten:

```bash
sudo systemctl start tomcat
sudo systemctl status tomcat
```

Gegebenfalls Port 8080 in der Firewall freigeben:

```bash
sudo firewall-cmd --zone=public --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```
