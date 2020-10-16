# <a name='oracle-setup'></a> Oracle Database 12c Installation auf CentOS 7

Installation nach: https://wiki.centos.org/HowTos/Oracle12onCentos7 (Englisch)


## <a name='prerequirements'></a> Voraussetzungen

SELinux (enforcing mode) und die firewall können aktiv bleiben:

```bash
[root@centos7 ~] sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Max kernel policy version:      28
[root@centos7 ~] firewall-cmd --state
running
```

Download von Oracle Database 12c für Linux x86-64:

``http://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html``


CentOS updaten:

```bash
[root@centos7 ~] yum update -y
```


## <a name='install'></a> Installation

Benutzer und Gruppen für Oracle anlegen:

```bash
[root@centos7 ~] groupadd oinstall
[root@centos7 ~] groupadd dba
[root@centos7 ~] useradd -g oinstall -G dba oracle
[root@centos7 ~] passwd oracle
```

Kernelparameter hinzufügen: `/etc/sysctl.conf`

```bash
fs.aio-max-nr = 1048576
fs.file-max = 6815744
kernel.shmall = 2097152
kernel.shmmax = 1987162112
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048586
```

Prüfen und Anwenden der Werte:

```bash
[root@centos7 ~] sysctl -p
[root@centos7 ~] sysctl -a
```

Limits für den Oracle Benutzer angeben `/etc/security/limits.conf`:

```bash
oracle soft nproc 2047
oracle hard nproc 16384
oracle soft nofile 1024
oracle hard nofile 65536
oracle soft stack 10240
```

Oracle Datenbank Software entpacken:

```bash
[root@centos7 ~] yum install -y zip unzip
[root@centos7 ~] unzip <file>.zip -d /stage/
```

Berechtigungen anpassen `/stage`:

```bash
[root@centos7 ~] chown -R oracle:oinstall /stage/
```

Ordner erstellen: `/u01` für Oracle Software und `/u02` für Datenbankdateien:

```bash
[root@centos7 ~] mkdir /u01
[root@centos7 ~] mkdir /u02
[root@centos7 ~] chown -R oracle:oinstall /u01
[root@centos7 ~] chown -R oracle:oinstall /u02
[root@centos7 ~] chmod -R 775 /u01
[root@centos7 ~] chmod -R 775 /u02
[root@centos7 ~] chmod g+s /u01
[root@centos7 ~] chmod g+s /u02
```

Benötigte Abhängigkeiten installieren:

```bash
[root@centos7 ~] yum install -y binutils.x86_64 compat-libcap1.x86_64 gcc.x86_64 gcc-c++.x86_64 glibc.i686 glibc.x86_64 glibc-devel.i686 glibc-devel.x86_64 ksh compat-libstdc++-33 libaio.i686 libaio.x86_64 libaio-devel.i686 libaio-devel.x86_64 libgcc.i686 libgcc.x86_64 libstdc++.i686 libstdc++.x86_64 libstdc++-devel.i686 libstdc++-devel.x86_64 libXi.i686 libXi.x86_64 libXtst.i686 libXtst.x86_64 make.x86_64 sysstat.x86_64
```

"X Window System" muss auch installiert werden:

```bash
[root@centos7 ~] yum groupinstall -y "X Window System"
```

Die Oracle Installation benötigt eine grafische Oberfläche.
Zwei einfache Möglichkeiten:

1. Remote Login von einem Linux-Desktop mit GUI via SSH. `ssh -X oracle@centos7.example.com`
2. Windows Desktop mit SSH Client (PuTTY) und X-Windows Terminalemulator (Xming).

Den Oracle Installer ausführen:

```bash
[oracle@centos7 ~] /stage/database/runInstaller
```

```bash
Starting Oracle Universal Installer
```

## <a name='screens'></a> Oracle Installer Screens:

### 1. Security Updates

Um keine E-Mails von Oracle zu erhalten, die Checkbox abwählen und **Next** klicken.

Im nächsten Fenster **YES** klicken.

### 2. Installation Option

**Create and configure a database** auswählen und **Next** klicken

### 3. System Class
   
**Desktop Class** für eine einfache Standardinstallation auswählen.

### 4. Typical Installation

Auf dem **Typical Install Configuration** Screen die wichtigsten Einstellung vornehmen:

   |                         |                                                |
   |-------------------------|-----------------------------------------------:|
   | Oracle base:            | `/u01/app/oracle`                              |
   | Software location:      | `/u01/app/oracle/product/<version>/dbhome_1`   |
   | Database file location  | `/u02`                                         |
   | Global database name    | `orcl.example.com`                             |
   |                         |                                                |

Wählen der passenden Datenbank Lizenz bzw. Edition.

Für die Pflanzenschutzmitteldatenbank wählen, muss **WE8MSWIN1252** und nicht Unicode als Zeichencodierung ausgewählt werden,
andernfalls kann es später Probleme beim Import der Daten geben.

Ein sicheres Password für den Datenbankadministrator eingeben und abschließend noch die Option **Create as Container database** abwählen. 

### 5. Create Inventory
   
Vorgabe akzeptieren `/u01/app/oraInventory` und **Next** klicken.

### 6. Prerequisite Checks

Der Installer überprüft die benötigten Abhängigkeiten und die Kernel-Einstellungen.

### 7. Summary
   
Letzte Chance für Änderugnen an der Installtion. **Install** klicken.

### 8. Execute Configuration Scripts
   
   Wenn das Anmeldefenster kommt, als root einloggen und zwei Skripte ausführen: 
   Beide Skripte müssen als root ausgeführt werden.

    ```bash
    [root@centos7 ~] /u01/app/oraInventory/orainstRoot.sh
    Changing permissions of /u01/app/oraInventory.
    Adding read,write permissions for group.
    Removing read,write,execute permissions for world.
    Changing groupname of `/u01/app/oraInventory` to oinstall.
    The execution of the script is complete.

    [root@centos7 ~] /u01/app/oracle/product/12.1.0/dbhome_1/root.sh
    Performing root user operation.
    The following environment variables are set as:
        ORACLE_OWNER= oracle
        ORACLE_HOME=  /u01/app/oracle/product/12.1.0/dbhome_1
    Enter the full pathname of the local bin directory: [/usr/local/bin]: <PRESS ENTER>
       Copying dbhome to /usr/local/bin …
       Copying oraenv to /usr/local/bin …
       Copying coraenv to /usr/local/bin ...
    Creating /etc/oratab file…
    Entries will be added to the /etc/oratab file as needed by
    Database Configuration Assistant when a database is created
    Finished running generic part of root script.
    Now product-specific root actions will be performed.
    You can follow the installation in a separated window.
    ```

### 9. Installationsfortschritt
   
   Ein weiteres Fenster öffnet sich um den Installationsfortschritt anzuzeigen. Diese Fenster bitte nicht schließen.
   
### 10. Installation erfolgreich

   Der letzte Screen informiert, dass die Installation abgeschlossen ist und zeigt die Enterprise Manager URL. `https://localhost:5500/em`
   
   **OK** schließt den Installer.


## <a name='postinstall'></a> Nach der Installation
    
    Firewall: Als root die aktivierten Zonen prüfen
    ```bash
    [root@centos7 ~] firewall-cmd --get-active-zones
    public
      interfaces: eth0
    ```
    Benötigte ports öffnen
    ```bash
    [root@centos7 ~] firewall-cmd --zone=public --add-port=1521/tcp --add-port=5500/tcp --add-port=5520/tcp --add-port=3938/tcp --permanent
    success
    ```
    ```bash
    [root@centos7 ~] firewall-cmd --reload
    success
    ```
    ```bash
    [root@centos7 ~] firewall-cmd --list-ports
    1521/tcp 3938/tcp 5500/tcp 5520/tcp
    ```

### Oracle Environment

Mit dem Benutzer `oracle` die folgenden Werte in die `/home/oracle/.bash_profile` eintragen:

```bash
TMPDIR=$TMP; export TMPDIR
ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
ORACLE_HOME=$ORACLE_BASE/product/<VERSION>/dbhome_1; export ORACLE_HOME
ORACLE_SID=orcl; export ORACLE_SID
PATH=$ORACLE_HOME/bin:$PATH; export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib:/usr/lib64; export LD_LIBRARY_PATH
CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib; export CLASSPATH
export NLS_LANG=.AL32UTF8
```

Die neuen Einstellungen aus `.bash_profile` laden:

```bash
[oracle@centos7 ~] . .bash_profile
```

Anschließend mit `sqlplus` an der Datenbank anmelden:

```bash
[oracle@centos7 ~] sqlplus system@orcl
... output omitted ...
Oracle Database 12c Enterprise Edition Release <version> - 64bit Production
With the Partitioning, OLAP, Advanced Analytics and Real Application Testing options
SQL>
```

### Oracle Datenbankinstanz starten:

```bash
[oracle@centos7 ~] sqlplus / as sysdba

SQL> startup
    ORACLE instance started.
    Total System Global Area 4999610368 bytes
    Fixed Size            8630952 bytes
    Variable Size         1040190808 bytes
    Database Buffers     3942645760 bytes
    Redo Buffers            8142848 bytes
    Database mounted.
    Database opened.
SQL> exit
```
         
### Oracle Listener starten:
         
```bash
[oracle@centos7 ~] lsnrctl start
    LSNRCTL for Linux: Version 12.2.0.1.0 - Production on 15-SEP-2020 15:20:51
    Copyright (c) 1991, 2016, Oracle.  All rights reserved.
    Starting /u01/app/oracle/product/12.2.0/dbhome_2/bin/tnslsnr: please wait...
    TNSLSNR for Linux: Version 12.2.0.1.0 - Production
    System parameter file is /u01/app/oracle/product/12.2.0/dbhome_2/network/admin/listener.ora
    Log messages written to /u01/app/oracle/diag/tnslsnr/ip-172-31-5-0/listener/alert/log.xml
    Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=127.0.0.1)(PORT=1521)))
    Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))
    Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521)))
    STATUS of the LISTENER
    ------------------------
    Alias                     LISTENER
    Version                   TNSLSNR for Linux: Version 12.2.0.1.0 - Production
    Start Date                15-SEP-2020 15:20:53
    Uptime                    0 days 0 hr. 0 min. 0 sec
    Trace Level               off
    Security                  ON: Local OS Authentication
    SNMP                      OFF
    Listener Parameter File   /u01/app/oracle/product/12.2.0/dbhome_2/network/admin/listener.ora
    Listener Log File         /u01/app/oracle/diag/tnslsnr/ip-172-31-5-0/listener/alert/log.xml
    Listening Endpoints Summary...  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=127.0.0.1)(PORT=1521)))  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))
    The listener supports no services
    The command completed successfully
```
### Fertig
