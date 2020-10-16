/*************************************************************************************************************
* Zählt die Datensätze aus den einzelnen Tabellen
*************************************************************************************************************/

select 'ADRESSE' as tables, count(*) as count from ADRESSE union
select 'ANTRAG', count(*) as count from ANTRAG union
select 'AUFLAGE_REDU', count(*) as count from AUFLAGE_REDU union
select 'AUFLAGEN', count(*) as count from AUFLAGEN union
select 'AWG', count(*) as count from AWG union
select 'AWG_AUFWAND', count(*) as count from AWG_AUFWAND union
select 'AWG_BEM', count(*) as count from AWG_BEM union
select 'AWG_KULTUR', count(*) as count from AWG_KULTUR union
select 'AWG_PARTNER', count(*) as count from AWG_PARTNER union
select 'AWG_PARTNER_AUFWAND', count(*) as count from AWG_PARTNER_AUFWAND union
select 'AWG_SCHADORG', count(*) as count from AWG_SCHADORG union
select 'AWG_VERWENDUNGSZWECK', count(*) as count from AWG_VERWENDUNGSZWECK union
select 'AWG_WARTEZEIT', count(*) as count from AWG_WARTEZEIT union
select 'AWG_WARTEZEIT_AUSG_KULTUR', count(*) as count from AWG_WARTEZEIT_AUSG_KULTUR union
select 'AWG_ZEITPUNKT', count(*) as count from AWG_ZEITPUNKT union
select 'AWG_ZULASSUNG', count(*) as count from AWG_ZULASSUNG union
select 'GHS_GEFAHRENHINWEISE', count(*) as count from GHS_GEFAHRENHINWEISE union
select 'GHS_GEFAHRENSYMBOLE', count(*) as count from GHS_GEFAHRENSYMBOLE union
select 'GHS_SICHERHEITSHINWEISE', count(*) as count from GHS_SICHERHEITSHINWEISE union
select 'GHS_SIGNALWOERTER', count(*) as count from GHS_SIGNALWOERTER union
select 'HINWEIS', count(*) as count from HINWEIS union
select 'KODE', count(*) as count from KODE union
select 'KODELISTE', count(*) as count from KODELISTE union
select 'KODELISTE_FELDNAME', count(*) as count from KODELISTE_FELDNAME union
select 'KULTUR_GRUPPE', count(*) as count from KULTUR_GRUPPE union
select 'MITTEL', count(*) as count from MITTEL union
select 'MITTEL_ABGELAUFEN', count(*) as count from MITTEL_ABGELAUFEN union
select 'MITTEL_ABPACKUNG', count(*) as count from MITTEL_ABPACKUNG union
select 'MITTEL_GEFAHREN_SYMBOL', count(*) as count from MITTEL_GEFAHREN_SYMBOL union
select 'MITTEL_VERTRIEB', count(*) as count from MITTEL_VERTRIEB union
select 'MITTEL_WIRKBEREICH', count(*) as count from MITTEL_WIRKBEREICH union
select 'PARALLELIMPORT_ABGELAUFEN', count(*) as count from PARALLELIMPORT_ABGELAUFEN union
select 'PARALLELIMPORT_GUELTIG', count(*) as count from PARALLELIMPORT_GUELTIG union
select 'SCHADORG_GRUPPE', count(*) as count from SCHADORG_GRUPPE union
select 'STAERKUNG', count(*) as count from STAERKUNG union
select 'STAERKUNG_VERTRIEB', count(*) as count from STAERKUNG_VERTRIEB union
select 'STAND', count(*) as count from STAND union
select 'WIRKSTOFF', count(*) as count from WIRKSTOFF union
select 'WIRKSTOFF_GEHALT', count(*) as count from WIRKSTOFF_GEHALT union
select 'ZUSATZSTOFF', count(*) as count from ZUSATZSTOFF union
select 'ZUSATZSTOFF_VERTRIEB', count(*) as count from ZUSATZSTOFF_VERTRIEB
order by count desc;
