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
