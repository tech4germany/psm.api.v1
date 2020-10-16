# Fail2Ban

Installieren von fail2ban:

```bash
[root@centos7 ~] yum install fail2ban
```

Aktivieren des fail2ban Dienst:

```bash
[root@centos7 ~] systemctl enable fail2ban
```

## Konfiguration 
Alle Konfigurationsdateien folgen dem [ini-Format](https://de.wikipedia.org/wiki/Initialisierungsdatei).

``Filter`` - Suchmuster / Reguläre Ausrücke

``Actions`` - Kommandos zum Sperren und Entsperren von IP-Adressen


Filter erstellen:

```bash
[root@centos7 ~] nano /etc/fail2ban/filter.d/tomcat.conf
```

Greift bei allen (GET,POST,HEAD) Aufrufen auf die Endpunkte hinter ``/ords`` 

```bash
[Definition]
failregex = <HOST> -.*(GET|POST|HEAD).*/ords
```

Bearbeiten der fail2ban Einstellungen:

```bash
[root@centos7 ~] nano /etc/fail2ban/jail.local
```

Die Konfiguration beginnt mit ein paar wenigen Default Einstellungen.
Die Defaultwerte greifen immer wenn nichts gegenteiliges definiert ist,
z.B. wenn in einem Jail keine Bantime gesetzt ist, werden die 5 min aus dem Default Block verwendet.
Jails sind eine konkrete Kombination aus ``Actions`` und ``Filter``.   

```bash
[DEFAULT]
# Host für 5 Minuten sperren
bantime=300

#Override /etc/fail2ban/jail.d/00-firewalld.conf
banaction = iptables-multiport

# Leerzeichenseparierte Liste von zu ignorierenden IPs oder Netzwerken.
ignoreip = 127.0.0.1/8

# Die Anzahl der Sekunden nach dem der Zähler für maxretry zurückgesetzt wird.
findtime = 600

#Die maximale Anzahl an Versuchen, bevor fail2ban die IP bannt.
maxretry = 3

[sshd]
enabled = true
```

### <a name='fail2ban-tomcat'/></a> Tomcat Jail (Rate Limits)
Generell können die Einstellungen hier nur exemplarisch sein,
die Konfiguration sollte immer auf die eigenen Bedürfnisse angepasst und getestet werden.


   |           |                                                                              |
   |----------:|:-----------------------------------------------------------------------------|
   | enabled   | Aktiviert das jail                                                           |
   | port      | Mehrere Werte werden durch Kommata getrennt                                  |
   | filter    | Name der Filterdatei                                                         |
   | logpath   | Die zu überwachende Logdatei, die mit dem Filter geprüft wird.               |
   | maxretry  | Die maximale Anzahl an Fehlversuchen, bevor fail2ban die IP bannt.           |
   | bantime   | Bannzeit in Sekunden. Ein negativer Wert ist ein permanenter Bann.           |
   | findtime  | Die Anzahl der Sek. nach dem der Zähler für maxretry zurückgesetzt wird.     |
   |           |                                                                              |

Für den Tomcat werden im folgenden 5 Jails konfiguriert,
die auf einander aufbauen.
##### Stage 1: 

300 Requests innerhalb von 60 Sek. - 90 Sek. Sperre 

```bash
[tomcat-stage1]
enabled = true
port = 8080,8443
filter = tomcat
logpath = /opt/tomcat/latest/logs/localhost_access_log.txt
maxretry = 300
findtime=60
bantime=90
```
##### Stage 2: 
3000 Requests in 10 Min. - 15 Min. Sperre
```bash
[tomcat-stage2]
enabled = true
port = 8080,8443
filter = tomcat
logpath = /opt/tomcat/latest/logs/localhost_access_log.txt
maxretry = 3000
findtime=600
bantime=900
```
##### Stage 3: 
10000 Requests pro Stunde - 1,5 Std. Sperre
```bash
[tomcat-stage3]
enabled = true
port = 8080,8443
filter = tomcat
logpath = /opt/tomcat/latest/logs/localhost_access_log.txt
maxretry = 10000
findtime=3600
bantime=5400
```
##### Stage 4: 
50000 Request innerhalb von 12 Stunden - 18 Std. Sperre
```bash
[tomcat-stage4]
enabled = true
port = 8080,8443
filter = tomcat
logpath = /opt/tomcat/latest/logs/localhost_access_log.txt
maxretry = 50000
findtime=43200
bantime=64800
```
##### Stage 5: 
100000 Request pro Tag - 1 Tag Sperre
```bash
[tomcat-stage5]
enabled = true
port = 8080,8443
filter = tomcat
logpath = /opt/tomcat/latest/logs/localhost_access_log.txt
maxretry = 100000
findtime=86400
bantime=86400
```

```bash
[root@centos7 ~] service fail2ban restart
```

## <a name='fail2ban-apache'/></a> Apache2 Jails
Filter erstellen:

```bash
[root@centos7 ~] nano /etc/fail2ban/filter.d/http-get-dos.conf
```

Greift bei allen (GET,POST) Aufrufen auf Port 80 und 443.
```bash
[Definition]
failregex = ^<HOST> -.*"(GET|POST).*
```

```bash
[root@centos7 ~] nano /etc/fail2ban/jail.local
```


100 Request in 5 Min. - 12 Std. Sperre
```bash
...

[http-get-dos]
enabled = true
port = http,https
filter = http-get-dos
logpath = /var/log/httpd/access_log
maxretry = 100
findtime = 300
bantime = 43200
```

```bash
[root@centos7 ~] service fail2ban restart
```

### <a name='fail2ban-bots'/></a> Bad Bots

Die verwendeten Filter ``apache-nohome`` und ``apache-noscript`` werden bereits fail2ban mitgeliefert.

```bash
[root@centos7 ~] nano /etc/fail2ban/jail.local
```

2 Request in 5 Min. - 12 Std. Sperre
```bash
...

[apache-nohome]
enabled = true
port = http,https
filter = apache-nohome
logpath = /var/log/httpd/error_log
maxretry = 2
findtime = 300
bantime = 43200

[apache-noscript]
enabled = true
port = http,https
filter = apache-noscript
logpath = /var/log/httpd/error_log
maxretry = 2
findtime = 300
bantime = 43200
```

```bash
[root@centos7 ~] service fail2ban restart
```
