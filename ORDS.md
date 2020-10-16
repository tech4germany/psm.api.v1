### <a name='ords'></a> ORDS installieren 

ORDS 20.2.1 Download (Version 20.2.1.227.0350 - August 31, 2020) `https://download.oracle.com/otn/java/ords/ords-20.2.1.227.0350.zip`
ORDS kann *entweder* Standalone *oder* auf Tomcat installliert werden.

#### <a name='ords-setup'></a> ORDS Standalone

ORDS entpacken:

```bash
[oracle@centos7 ~] unzip /tmp/ords-20.2.1.227.0350.zip -d /home/oracle/ords
```

ORDS inital einrichten:

```bash
[oracle@centos7 ~] java -jar ords.war install simple
```
```bash
java -jar ords.war install simple
```
```bash
Diese Oracle REST Data Services-Instanz wurde noch nicht konfiguriert.
Nehmen Sie an den folgenden Prompts die entsprechenden Einstellungen vor


Geben Sie den Speicherort für Konfigurationsdaten ein: ords_conf
Name des Datenbankservers eingeben [localhost]:
Listener-Port der Datenbank eingeben [1521]:
1 eingeben, um den Servicenamen der Datenbank anzugeben, oder 2, um die Datenbank-SID anzugeben [1]:2
Datenbank-SID eingeben [xe]:orcl
Datenbankkennwort für ORDS_PUBLIC_USER eingeben:
Kennwort bestätigen:

Informationen werden abgerufen.
Geben Sie 1 ein, wenn Sie das PL/SQL-Gateway verwenden möchten, oder 2, um diesen Schritt zu überspringen.
Wenn Sie Oracle Application Express verwenden oder eine Migration von mod_plsql durchführen, müssen Sie 1 eingeben [1]:2
Geben Sie eine Zahl für die Featureauswahl ein, um Folgendes zu aktivieren:
   [1] SQL Developer Web (aktiviert alle Features)
   [2] REST-fähige SQL
   [3] Datenbank-API
   [4] REST-fähige SQL und Datenbank-API
   [5] Kein Wert
Auswählen [1]:3
2020-10-05T20:14:50.597Z INFO        reloaded pools: []
Okt 05, 2020 8:14:50 PM oracle.dbtools.installer.config.SchemaSetup install
INFORMATION: Oracle REST Data Services-Schemaversion 20.2.1.r2270350 ist installiert.
Geben Sie 1 ein, wenn Sie im Modus "Standalone" starten möchten, oder 2 zum Beenden [1]:1
Geben Sie 1 ein, wenn Sie HTTP verwenden, oder 2, wenn Sie HTTPS verwenden [1]:1
2020-10-05T20:15:01.997Z INFO        HTTP and HTTP/2 cleartext listening on host: localhost port: 8080
2020-10-05T20:15:02.022Z INFO        Disabling document root because the specified folder does not exist: /home/oracle/ords/ords_conf/ords/standalone/doc_root
2020-10-05T20:15:02.805Z INFO        Configuration properties for: |apex|pu|
database.api.enabled=true
db.connectionType=basic
db.hostname=localhost
db.port=1521
db.sid=orcl
db.password=******
db.username=ORDS_PUBLIC_USER
resource.templates.enabled=true

2020-10-05T20:15:02.808Z WARNING     *** jdbc.MaxLimit in Konfiguration |apex|pu| verwendet einen Wert von 10. Diese Einstellung ist für eine Production-Umgebung möglicherweise nicht groß genug ***
2020-10-05T20:15:02.808Z WARNING     *** jdbc.InitialLimit in Konfiguration |apex|pu| verwendet einen Wert von 3. Diese Einstellung ist für eine Production-Umgebung möglicherweise nicht groß genug ***
2020-10-05T20:15:04.931Z INFO        Oracle REST Data Services initialized
Oracle REST Data Services version : 20.2.1.r2270350
Oracle REST Data Services server info: jetty/9.4.28.v20200408
```

ORDS standalone ausführen:

```bash
[oracle@centos7 ~] java -jar ords.war standalone
```

#### <a name='ords-setup-tc9'></a> ORDS Tomcat

Achtung! Bitte nicht den ORDS Ordner der Standalone Installation nutzen.
Für das Deploy in Tomcat sollte ein eigener Ordner erstellt werden, damit der Tomcat User Zugriff darauf bekommen kann.
Andernfalls kann es bei dem Start des Dienstes zu Berechtigungsproblemen kommen.

```bash
su - tomcat
mkdir /u01/ords
cd /u01/ords
unzip /tmp/ords-20.2.1.227.0350.zip -d ords
mkdir -p /u01/ords/conf
```

Editiere die `ords_params.properties`:

```bash
nano /u01/ords/params/ords_params.properties
```

Inhalt:

```bash
db.hostname=localhost
db.port=1521
db.servicename=
db.sid=orcl
db.username=ORDS_PUBLIC_USER
db.password=yourPassword
migrate.apex.rest=false
rest.services.apex.add=
rest.services.ords.add=true
schema.tablespace.default=SYSAUX
schema.tablespace.temp=TEMP
standalone.mode=false
#standalone.http.port=8080
#standalone.static.images=
user.tablespace.default=USERS
user.tablespace.temp=TEMP
sys.user=SYS
sys.password=yourPassword
# Enable REST Enabled SQL.
restEnabledSql.active=false
# Enable SQL Developer Web. Available from 19.4 onward. Requires REST Enabled SQL.
feature.sdw=false
# Enable database APIs. Available from 19.1 onward.
database.api.enabled=false
```

```bash
java -jar ords.war configdir /u01/ords/conf
```

```bash
java -jar ords.war
```

Lock des SYS users.

```bash
ALTER USER SYS ACCOUNT LOCK;
```
ords.war in den tomcat webapps Ordner kopieren:

```bash
cp ords.war /opt/tomcat/latest/webapps/
```

ORDS SQL-Skript ausführen:

Damit die Umlaute im Swagger später korrekt dargestellt werden, muss vor *jedem* Ausführen der Skripte noch `$NLS_LANG` gesetzt werden:

```bash
export NLS_LANG=.AL32UTF8
```
bzw. der Export in der .bash_profile hinzugefügt werden.

Dann können die Deploy Skripte ausgeführt werden:

```bash
sqlplus dbuser/password @<filename>.sql
```

Für eine Beschreibung des Skriptinhalts siehe Abschnitt *Beschreibung der Skripte* in der übergeordneten Readme.

#### <a name="ords-testen"></a> ORDS Testen 

```bash
java -jar ords.war standalone
```

danach  mit `curl` den `open-api-catalog` von intern abrufen:

```bash
curl -X GET http://localhost:8080/ords/psm/open-api-catalog/api-v1/
```

und bspw. im Browser von extern `http://localhost:8080/ords/psm/open-api-catalog/api-v1/`aufrufen.


#### <a name="ords-troubleshooting"></a> ORDS Troubleshooting 

- API ist von intern nicht erreichbar:
  - Prüfen ob der Prozess ohne Fehler gestartet werden konnte
  - Prüfen ob ORDS für das betroffene Datenbankschema aktiviert ist
  - Prüfen ob das `ords_define_psm_service.sql` fehlerfrei ausgeführt wurde
- API ist von extern nicht verfügbar:
  - Prüfen ob der Server erreichbar ist (bspw. `ping`)
  - Prüfen ob Port 8080 nach außen offen ist / Firewall Regeln überprüfen

