# PSM Service GitHub Dokumentation

Dieses Repository ist ein Ergebnis des Projekts "Maschinenlesbare Bereitstellung von Pflanzenschutzmittelzulassungsdaten für die Anwendung im Precision Farming" von Tech4Germany. Es beschreibt die Installation von einer Infrastruktur, an der die Pflanzenschutzmittel-Datenbank mit einer Schnittstelle (API) des BVL selbst aufgesetzt werden kann und diese mit Unit-Tests überprüft werden kann. Ferner können die Unit-Tests auch genutzt werden, um die in Zukunft vom BVL zur Verfügung gestellte API zu testen.

Dieses Projekt hat daher zwei Anwendungsfälle:

1. Das Aufsetzen einer REST Schnittstelle mittels ORDS auf der Pflanzenschutzmitteldatenbank des BVL.
2. Das Testen der REST Schnittstelle mithilfe von Unit Tests.

Das BVL übernimmt keinerlei Haftungen und steht in keinem Zusammenhang zu diesem Repository.

## Inhaltsverzeichnis <div id="inhaltsverzeichniss"/>

- [Voraussetzungen](#prerequirements)
- [SQL-Deploymentskripte](#skripte)
- [Deployment: PSM-API-V1 mit ORDS (Centos7)](#setup)
  - [Oracle 12c installieren](#oracle-setup)
  - [Tomcat 9 installieren](#tomcat-setup)
  - [ORDS installieren](#ords)
    - [ORDS Standalone](#ords-setup)
    - [ORDS Tomcat](#ords-setup-tc9)
  - [Swagger einrichten (static)](#setup-swagger)
  - [SSL einrichten (LetsEncrypt)](#ssl)
    - [Apache2](#ssl-apache)
    - [Tomcat](#ssl-tomcat)
  - [Fail2Ban](#fail2ban)
- [Testen der API](#tests)

## <a name='prerequirements'></a> Voraussetzungen

- Dumpfile der Zulassungsdaten [psm.dmp](database/oracle/psm.dmp)
- Centos7
- Oracle 12c
- ORDS 20.2
- Tomcat 9
- Apache2 
- fail2ban 

## <a name='skripte'></a> SQL-Deploymentskripte 

Dieser Abschnitt beschreibt die Skripte, welche während eines Deployments ausgeführt werden.

Für eine Dokumentation der einzelnen aufgerufenen Methoden, wie `ORDS.define_module()` und `ORDS.define_handler()` siehe die [ORDS Dokumentation](https://docs.oracle.com/cd/E56351_01/doc.30/e87809/ORDS-reference.htm#AELIG90180).

### Skript: [ords_disable_schema.sql](database/oracle/scripts/v1.0/ords_disable_schema.sql)

Für den Fall, dass bereits ein Datenbankschema für ORDS aktiviert ist, muss dieses erst deaktiviert werden bevor es wieder aktiviert werden kann. 
Dafür muss nur das Skript auf dem betroffenen Schema ausgeführt werden.

### Skript: [ords_enable_schema.sql](database/oracle/scripts/v1.0/ords_enable_schema.sql)

Um ORDS auf einzelnen Tabellen aktivieren zu können, muss zunächst das Schema, dem die Tabellen zugehören, aktiviert werden. 
Dazu kann dieses Skript auf dem betroffenen Schema ausgeführt werden.

### Skript: [ords_define_psm_service.sql](database/oracle/scripts/v1.0/ords_define_psm_service.sql)

Mit diesem SQL Skript wird ein ORDS API Endpunkt auf allen 40 vorhandenen BVL-DB Tabellen aktiviert. Dafür wird zu Beginn ein Module definiert, dem dann Templates und Handler für jede einzelne Tabelle hinzugefügt werden. In den p_comments Argumenten steht zusätzlich für jeden Endpunkt eine Beschreibung der Tabelle/des Endpunkts und der Parameter.

In Eclipse wird das TestNG Plugin benötigt.

## <a name='setup'></a> Deployment: PSM-API-V1 mit ORDS (Centos7)

Checklist:

- [ ] Domain bzw. Subdomain vorhanden
- [ ] Server bzw. virtuelle Maschine vorhanden
- [ ] Oracle ist installiert (siehe: [Installation Oracle](Oracle12.md)) 
- [ ] ORDS ist installiert und konfiguriert (siehe: [ORDS](#ords))
- [ ] Swagger-UI läuft (optional) (siehe: [Swagger-UI Setup](#swagger-setup)).


### <a name='oracle-setup'></a> Oracle 12c installieren 

Zur Installationsanleitung für Oracle: [Installation Oracle](Oracle12.md)

### Daten importieren

#### Datenbank Benutzer und Rollen erstellen

##### Skript: [create_user_and_roles.sql](database/oracle/scripts/v1.0/create_user_and_roles.sql)

```bash
/***********************************************************************
  Erstellt den Benutzer "psm" sowie eine Rolle mit Berechtigungen 
  für den import und eine readOnly Rolle
***********************************************************************/
-- Benutzer psm anlegen
CREATE USER psm IDENTIFIED BY yourPassword;

-- Benutzer psm die Berechtigung für unlimited tablespace geben
GRANT UNLIMITED TABLESPACE TO psm;

-- rolle für den import inkl. der notwendigen Berechtigungen erstellen
CREATE ROLE psm_imp;
GRANT CONNECT, CREATE SESSION, IMP_FULL_DATABASE TO psm_imp;

-- die import rolle dem Benutzer psm zuweisen
GRANT psm_imp TO psm;

-- rolle mit readOnly Berechtigung erstellen
CREATE ROLE PSM_READONLY;
GRANT CONNECT, CREATE SESSION TO PSM_READONLY;

-- die readOnly Rolle den Benutzer psm zuweisen
GRANT PSM_READONLY TO PSM;

/***********************************************************************
  Um auf readOnly Berchtigungen umzustellen,
  wird die unlimited tablespace Berechtigung dem Benutzer psm entzogen, 
  und die Zuweisung der import rolle entfernt.
***********************************************************************/
--REVOKE UNLIMITED TABLESPACE FROM psm;
--REVOKE psm_imp FROM psm;
```

#### Datenbank Dump einspielen

Dumpfile [psm.dmp](database/oracle/psm.dmp)

```bash
imp psm/yourPassword file="psm.dmp" full=y;
```

### <a name='tomcat-setup'></a> Tomcat 9 installieren 
  
[Installationsanleitung für Tomcat 9](Tomcat9.md)

### <a name='ords'></a> ORDS installieren 

[Anleitung für das ORDS Setup](ORDS.md)

Anschließend können die [Deployment Skripte](#skripte) ausgeführt werden. 

### <a name="swagger-setup"></a> Swagger einrichten

Apache 2 und [Swagger UI](Swagger.md).

### <a name='ssl'></a> SSL einrichten

[SSL Zertifikate für Apache2 und Tomcat mit LetsEncrypt](SSL.md).

## <a name='fail2ban'></a>Fail2Ban
Konfigurationsbeispiele für Request Limits und einfachen Schutz vor DoS Attacken mit [fail2ban](Fail2ban.md).

## <a name='tests'></a> Testen
Kurze Beschreibung der RestAssured und Postman [Tests](Tests.md).

## Code Generierung

Zur Generierung von Java Klassen kann [Telosys](https://www.telosys.org/) verwendet werden.
Bereits generierte Klassen sind im Ordner [dto](src/main/java/psm/library/dto) zu finden.
Alle Dto Klassen wurden mit einer [angepassten Version](codegen/domain/domain_entity_java.vm) des [java-doman-T300 Templates](https://github.com/telosys-templates-v3/java-domain-T300) erzeugt.
Von uns verwendete Templates für die Code Genrierung liegen im Ordner [codegen](codegen).
Die Code Generierung erfolgt auf dem Datenbankschema, auf dem die Schnittstelle aufbaut.

##### Weiterführende Links

[Telosys v3 Einführung auf Youtube](https://youtu.be/XUmBEyiqRDA)

