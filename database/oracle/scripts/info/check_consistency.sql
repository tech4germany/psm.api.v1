/*************************************************************************************************************
* Erstellt die View PSM.V_KONSISTENZ_ANALYSE("NAME", "INKONSISTENZ_TYP", "ANZAHL") analog zu den Inkosnsitenzprüfungen
* aus der Access Lösung "psm_info.mdb"
*
* Spalte INKONSISTENZ_TYP:
*   - enthält den Wert "DB" wenn es dich um Datenbankinkosistenzen handelt
*   - enthält den Wert "DATA" wenn es dich um Dateninkosistenzen handelt
*************************************************************************************************************/

CREATE OR REPLACE FORCE EDITIONABLE VIEW "PSM"."V_KONSISTENZ_ANALYSE" ("NAME", "MODULE", "INKONSISTENZ_TYP", "ANZAHL") AS

    /*************************************************************************************************************
    *                                       Datenbankinkonsistenzen
    *************************************************************************************************************/

/****************************** Antrag ****************************************/
SELECT 'STATUS' AS NAME, 'Stand' AS MODULE, 'NONE' AS INKONSISTENZ_TYP,  TO_CHAR(DATUM, 'DD.MM.YYYY')  AS ANZAHL
FROM STAND
UNION

-- Antrag ohne Mittel
SELECT 'Antrag ohne Mittel' AS NAME, 'ANTRAG' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(antrag.kennr)) AS ANZAHL
FROM antrag
WHERE antrag.kennr
          NOT IN (SELECT mittel.kennr FROM mittel)

UNION ALL

-- Antrag ohne Adresse
SELECT 'Antrag ohne Antragsteller' AS NAME, 'ANTRAG' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(antrag.antragsteller_nr)) AS ANZAHL
FROM antrag
WHERE antrag.antragsteller_nr
          NOT IN (SELECT adresse.adresse_nr FROM adresse)

UNION ALL

-- MITTEL_VERTRIEB ohne Adresse
SELECT 'MITTEL_VERTRIEB ohne Vertriebsfirma' AS NAME, 'MITTEL_VERTRIEB' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(mittel_vertrieb.vertriebsfirma_nr)) AS ANZAHL
FROM mittel_vertrieb
WHERE mittel_vertrieb.vertriebsfirma_nr
          NOT IN (SELECT adresse.adresse_nr FROM adresse)

UNION ALL

-- STAERKUNG  ohne Adresse
SELECT 'MITTEL_VERTRIEB ohne Antragsteller' AS NAME, 'STAERKUNG' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(staerkung.antragsteller_nr)) AS ANZAHL
FROM staerkung
WHERE staerkung.antragsteller_nr
          NOT IN (SELECT adresse.adresse_nr FROM adresse)

UNION ALL

-- STAERKUNG  ohne Adresse
SELECT 'STAERKUNG_VERTRIEB ohne Adresse' AS NAME, 'STAERKUNG_VERTRIEB' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(staerkung_vertrieb.vertriebsfirma_nr)) AS ANZAHL
FROM staerkung_vertrieb
WHERE staerkung_vertrieb.vertriebsfirma_nr
          NOT IN (SELECT adresse.adresse_nr FROM adresse)

UNION ALL

-- ZUSATZSTOFF ohne Adresse
SELECT 'ZUSATZSTOFF ohne Adresse' AS NAME, 'ZUSATZSTOFF' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(zusatzstoff.antragsteller_nr)) AS ANZAHL
FROM zusatzstoff
WHERE zusatzstoff.antragsteller_nr
          NOT IN (SELECT adresse.adresse_nr FROM adresse)

UNION ALL

-- ZUSATZSTOFF_VERTRIEB ohne Adresse
SELECT 'ZUSATZSTOFF_VERTRIEB ohne Adresse' AS NAME, 'ZUSATZSTOFF_VERTRIEB' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(zusatzstoff_vertrieb.vertriebsfirma_nr)) AS ANZAHL
FROM zusatzstoff_vertrieb
WHERE zusatzstoff_vertrieb.vertriebsfirma_nr
          NOT IN (SELECT adresse.adresse_nr FROM adresse)

/**************************** Auflagen ****************************************/

-- AUFLAGE ohne ü. AUFLAGEN (NotImplemented - Tabelle: Auflage existiert in PSMV nicht mehr)
-- AUFLAGEN ohne ü. AUFLAGE (NotImplemented - Tabelle: Auflage existiert in PSMV nicht mehr)

UNION ALL

-- AUFLAGE_REDU ohne ü. AUFLAGEN
SELECT 'AUFLAGE_REDU ohne AUFLAGEN' AS NAME, 'AUFLAGE_REDU' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(auflage_redu.auflagenr)) AS ANZAHL
FROM auflage_redu
WHERE auflage_redu.auflagenr
          NOT IN (SELECT auflagen.auflagenr FROM auflagen)


/*************************** AWG **********************************************/

UNION ALL

-- AWG ohne MITTEL
SELECT 'AWG ohne MITTEL' AS NAME, 'AWG' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg.kennr)) AS ANZAHL
FROM awg
WHERE awg.kennr
          NOT IN (SELECT mittel.kennr FROM mittel)

UNION ALL

-- AWG_KULTUR ohne KULTUR_GRUPPE
SELECT
    'AWG_KULTUR ohne KULTUR_GRUPPE' AS NAME, 'AWG_KULTUR' AS MODULE,
    'DB' AS INKONSISTENZ_TYP,
    TO_CHAR(COUNT(awg_kultur.kultur)) AS ANZAHL
FROM awg_kultur
WHERE awg_kultur.kultur
          NOT IN (SELECT kultur_gruppe.kultur FROM kultur_gruppe)

UNION ALL

-- AWG ohne AWG_SCHADORG
SELECT 'AWG ohne AWG_SCHADORG' AS NAME, 'AWG' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg.awg_id)) AS ANZAHL
FROM awg
WHERE awg.awg_id
          NOT IN (SELECT awg_schadorg.awg_id FROM awg_schadorg)

UNION ALL

-- AWG_AUFLAGEN ohne AWG
SELECT 'AWG_AUFLAGEN ohne AWG' AS NAME, 'AUFLAGEN' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(auflagen.ebene)) AS ANZAHL
FROM auflagen
WHERE LENGTH(auflagen.ebene) = 16 AND auflagen.ebene
    NOT IN (SELECT awg.awg_id FROM awg)

UNION ALL

-- AWG_HINWEIS ohne AWG
SELECT 'AWG_HINWEIS ohne AWG' AS NAME, 'HINWEIS' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(hinweis.ebene)) AS ANZAHL
FROM hinweis
WHERE LENGTH(hinweis.ebene) = 16 AND hinweis.ebene
    NOT IN (SELECT awg.awg_id FROM awg)

UNION ALL

-- AWG_AUFWAND ohne AWG
SELECT 'AWG_AUFWAND ohne AWG' AS NAME, 'AWG_AUFWAND' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg_aufwand.awg_id)) AS ANZAHL
FROM awg_aufwand
WHERE awg_aufwand.awg_id
          NOT IN (SELECT awg.awg_id FROM awg)

UNION ALL

-- AWG_BEM ohne AWG
SELECT 'AWG_BEM  ohne AWG' AS NAME, 'AWG_BEM' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg_bem.awg_id)) AS ANZAHL
FROM awg_bem
WHERE awg_bem.awg_id
          NOT IN (SELECT awg.awg_id FROM awg)

UNION ALL

-- AWG_PARTNER ohne AWG
SELECT 'AWG_PARTNER ohne MITTEL' AS NAME, 'AWG_PARTNER' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg_partner.partner_kennr)) AS ANZAHL
FROM awg_partner
WHERE awg_partner.partner_kennr
          NOT IN (SELECT mittel.kennr FROM mittel)

UNION ALL

-- AWG_PARTNER_AUFWAND ohne AWG_PARTNER
SELECT 'AWG_PARTNER_AUFWAND ohne AWG_PARTNER' AS NAME, 'AWG_PARTNER_AUFWAND' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg_partner_aufwand.awg_id)) AS ANZAHL
FROM awg_partner_aufwand
WHERE awg_partner_aufwand.awg_id
          NOT IN (SELECT awg_partner.awg_id FROM awg_partner)

UNION ALL

-- AWG_SCHADORG ohne ?. SCHADORG_GRUPPE
--SELECT 'AWG_PARTNER_AUFWAND ohne AWG_PARTNER' AS NAME, 'AWG' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg_schadorg.schadorg)) AS ANZAHL
SELECT 'AWG_SCHADORG ohne SCHADORG_GRUPPE' AS NAME, 'AWG_SCHADORG' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg_schadorg.schadorg)) AS ANZAHL
FROM awg_schadorg
WHERE awg_schadorg.schadorg
          NOT IN (SELECT schadorg_gruppe.schadorg FROM schadorg_gruppe)

UNION ALL

-- AWG_ZEITPUNKT ohne AWG
SELECT 'AWG_ZEITPUNKT ohne AWG' AS NAME, 'AWG_ZEITPUNKT' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg_zeitpunkt.awg_id)) AS ANZAHL
FROM awg_zeitpunkt
WHERE awg_zeitpunkt.awg_id
          NOT IN (SELECT awg.awg_id FROM awg)

UNION ALL

-- AWG_ZULASSUNG  ohne AWG
SELECT 'AWG_ZULASSUNG ohne AWG' AS NAME, 'AWG_ZULASSUNG' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg_zulassung.awg_id)) AS ANZAHL
FROM awg_zulassung
WHERE awg_zulassung.awg_id
          NOT IN (SELECT awg.awg_id FROM awg)


/*************************** Kode ************************************/

UNION ALL

-- kode ohne kodeliste
SELECT 'KODE ohne KODELISTE' AS NAME, 'KODE' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(kode.kodeliste)) AS ANZAHL
FROM kode
WHERE kode.kodeliste
          NOT IN (SELECT kodeliste.kodeliste FROM kodeliste)

UNION ALL

-- kodeliste ohne kode
SELECT 'KODELISTE ohne KODE' AS NAME, 'KODELISTE' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(kodeliste.kodeliste)) AS ANZAHL
FROM kodeliste
WHERE kodeliste.kodeliste
          NOT IN (SELECT kodeliste FROM kode)

UNION ALL

-- kodeliste ohne kodeliste_feldname
SELECT 'KODELISTE ohne KODELISTE_FELDNAME' AS NAME, 'KODELISTE' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(*)) AS ANZAHL
FROM kodeliste
WHERE kodeliste.kodeliste
          NOT IN (SELECT kodeliste FROM kodeliste_feldname)

UNION ALL

-- kodeliste_feldname ohne kode
SELECT 'KODELISTE_FELDNAME ohne KODE' AS NAME, 'KODELISTE_FELDNAME' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(*)) AS ANZAHL
FROM kodeliste_feldname
WHERE kodeliste_feldname.kodeliste
          NOT IN (SELECT kodeliste FROM kodeliste)

/**************************** Mittel ********************************/
UNION ALL

-- Mittel ohne Antrag
SELECT 'Mittel ohne Antrag' AS NAME, 'MITTEL' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(mittel.kennr)) AS ANZAHL
FROM mittel
WHERE mittel.kennr
          NOT IN (SELECT antrag.kennr FROM antrag)

UNION ALL

-- Mittel ohne AWG
SELECT 'Mittel ohne AWG' AS NAME, 'MITTEL' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(mittel.kennr)) AS ANZAHL
FROM mittel
WHERE mittel.kennr
          NOT IN (SELECT awg.kennr FROM awg)

UNION ALL

-- Mittel ohne WIRKSTOFF_GEHALT
SELECT 'Mittel ohne WIRKSTOFF_GEHALT' AS NAME, 'MITTEL' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(mittel.kennr)) AS ANZAHL
FROM mittel
WHERE mittel.kennr
          NOT IN (SELECT wirkstoff_gehalt.kennr FROM wirkstoff_gehalt)

UNION ALL

-- MITTEL_ABPACKUNG
SELECT 'MITTEL_ABPACKUNG ohne Mittel' AS NAME, 'MITTEL' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(mittel_abpackung.kennr)) AS ANZAHL
FROM mittel_abpackung
WHERE mittel_abpackung.kennr
          NOT IN (SELECT mittel.kennr FROM mittel)

UNION ALL

-- MITTEL_AUFLAGE
SELECT 'MITTEL_AUFLAGE ohne Mittel' AS NAME, 'AUFLAGEN' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(auflagen.ebene)) AS ANZAHL
FROM auflagen
WHERE LENGTH(auflagen.ebene) = 9 AND auflagen.ebene
    NOT IN (SELECT mittel.kennr FROM mittel)

UNION ALL

-- MITTEL_GEFAHRENSYMBOL
SELECT 'MITTEL_GEFAHREN_SYMBOL ohne Mittel' AS NAME, 'MITTEL_GEFAHREN_SYMBOL' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(mittel_gefahren_symbol.kennr)) AS ANZAHL
FROM mittel_gefahren_symbol
WHERE mittel_gefahren_symbol.kennr
          NOT IN (SELECT mittel.kennr FROM mittel)

UNION ALL

-- MITTEL_HINWEIS
SELECT 'MITTEL_HINWEIS ohne Mittel' AS NAME, 'HINWEIS' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(hinweis.ebene)) AS ANZAHL
FROM hinweis
WHERE LENGTH(hinweis.ebene) = 9 AND hinweis.ebene
    NOT IN (SELECT mittel.kennr FROM mittel)

UNION ALL

-- MITTEL_VERTRIEB
SELECT 'MITTEL_VERTRIEB ohne Mittel' AS NAME, 'MITTEL_VERTRIEB' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(mittel_vertrieb.kennr)) AS ANZAHL
FROM mittel_vertrieb
WHERE mittel_vertrieb.kennr
          NOT IN (SELECT mittel.kennr FROM mittel)

UNION ALL

-- MITTEL_WIRKBEREICH
SELECT 'MITTEL_WIRKBEREICH ohne Mittel' AS NAME, 'MITTEL_WIRKBEREICH' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(mittel_wirkbereich.kennr)) AS ANZAHL
FROM mittel_wirkbereich
WHERE mittel_wirkbereich.kennr
          NOT IN (SELECT mittel.kennr FROM mittel)

/************************** Wartezeit **********************************/

UNION ALL

-- AWG ohne ü. AWG_WARTEZEIT
SELECT 'AWG ohne AWG_WARTEZEIT' AS NAME, 'AWG' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg.awg_id)) AS ANZAHL
FROM awg
WHERE awg.awg_id
          NOT IN (SELECT awg_wartezeit.awg_id FROM awg_wartezeit)

UNION ALL

-- AWG_WARTEZEIT ohne ü. AWG
SELECT 'AWG_WARTEZEIT ohne AWG' AS NAME, 'WARTEZEIT' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg_wartezeit.awg_id)) AS ANZAHL
FROM awg_wartezeit
WHERE awg_wartezeit.awg_id
          NOT IN (SELECT awg.awg_id FROM awg)

UNION ALL

--AWG_WARTEZEIT_AUS_KULTUR ohne ü. AWG_WARTEZEIT
SELECT 'AWG_WARTEZEIT_AUS_KULTUR ohne AWG_WARTEZEIT' AS NAME, 'AWG_WARTEZEIT_AUSG_KULTUR' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg_wartezeit_ausg_kultur.awg_wartezeit_nr)) AS ANZAHL
FROM awg_wartezeit_ausg_kultur
WHERE awg_wartezeit_ausg_kultur.awg_wartezeit_nr
          NOT IN (SELECT awg_wartezeit.awg_wartezeit_nr FROM awg_wartezeit)

/*************************** Wirkstoff **********************************/

UNION ALL

-- WIRKSTOFF ohne ü. WIRKSTOFF_GEHALT
SELECT 'WIRKSTOFF ohne WIRKSTOFF_GEHALT' AS NAME, 'WIRKSTOFF' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(wirkstoff.wirknr)) AS ANZAHL
FROM wirkstoff
WHERE wirkstoff.wirknr
          NOT IN (SELECT wirkstoff_gehalt.wirknr FROM wirkstoff_gehalt)

UNION ALL

-- WIRKSTOFF_GEHALT ohne ü. MITTEL
SELECT 'WIRKSTOFF_GEHALT ohne MITTEL' AS NAME, 'WIRKSTOFF_GEHALT' AS MODULE, 'DB' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(wirkstoff_gehalt.kennr)) AS ANZAHL
FROM wirkstoff_gehalt
WHERE wirkstoff_gehalt.kennr
          NOT IN (SELECT mittel.kennr FROM mittel)

/************************************************************************************************************
*                          Dateninkonsistenz
*************************************************************************************************************/

/******************************* Antrag ***************************************/

--Antrag ohne Antragsteller
UNION ALL

SELECT 'Antrag ohne Antragsteller' AS NAME, 'ANTRAG' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(*)) AS ANZAHL
FROM antrag WHERE antrag.antragsteller_nr IS NULL

-- ANTRAG mit Hauptantragsteller != Ergänzungsantragsteller
UNION ALL

SELECT 'Antrag ohne übereinstimmende Antragsteller' AS NAME, 'ANTRAG' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(a.kennr)) AS ANZAHL
from ANTRAG a LEFT JOIN antrag b ON a.KENNR=b.KENNR
where a.antragnr='00' and b.antragnr > '00' and a.antragsteller_nr <> b.antragsteller_nr

/******************************* Auflagen ***************************************/

UNION ALL
--Auflage gleichzeitig Anwendungsbestimmung auf Mittel bzw AWG Ebene (Bsp: HE110?)
SELECT 'Auflage gleichzeitig in Mittel u. AWG' AS NAME, 'AUFLAGEN' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(a1.auflage)) AS ANZAHL FROM
    (SELECT auflagen.auflage, auflagen.ebene as awg_id, auflagen.anwendbest FROM auflagen where LENGTH(auflagen.ebene) = 16)  a1
        INNER JOIN
    (SELECT auflagen.auflage, auflagen.ebene as kennr, auflagen.anwendbest FROM auflagen where LENGTH(auflagen.ebene) = 9) a2
    ON a2.kennr = SUBSTR(a1.awg_id, 0, 9) AND a1.auflage = a2.auflage
WHERE (a2.anwendbest = 'J' OR a1.anwendbest = 'J')

UNION ALL

--Gleiche Auflage + Hinweis im selben Mittel
-- SELECT 'Antrag ohne Antragsteller' AS NAME, 'AUFLAGEN' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(auflagen.auflage)) AS ANZAHL
-- FROM auflagen
-- LEFT JOIN hinweis ON auflagen.ebene = hinweis.ebene
--   WHERE auflagen.auflage = hinweis.hinweis
--
-- UNION ALL

--Gleiche Auflage mit gleicher Kultur in Mittel und AWG
SELECT 'Gleiche Kultur Auflage in Mittel und AWG' AS NAME, 'AUFLAGEN' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(a1.auflage)) AS ANZAHL FROM
    (SELECT auflagen.auflage, auflagen.ebene as awg_id, auflagen.kultur FROM auflagen where LENGTH(auflagen.ebene) = 16)  a1
        INNER JOIN
    (SELECT auflagen.auflage, auflagen.ebene as kennr, auflagen.kultur FROM auflagen where LENGTH(auflagen.ebene) = 9) a2
    ON a2.kennr = SUBSTR(a1.awg_id, 0, 9) AND a1.auflage = a2.auflage AND a1.kultur = a2.kultur

-- UNION ALL

--Auflage gleich Hinweis insgesamt
-- SELECT 'Auflage gleich Hinweis insgesamt' AS NAME, 'AUFLAGEN' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(auflagen.auflage)) AS ANZAHL
-- FROM auflagen LEFT JOIN hinweis ON auflagen.auflage = hinweis.hinweis
--
-- UNION ALL

-- Auflage gleichzeitig Hinweis
-- SELECT 'Hinweis gleichzeitig Auflage' AS NAME, 'AUFLAGEN' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(auflagen.auflage)) AS ANZAHL
-- FROM auflagen LEFT JOIN hinweis ON auflagen.ebene = hinweis.ebene

/********************************* AWG *****************************************/

-- AWG ohne ZUL_ENDE oder kleiner als heute
UNION ALL
SELECT 'AWG ohne ZUL_ENDE oder kleiner als heute' AS NAME, 'AWG' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg.kennr)) AS ANZAHL
FROM awg
         LEFT JOIN awg_zulassung awgz on awg.awg_id = awgz.awg_id
WHERE (awgz.zul_ende is null  OR awgz.zul_ende < current_date)

-- AWG ZUL_ENDE > Mittel ZUL_ENDE
UNION ALL
SELECT 'AWG_ZUL_ENDE größer als MITTEL_ZUL_ENDE' AS NAME, 'AWG' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awgz.awg_id)) AS ANZAHL
FROM awg_zulassung awgz
         INNER JOIN mittel ON SUBSTR(awgz.awg_id, 1, 9) = mittel.kennr
WHERE awgz.zul_ende > mittel.zul_ende

-- AWG ZUL_ENDE < Mittel ZUL_ENDE
UNION ALL
SELECT 'AWG_ZUL_ENDE kleiner als MITTEL_ZUL_ENDE' AS NAME, 'AWG' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awgz.awg_id)) AS ANZAHL
FROM awg_zulassung awgz
         INNER JOIN mittel ON SUBSTR(awgz.awg_id, 1, 9) = mittel.kennr
WHERE awgz.zul_ende < mittel.zul_ende

-- AWG_Wartezeit ohne Wartezeit
UNION ALL
SELECT 'AWG_Wartezeit ohne Wartezeit' AS NAME, 'AWG_WARTEZEIT' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awgw.awg_id)) AS ANZAHL
FROM awg_wartezeit awgw
WHERE awgw.gesetzt_wartezeit IS NULL

-- AWG_Wartezeit ohne Anwendungsbereich
UNION ALL
SELECT 'AWG_Wartezeit ohne Anwendungsbereich' AS NAME, 'AWG_WARTEZEIT' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awgw.awg_id)) AS ANZAHL
FROM awg_wartezeit awgw
WHERE awgw.anwendungsbereich IS NULL

-- HUK-AWG ohne Mittel mit Verpackung
UNION ALL
SELECT 'Mittel mit Verpackung ohne HUK Anwendung' AS NAME, 'AWG' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(awg.awg_id)) AS ANZAHL
FROM awg
WHERE awg.huk = 'N'
  AND awg.kennr NOT IN (SELECT mittel_abpackung.kennr FROM mittel_abpackung)

-- AWG wird veröffentlicht obwohl in IZBS nicht zugelassen (not implemented)

-- AWG wird nicht veröffentlicht obwohl in IZBS zugelassen (not implemented)

/**************************** Mittel ********************************/

-- Duplikate zu MITTEL_NAME
UNION ALL
SELECT 'Duplikate zu MITTEL_NAME' AS NAME,
       'MITTEL' AS MODULE,
       'DATA' AS INKONSISTENZ_TYP,
       TO_CHAR(SUM(summe)) AS ANZAHL FROM (SELECT count(mittel.mittelname) AS summe
                                           FROM mittel GROUP BY mittel.mittelname ORDER BY summe DESC)
WHERE summe > 1

--  Mittel ohne ZUL_ENDE
UNION ALL
SELECT 'Mittel ohne ZUL_ENDE' AS NAME, 'MITTEL' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(mittel.kennr)) AS ANZAHL
FROM mittel
WHERE mittel.zul_ende IS NULL

--  Mittel ohne Erstzulassung
UNION ALL
SELECT 'Mittel ohne Erstzulassung' AS NAME, 'MITTEL' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(mittel.kennr)) AS ANZAHL
FROM mittel
WHERE mittel.zul_erstmalig_am IS NULL

--  Mittel ohne Bienen
UNION ALL
SELECT 'Mittel ohne Bienen' AS NAME, 'MITTEL' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(mittel.kennr)) AS ANZAHL
FROM mittel
WHERE mittel.kennr
    NOT IN (SELECT auflagen.ebene FROM auflagen WHERE LENGTH(auflagen.ebene) = 9 AND auflagen.auflage LIKE 'NB%')
   OR mittel.kennr
    NOT IN (SELECT hinweis.ebene FROM hinweis WHERE LENGTH(hinweis.ebene) = 9 AND hinweis.hinweis LIKE 'NB%')

--  Mittel mit Verpackung ohne HUK Anwendung
UNION ALL
SELECT 'Mittel mit Verpackung ohne HUK Anwendung' AS NAME, 'MITTEL_ABPACKUNG' AS MODULE, 'DATA' AS INKONSISTENZ_TYP, TO_CHAR(COUNT(mittel_abpackung.kennr)) AS ANZAHL
FROM mittel_abpackung
WHERE mittel_abpackung.kennr
          NOT IN (SELECT awg.kennr FROM awg WHERE awg.huk = 'N')

-- MITTEL wird veröffentlicht obwohl in IZBS nicht zugelassen (not implemented)

-- MITTEL wird nicht veröffentlicht obwohl in IZBS zugelassen (not implemented)

-- Kodes nicht dekodierbar (not implemented)

;

