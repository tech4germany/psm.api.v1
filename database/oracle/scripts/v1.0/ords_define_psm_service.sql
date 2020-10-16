/*****************************************************************************************************
  Erstellt REST Schnittstelle für die PSM-Datenbank via ORDS (Oracle Rest Data Service)
 *****************************************************************************************************/

/**
  #######################################################################################
  #  Achtung: Damit das Skript erfolgreich ausgeführt werden kann,                      #
  #  muss ORDS für das betroffene Schema bereits aktiviert sein.                        #
  #######################################################################################
*/

BEGIN

    /*****************************************************************************************************
      Definiert ein Modul für das aktuelle Schema und setzt den base path (bis {modul}).

      Die URI's folgen dem Schema:
        http(s)://{adresse}:{port}/ords/{schema}/{modul}/{pattern}
     *****************************************************************************************************/

    ORDS.define_module(
            p_module_name    => 'api-v1',
            p_base_path      => 'api-v1',
            p_comments       => 'REST API (Version 1.0) der BVL Pflanzenschutzmittelzulassungsdaten

**Dokumentation:**
Das Bundesamt für Verbraucherschutz und Lebensmittelsicherheit stellt monatlich die in Deutschland geltenden Pflanzenschutzmittelzulassungen in einer Datenbank (PSM-DB) bereit. Dies ist die Dokumentation dieser PSM-DB über das Tool Swagger im OpenAPI-Standard. Die PSM-DB stellt dieselben Daten wie der über das BVL zu beziehende monatliche Access-Dumb in selber Aktualität bereit.

*Abrufmöglichkeiten:*
Jede Tabelle verfügt über die Methoden getAll und getByID. Wird kein Parameter übergeben, so wird automatisch ein getAll ausgeführt, sonst mit ID ein getByID.

*JSON Queries:*
Nicht über diesen Swagger dokumentiert, ist die Möglichkeit sog. JSON Queries an die ORDS-Schnittstelle zu senden. Mit diesen können mehr Abfragen abgebildet werden, wie beispielsweise Wildcards (unvollständige Suchparameter) und die Filterung durch sämtliche Parameter. (Beispielaufruf mit Filter: [http://35.158.109.68:8080/ords/psm/api-v1/mittel/?q={"MITTELNAME":{"$instr":"A"}}](http://35.158.109.68:8080/ords/psm/api-v1/mittel/?q={%22MITTELNAME%22:{%22$instr%22:%22A%22}})). Für weitere Informationen beachten Sie bitte die [Dokumentation von ORDS](https://docs.oracle.com/en/database/oracle/oracle-rest-data-services/20.2/aelig/developing-REST-applications.html#GUID-F0A4D4F9-443B-4EB9-A1D3-1CDE0A8BAFF2).

*Aktualisierungsdatum:*
Das Aktualisierungsdatum dieser Datenbank kann über die Tabelle STAND abgerufen werden. Die Daten werden aktuell monatlich aktualisiert.',
            p_items_per_page => 0);

/*****************************************************************************************************
  Tabelle: adresse
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name   => 'api-v1',
            p_pattern       => 'adresse/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'adresse/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM adresse WHERE adresse_nr = NVL(:adresse_nr, adresse_nr)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Liste aller Adressen und Namen von Vertriebsfirmen/Antragstellern/Importeuren von Pflanzenschutzmitteln.
                      Optional kann nur nach einer Adresse gesucht werden, wenn die entsprechende {adresse_nr} gegeben wird.
                      Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    {adresse_nr} ist der eindeutige Identifizierer für eine Adresse und damit eine/n Vertriebsfirma/Antragsteller/Importeur. Nummer mit bis zu 38 Ziffern, Bsp: 10784.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: antrag
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name    => 'api-v1',
            p_pattern      => 'antrag/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'antrag/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM antrag WHERE antragnr = NVL(:antragnr, antragnr) AND antragsteller_nr = NVL(:antragsteller_nr, antragsteller_nr) AND kennr = NVL(:kennr, kennr)',
            p_items_per_page => 100,
            p_comments       => 'Liefert die Zulassungsanträge und Antragsteller zu aktuell gültigen Pflanzenschutzmitteln (im Endpunkt /mittel).
                      Optional kann nach der Antragnummer {antragnr}, dem Antragsteller {antragsteller_nr} und/oder der Kennnummer des Mittels gefiltert werden.
                      Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer setzt sich zusammen aus {antragnr} und {kennr}.
    {antragnr} ist die Nummer des Antrags. Zeichenfolge aus zwei Zeichen, Bsp: 00.
    {antragsteller_nr} ist die Nummer des Antragstellers, referenziert aus dem /adresse Endpunkt. Zahl aus maximal 22 Ziffern, Bsp: 10091.
    {kennr} ist die Kennummer eines Pflanzenschutzmittels, referenziert aus dem /mittel Endpunkt. Zeichenkette aus neun Zeichen, Bsp: 005632-60.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: auflage_redu
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name    => 'api-v1',
            p_pattern      => 'auflage_redu/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'auflage_redu/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM auflage_redu WHERE auflagenr = NVL(:auflagenr, auflagenr)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Liste der Auflagen mit reduzierten Abständen bei verwendeten Geräten verschiedener Abdriftminderungsklassen.
                      Optional kann nach einer Auflagennummer {auflagenr} gefiltert werden.
                      Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer wird gebildet aus allen Attributen dieses Endpunkts.
    {auflagenr} ist die Nummer einer Auflage, referenziert aus dem /auflagen Endpunkt. Ziffernfolge, Bsp: 49804321.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: auflagen
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name    => 'api-v1',
            p_pattern      => 'auflagen/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'auflagen/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM auflagen WHERE auflagenr = NVL(:auflagenr, auflagenr) AND ebene = NVL(:ebene, ebene) AND auflage = NVL(:auflage, auflage)',
            p_items_per_page => 100,
            p_comments       => 'Liefert die Liste aller gesetzlichen Auflagen zu Mitteln und Anwendungen.
                      Optional kann nach Auflagennummer {auflagenr}, der Ebene {ebene} und/oder eines Auflagenkodes {auflage} gefiltert werden.
                      Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    {auflagenr} ist der eindeutige Identifizierer einer Auflage. Ziffernfolge, Bsp: 49747804.
    {auflage} ist der Kode einer Auflage. Der entsprechende Kode Text kann im /kode Endpunkt angefragt werden. Zeichenkette aus maximal 20 Zeichen, Bsp: WMA.
    {ebene} ist entweder die Kennnummer eines Mittels (kennr im /mittel Endpunkt, 9 Zeichen) oder der Identifizierer einer Anwendung (awg_id im /awg Endpunkt, 16 Zeichen). Zeichenkette aus maximal 16 Zeichen, Bsp: 024366-00 oder 005190-00/00-004.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: awg
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name    => 'api-v1',
            p_pattern      => 'awg/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'awg/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM awg WHERE awg_id = NVL(:awg_id, awg_id) AND kennr = NVL(:kennr, kennr)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Liste aller zugelassenen Anwendungen. Eine Anwendung beinhaltet ein angewendetes Mittel, eine Kultur, dessen Wachstumsstadium und einen Schadorganismus. Kultur und Schadorganismus können über die Endpunkte /awg_kultur und /awg_schadorg abgerufen werden.
                      Optional kann die ID der Anwendung {awg_id} und/oder die Kennnummer eines Mittels {kennr} übergeben werden, um die Ergebnisse zu filtern.
                      Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    {awg_id} ist der eindeutige Identifizierer einer Anwendung. Zeichenfolge aus 16 Zeichen, Bsp: 007472-60/01-012.
    {kennr} ist die Kennummer des Mittels auf das sich die Anwendung bezieht, referenziert aus dem /mittel Endpunkt. Zeichenfolge aus 9 Zeichen, Bsp: 007472-60.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: awg_aufwand
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name    => 'api-v1',
            p_pattern      => 'awg_aufwand/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'awg_aufwand/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM awg_aufwand WHERE awg_id = NVL(:awg_id, awg_id)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Zuordnung von Anwendungen ({awg_id}) auf vorgeschriebene Aufwände/Mengen von Pflanzenschutzmittel und Wasser bei dieser Anwendung.
                      Optional kann auf einzelnde Anwendungen per {awg_id} gefiltert werden.
                      Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus der awg_id, der aufwandbedingung und der sortier_nr.
    {awg_id} ist der Identifizierer einer Anwendung, referenziert aus dem Endpunkt /awg. Zeichenfolge aus 16 Zeichen, Bsp: 024785-63/00-002.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: awg_bem
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name    => 'api-v1',
            p_pattern      => 'awg_bem/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'awg_bem/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM awg_bem WHERE awg_id = NVL(:awg_id, awg_id)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Liste von Bemerkungen/Erläuterungen zu Anwendungen. ("Auflage" hat in diesem Endpunkt KEINE Verbindung zum Endpunkt /auflage!)
                      Optional kann nach einzelnen Anwendungen ({awg_id}) gefiltert werden.
                      Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus der awg_id und der auflage_bem.
    {awg_id} ist der Identifizierer einer Anwendung, referenziert aus dem Endpunkt /awg. Zeichenfolge aus 16 Zeichen, Bsp: 034210-64/00-007.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');
/*****************************************************************************************************
  Tabelle: awg_kultur
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'awg_kultur/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'awg_kultur/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM awg_kultur WHERE awg_id = NVL(:awg_id, awg_id)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Zuordnung von Anwendungen zu Kulturen. Wenn das Feld "ausgenommen" "J" beinhaltet, bildet die in "kultur" angegebene Kultur eine Ausnahme und ist nicht in der Anwendung enthalten.
                            Optional kann nach einzelnen Anwendungen ({awg_id}) gefiltert werden.
                            Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus der awg_id und der kultur.
    {awg_id} ist der Identifizierer einer Anwendung, referenziert aus dem Endpunkt /awg. Zeichenfolge aus 16 Zeichen, Bsp: 042688-00/00-001.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: awg_partner
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'awg_partner/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'awg_partner/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM awg_partner WHERE awg_id = NVL(:awg_id, awg_id)',
            p_items_per_page => 100,
            p_comments       => 'Liefert die Zuordnung von Anwendungen zu Partnermitteln, die gemeinsam verwendet werden dürfen, zum Beipiel als Tankmischungen.
                            Optional kann auf eine Anwendung {awg_id} gefiltert werden.
                            Der Parameter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus der awg_id und der partner_kennr.
    {awg_id} ist der Identifizierer einer Anwendung, referenziert aus dem Endpunkt /awg. Zeichenfolge aus 16 Zeichen, Bsp: 034078-00/01-003.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: awg_partner_aufwand
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'awg_partner_aufwand/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'awg_partner_aufwand/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM awg_partner_aufwand WHERE awg_id = NVL(:awg_id, awg_id)',
            p_items_per_page => 100,
            p_comments       => 'Liefert die Zuordnung von Anwendungen zu einem Partnermittel inklusive dem maximalen Aufwand.
                            Optional kann nach einer Anwendung {awg_id} gefiltert werden.
                            Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.


    Der eindeutige Identifizierer bestimmt sich aus der awg_id, der aufwandbedingung und der partner_kennr.
    {awg_id} ist der Identifizierer einer Anwendung, referenziert aus dem Endpunkt /awg. Zeichenfolge aus 16 Zeichen, Bsp: 024366-00/02-005.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');
/*****************************************************************************************************
  Tabelle: awg_schadorg
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'awg_schadorg/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'awg_schadorg/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM awg_schadorg WHERE awg_id = NVL(:awg_id, awg_id)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Zuordnung von Anwendungen zu Schadorganismen. Wenn das Feld "ausgenommen" "J" beinhaltet, bildet der in "schadorg" angegebene Schadorganismus eine Ausnahme und ist nicht in der Anwendung enthalten.
                            Optional kann nach einzelnen Anwendungen ({awg_id}) gefiltert werden.
                            Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus der awg_id und dem schadorg.
    {awg_id} ist der Identifizierer einer Anwendung, referenziert aus dem Endpunkt /awg. Zeichenfolge aus 16 Zeichen, Bsp: 043099-63/00-007.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');


/*****************************************************************************************************
  Tabelle: awg_verwendungszweck
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'awg_verwendungszweck/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'awg_verwendungszweck/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM awg_verwendungszweck WHERE awg_id = NVL(:awg_id, awg_id)',
            p_items_per_page => 100,
            p_comments       => 'Liefert die Zuordnung der Anwendungen zu Verwendungszwecken des assoziierten Mittels. Welcher Verwendng die behandelte Kultur also zugeführt werden darf. Kodiert über Kodeliste 31, einzusehen über den Endpunkt /kode.
                            Optional kann auf eine Anwendung {awg_id} gefiltert werden.
                            Der Paramter ist optional; werden keine Parameter übergeben enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus allen Attributen des Endpunkts.
    {awg_id} ist der Identifizierer einer Anwendung, referenziert aus dem Endpunkt /awg. Zeichenfolge aus 16 Zeichen, Bsp: 024436-63/00-069.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: awg_wartezeit
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'awg_wartezeit/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'awg_wartezeit/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM awg_wartezeit WHERE awg_wartezeit_nr = NVL(:awg_wartezeit_nr, awg_wartezeit_nr) AND awg_id = NVL(:awg_id, awg_id) AND kultur = NVL(:kultur, kultur)',
            p_items_per_page => 100,
            p_comments       => 'Liefert die Zuordnung von Anwendungen zu Wartezeiten in Tagen für eine bestimmte Kultur, bis die Anwendung erneut durchgeführt werden kann. Ausgenommene Kulturen sind über den Endpunkt /awg_wartezeit_ausg_kultur abzurufen. Genutzt wird für die Bemerkungen Kodeliste 89, dekodierbar über den Endpunkt /kode.
                            Optional kann nach der Wartezeit ID {awg_wartezeit_nr}, der Anwendungs ID {awg_id} oder der Kultur {kultur} gefiltert werden.
                            Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    {awg_wartezeit_nr} ist der eindeutige Identifizierer der Zuordnung einer Anwendung zu einer Wartezeit. Ziffernfolge aus maximal 38 Ziffern, Bsp: 151592.
    {awg_id} ist der Identifizierer einer Anwendung, referenziert aus dem Endpunkt /awg. Zeichenfolge aus 16 Zeichen, Bsp: 033274-64/02-001.
    {kultur} ist der Kode der behandelten Kultur, referenziert aus dem Endpunkt /kultur_gruppe. Zeichenfolge aus maximal 20 Zeichen, Bsp: FRAAN.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: awg_wartezeit_ausg_kultur
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'awg_wartezeit_ausg_kultur/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'awg_wartezeit_ausg_kultur/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM awg_wartezeit_ausg_kultur WHERE kultur = NVL(:kultur, kultur) AND awg_wartezeit_nr = NVL(:awg_wartezeit_nr, awg_wartezeit_nr)',
            p_items_per_page => 100,
            p_comments       => 'Liefert die Zuordnung von Anwendungswartezeiten auf Kulturen, die für diese Wartezeit ausgenommen sind. Die Wartezeit für die übrigen Kulturen kann im Endpunkt /awg_wartezeit abgerufen werden.
                            Optional kann nach der Wartezeit ID {awg_wartezeit_nr} oder der Kultur {kultur} gefiltert werden.
                            Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus sämtlichen Attributen des Endpunkts.
    {awg_wartezeit_nr} ist der Identifizierer der Zuordnung einer Anwendung zu einer Wartezeit aus dem Endpunkt /awg_wartezeit. Ziffernfolge aus maximal 38 Ziffern, Bsp: 129281.
    {kultur} ist der Kode der behandelten Kultur, referenziert aus dem Endpunkt /kultur_gruppe. Zeichenfolge aus maximal 20 Zeichen, Bsp: VIOWH.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: awg_zeitpunkt
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'awg_zeitpunkt/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'awg_zeitpunkt/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM awg_zeitpunkt WHERE awg_id = NVL(:awg_id, awg_id)',
            p_items_per_page => 100,
            p_comments       => 'Liefert die Zuordnung von Anwendungen zu Zeitpunkten. Es kann mehrere Zeitpunkte pro Anwendung geben, die über das Feld "operand_zu_vorher" aneinandergefügt werden in der Reihenfolge nach "sortier_nr". Die Zeitpunkte sind über Kodeliste 30 kodiert, die über den Endpunkt /kode dekodiert werden können.
                            Optional kann auf eine Anwendung {awg_id} gefiltert werden.
                            Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus der awg_id, und dem zeitpunkt.
    {awg_id} ist der Identifizierer einer Anwendung, referenziert aus dem Endpunkt /awg. Zeichenfolge aus 16 Zeichen, Bsp: 024560-64/04-025.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: awg_zulassung
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'awg_zulassung/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'awg_zulassung/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM awg_zulassung WHERE awg_id = NVL(:awg_id, awg_id)',
            p_items_per_page => 100,
            p_comments       => 'Liefert die Zuordnung von Anwendungen zu ihrem Zulassungsende.
                            Optional kann nach deiner Anwendung {awg_id} gefiltert werden.
                            Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    {awg_id} ist der eindeutige Identifizierer einer Anwendung, referenziert aus dem Endpunkt /awg. Zeichenfolge aus 16 Zeichen, Bsp: 026865-00/00-002.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: ghs_gefahrenhinweise
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'ghs_gefahrenhinweise/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'ghs_gefahrenhinweise/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM ghs_gefahrenhinweise WHERE kennr = NVL(:kennr, kennr)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Zuordnung von Mitteln zu ihren Gefahrenhinweisen. Die Gefahrenhinweise verwenden die Kodeliste 70 und können dekodiert werden über den Endpunkt /kode.
                            Optional kann auf ein Mittel {kennr} gefiltert werden.
                            Die Hinweise entspringen dem "Global harmonisierten System zur Einstufung und Kennzeichnung von Chemikalien", kurz GHS.
                            Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus allen Attributen des Endpunkts.
    {kennr} ist die Kennummer eines Mittels, referenziert aus dem Endpunkt /mittel. Zeichenfolge aus 9 Zeichen, Bsp: 024780-67.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: GHS_GEFAHRENSYMBOLE
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'ghs_gefahrensymbole/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'ghs_gefahrensymbole/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM ghs_gefahrensymbole WHERE kennr = NVL(:kennr, kennr)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Zuordnung von Mitteln zu ihren Gefahrensymbolen. Die Gefahrensymbole verwenden die Kodeliste 40 und können dekodiert werden über den Endpunkt /kode.
                            Optional kann auf ein Mittel {kennr} gefiltert werden.
                            Die Symbole entspringen dem "Global harmonisierten System zur Einstufung und Kennzeichnung von Chemikalien", kurz GHS.
                            Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus allen Attributen des Endpunkts.
    {kennr} ist die Kennummer eines Mittels, referenziert aus dem Endpunkt /mittel. Zeichenfolge aus 9 Zeichen, Bsp: 026557-00.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
 Tabelle: ghs_sicherheitshinweise
*****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'ghs_sicherheitshinweise/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'ghs_sicherheitshinweise/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM ghs_sicherheitshinweise WHERE kennr = NVL(:kennr, kennr)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Zuordnung von Mitteln zu ihren Sicherheitshinweisen. Die Sicherheitshinweise verwenden die Kodeliste 71 und können dekodiert werden über den Endpunkt /kode.
                            Optional kann auf ein Mittel {kennr} gefiltert werden.
                            Die Hinweise entspringen dem "Global harmonisierten System zur Einstufung und Kennzeichnung von Chemikalien", kurz GHS.
                            Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus allen Attributen des Endpunkts.
    {kennr} ist die Kennummer eines Mittels, referenziert aus dem Endpunkt /mittel. Zeichenfolge aus 9 Zeichen, Bsp: 024350-61.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: ghs_signalwoerter
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'ghs_signalwoerter/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'ghs_signalwoerter/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM ghs_signalwoerter WHERE kennr = NVL(:kennr, kennr)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Zuordnung von Mitteln zu ihren Signalwörtern. Die Signalwörter verwenden die Kodeliste 76 und können dekodiert werden über den Endpunkt /kode.
                            Optional kann auf ein Mittel {kennr} gefiltert werden.
                            Die Wörter entspringen dem "Global harmonisierten System zur Einstufung und Kennzeichnung von Chemikalien", kurz GHS.
                            Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus allen Attributen des Endpunkts.
    {kennr} ist die Kennummer eines Mittels, referenziert aus dem Endpunkt /mittel. Zeichenfolge aus 9 Zeichen, Bsp: 008263-00.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
 Tabelle: hinweis
*****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'hinweis/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'hinweis/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM hinweis WHERE ebene = NVL(:ebene, ebene)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Zuordnung von Ebenen (Mitteln und Anwendungen) zu Hinweisen. Die Hinweise verwenden die Kodeliste 74 und können dekodiert werden über den Endpunkt /kode.
                            Optional kann nach einer Ebene {ebene} (einem Mittel/einer Anwendung) gefiltert werden.
                            Der Paramter ist optional; werden keine Parameter übergeben enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus der {ebene} und dem hinweis.
    {ebene} ist entweder die Kennnummer eines Mittels (kennr im /mittel Endpunkt, 9 Zeichen) oder der Identifizierer einer Anwendung (awg_id im /awg Endpunkt, 16 Zeichen). Zeichenkette aus maximal 16 Zeichen, Bsp: 027821-61.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');


/*****************************************************************************************************
 Tabelle: kode
*****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'kode/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'kode/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM kode WHERE kode = NVL(:kode, kode) AND kodeliste = nvl(:kodeliste, kodeliste) AND sprache = NVL(:sprache, sprache)',
            p_items_per_page => 100,
            p_comments       => 'Liefert die Zuordnung von Kodes, Kodelisten und Sprache auf den Kodetext. Verwendet zur Dekodierung verschiedener Kodes aus anderen Tabellen.
                            Optional kann auf einen Kode, die dazugehörige Kodeliste und/oder eine Sprache gefiltert werden.
                            Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus dem {kode}, der {kodeliste} und der {sprache}.
    {kode} ist ein Kode, der in anderen Tabellen als Kodierung für Werte verwendet wird. Zeichenkette aus maximal 20 Zeichen, Bsp: ASPOF.
    {kodeliste} ist die Nummer der Liste, der der ensprechende Kode entnommen ist. Die Bedeutung der Liste kann dem Endpoint /kodeliste entnommen werden. Ziffernfolge aus maximal 3 Ziffern, Bsp: 948.
    {sprache} ist die Sprache in der der Kodetext geliefert werden soll. Aktuell bereitgestellt werden DE, GB und teilweise VA (Latein). Zeichenkette aus maximal 20 Zeichen, Bsp: DE.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: kodeliste
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'kodeliste/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'kodeliste/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM kodeliste WHERE kodeliste = nvl(:kodeliste, kodeliste)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Auflistung der Kodelisten inklusive dem Listennamen, also der testlichen Beschreibung wofür die Liste steht.
                            Optional kann nut auf eine Kodeliste {kodeliste} gefiltert werden.
                            Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    {kodeliste} ist der eindeutige Identifizierer der Liste. Ziffernfolge aus maximal 3 Ziffern, Bsp: 3.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');


/*****************************************************************************************************
 Tabelle: kodeliste_feldname
*****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'kodeliste_feldname/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'kodeliste_feldname/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM kodeliste_feldname WHERE kodeliste = NVL(:kodeliste, kodeliste) AND tabelle = NVL(:tabelle, tabelle) AND feldname = NVL(:feldname, feldname)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Zuordnung von Kodelistennummer auf die Tabelle und das Feld in dem diese Kodeliste verwendet wird.
                            Optional kann nach Kodelistennummer {kodeliste} und/oder Tabellennamen {tabelle} und/oder Spaltennamen {feldname} gefiltert werden.
                            Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus der {tabelle}, der {kodeliste} und dem {feldname}.
    {tabelle} ist der Name einer Tabelle, in der eine Kodeliste verwendet wird. Zeichenkette aus maximal 30 Zeichen, Bsp: ADRESSE.
    {kodeliste} ist die Nummer der Liste, die in der Spalte verwendet wird. Ziffernfolge aus maximal 3 Ziffern, Bsp: 3.
    {feldname} ist der Name der Spalte, in der eine Kodeliste verwendet wird. Zeichenkette aus maximal 30 Zeichen, Bsp: LAND.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');


/*****************************************************************************************************
  Tabelle: kultur_gruppe
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'kultur_gruppe/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'kultur_gruppe/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM kultur_gruppe WHERE kultur = nvl(:kultur, kultur) AND kultur_gruppe = nvl(:kultur_gruppe, kultur_gruppe)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Liste der Kulturen und der korrespondierenden Kulturgruppe. Der Enpunkt ist eine Repräsentation einer Baumstruktur. kultur_gruppe ist dabei ein Parent, dem das Child kultur zugeordnet ist. Eine Kulturgruppe kann mehrere Kulturen als Children besitzen, eine Kultur kann mehrere Parents haben. Da der Baum mehrere Stufen hat, stehen einige Kulturen als Child (kultur) UND als Parent (kultur_gruppe) in unterschiedlichen Zeilen.
                            Optional kann auf eine Kultur {kultur} oder eine Kulturgruppe {kultur_gruppe} gefiltert werden.
                            Bei einer übergebenen {kultur} enthält die Rückgabe nur die direkten Parents, also Kulturgruppen zu der korrepondierenden Kultur.
                            Bei einer übergebenen {kultur_gruppe} enthält die Rückgabe nur die direkten Children, also Kulturen zu der korrepondierenden Kulturgruppe.
                            Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer bestimmt sich aus der {kultur}, und der {kultur_gruppe}.
    {kultur} ist der Kode einer Kultur (Child). Zeichenkette aus maximal 20 Zeichen, Bsp: CAFPA.
    {kulturgruppe} ist der Kode der Kulturgruppe der zugeordneten Kultur (Parent). Zeichenkette aus maximal 20 Zeichen, Bsp: NNNZT.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: mittel
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name    => 'api-v1',
            p_pattern      => 'mittel/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'mittel/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM mittel WHERE kennr = NVL(:kennr, kennr)',
            p_items_per_page => 100,
            p_comments		 => 'Liefert eine Liste aller zugelassenen Pflanzeschutzmittel.
                          Optional kann auf eine Zulassungsnummer/Kennummer {kennr} gefiltert werden.
                          Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

        {kennr} ist der eindeutige Identifizierer, die Kennummer/Zulassungsnummer eines Mittels. Zeichenkette aus 9 Zeichen, Bsp: 024213-73.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: mittel_abgelaufen
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name    => 'api-v1',
            p_pattern      => 'mittel_abgelaufen/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'mittel_abgelaufen/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM mittel_abgelaufen WHERE kennr = NVL(:kennr, kennr)',
            p_items_per_page => 100,
            p_comments		 => 'Liefert eine Liste der abgelaufenen Pflanzenschutzmittel, inklusive Aufbrauchfrist. Weitere Informationen sind nur unter den Endpunkten /wirkstoff und /wirkstoff_gehalt enthalten. Andere Referenzen wurden entfernt.
                          Optional kann auf eine Kennummer {kennr} gefiltert werden.
                          Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

        {kennr} ist der eindeutige Identifizierer, die Kennummer eines abgelaufenen Mittels. Zeichenkette aus 9 Zeichen, Bsp: 050023-61.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
Tabelle: mittel_abpackung
*****************************************************************************************************/
    ORDS.define_template(
            p_module_name    => 'api-v1',
            p_pattern      => 'mittel_abpackung/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'mittel_abpackung/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM mittel_abpackung WHERE kennr = NVL(:kennr, kennr)',
            p_items_per_page => 100,
            p_comments		 => 'Liefert eine Liste der Packungsinformationen für Mittel.
                          Optional kann auf die Kennummer eines Mittels {kennr} gefiltert werden.
                          Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

        Der eindeutige Identifizierer setzt sich aus allen Attributen des Endpunkts zusammen.
        {kennr} ist die Kennummer eines Mittels, referenziert aus dem Endpunkt /mittel. Zeichenkette aus 9 Zeichen, Bsp: 033274-64.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: mittel_gefahren_symbol
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name    => 'api-v1',
            p_pattern      => 'mittel_gefahren_symbol/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'mittel_gefahren_symbol/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM mittel_gefahren_symbol WHERE kennr = NVL(:kennr, kennr)',
            p_items_per_page => 100,
            p_comments		 => 'Liefert eine Zuordnung von Mitteln zu Gefahrensymbolen.
                          Optional kann auf eine Mittel Kennummer {kennr} gefiltert werden.
                          Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

        Der eindeutige Identifizierer setzt sich aus der {kennr} und dem gefahren_symbol zusammen.
        {kennr} ist die Kennummer eines Mittels, referenziert aus dem Endpunkt /mittel. Zeichenkette aus 9 Zeichen, Bsp: 006978-00.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
 Tabelle: mittel_vertrieb
*****************************************************************************************************/
    ORDS.define_template(
            p_module_name    => 'api-v1',
            p_pattern      => 'mittel_vertrieb/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'mittel_vertrieb/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM mittel_vertrieb WHERE kennr = NVL(:kennr, kennr) AND vertriebsfirma_nr = NVL(:vertriebsfirma_nr, vertriebsfirma_nr)',
            p_items_per_page => 100,
            p_comments		 => 'Liefert die Zuordnung von Mitteln zu Vetriebsfirmen dieser Mittel.
                          Optional kann auf ein Mittel {kennr} oder eine Vertriebsfirma {vertriebsfirma_nr} gefiltert werden.

        Der eindeutige Identifizierer setzt sich aus der{kennr} und der {vertriebsfirma_nr} zusammen.
        {kennr} ist die Kennummer eines Mittels, referenziert aus dem Endpunkt /mittel. Zeichenkette aus 9 Zeichen, Bsp: 00A502-00.
        {vertriebsfirma_nr} ist die Nummer der Vertriebsfirma, referenziert aus dem Endpunkt /adresse. Ziffernfolge aus maximal 22 Ziffern, Bsp: 11281.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
 Tabelle: mittel_wirkbereich
*****************************************************************************************************/
    ORDS.define_template(
            p_module_name    => 'api-v1',
            p_pattern      => 'mittel_wirkbereich/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'mittel_wirkbereich/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM mittel_wirkbereich WHERE kennr = NVL(:kennr, kennr) AND wirkungsbereich = NVL(:wirkungsbereich, wirkungsbereich)',
            p_items_per_page => 100,
            p_comments		 => 'Liefert eine Liste von Zuordnungen von Mitteln zu Wirkbereichen. Die konkreten Anwendungen sind abgebildet in Endpunkt /awg. Das Feld "wirkungsbereich" nutzt die Kodeliste 21, die über den Endpunkt /kode dekodiert werden kann.
                          Optional kann auf ein Mittel {kennr} oder einen  Workunsbereich {wirkungsbereich} gefiltert werden.
                          Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

        Der eindeutige Identifizierer setzt sich aus der {kennr} und dem {wirkungsbreich} zusammen.
        {kennr} ist die Kennummer eines Mittels, referenziert aus dem Endpunkt /mittel. Zeichenkette aus 9 Zeichen, Bsp: 006335-00.
        {wirkungsbereich} ist der Kode für den Wirkungsbereich eines Mittels. Die Dekodierung läuft über den Endpunkt /kode. Zeichenfolge aus 20 Zeichen, Bsp: F.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: parallelimport_abgelaufen
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'parallelimport_abgelaufen/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'parallelimport_abgelaufen/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM parallelimport_abgelaufen WHERE pi_referenz_kennr = NVL(:pi_referenz_kennr,  pi_referenz_kennr) AND importeur_nr = NVL(:importeur_nr,  importeur_nr)',
            p_items_per_page => 100,
            p_comments		 => 'Liefert eine Liste der abgelaufenen Parallelimporte (Mittel aus anderen Ländern die identisch sind zu in Deutschland zugelassenen Mitteln) zu ihren Referenzmitteln.
                          Optional kann auf ein Referenzmittel {pi_referenz_kennr} oder einen Importeur {importeur_nr) gefiltert werden.
                          Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

        Der eindeutige Identifizierer setzt sich aus allen Attributen des Endpunktes zusammen.
        {pi_referenz_kennr} ist die Kennummer eines Mittels, referenziert aus dem Endpunkt /mittel. Zeichenkette aus 9 Zeichen, Bsp: 006768-00.
        {importeur_nr} ist die Nummer des Importeurs, referenziert wird die adresse_nr des Endpunktes /adresse. Zeichenfolge aus 20 Zeichen, Bsp: 12158.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
 Tabelle: parallelimport_gueltig
*****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'parallelimport_gueltig/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'parallelimport_gueltig/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM parallelimport_gueltig WHERE pi_referenz_kennr = NVL(:pi_referenz_kennr,  pi_referenz_kennr) AND importeur_nr = NVL(:importeur_nr,  importeur_nr)',
            p_items_per_page => 100,
            p_comments		 => 'Liefert eine Liste der gültigen Parallelimporte (Mittel aus anderen Ländern die identisch sind zu in Deutschland zugelassenen Mitteln) zu ihren Referenzmitteln.
                          Optional kann auf ein Referenzmittel {pi_referenz_kennr} oder einen Importeur {importeur_nr) gefiltert werden.
                          Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

        Der eindeutige Identifizierer setzt sich aus allen Attributen des Endpunktes zusammen.
        {pi_referenz_kennr} ist die Kennummer eines Mittels, referenziert aus dem Endpunkt /mittel. Zeichenkette aus 9 Zeichen, Bsp: 006767-00.
        {importeur_nr} ist die Nummer des Importeurs, referenziert wird die adresse_nr des Endpunktes /adresse. Zeichenfolge aus 20 Zeichen, Bsp: 12158.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: schadorg_gruppe
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'schadorg_gruppe/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'schadorg_gruppe/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM schadorg_gruppe WHERE schadorg = NVL(:schadorg, schadorg) AND schadorg_gruppe = NVL(:schadorg_gruppe, schadorg_gruppe)',
            p_items_per_page => 100,
            p_comments		 => 'Liefert eine Liste der Schadorganismen und der korrespondierenden Schadorganismengruppe. Der Enpunkt ist eine Repräsentation einer Baumstruktur. schadorg_gruppe ist dabei ein Parent, dem das Child schadorg zugeordnet ist. Eine Schagorganismusgruppe kann mehrere Schadorganismen als Children besitzen, ein Schadorganismus kann mehrere Parents haben. Da der Baum mehrere Stufen hat, stehen einige Schadorganismen als Child (schadorg) UND als Parent (schadorg_gruppe) in unterschiedlichen Zeilen.
                          Optional kann auf einen Schadorganismus {schadorg} oder eine Schadorganismusgruppe {schadorg_gruppe} gefiltert werden.
                          Bei einer übergebenen {schadorg} enthält die Rückgabe nur die direkten Parents, also Schadorganismusgruppen zum korrepondierenden Schadorganismus.
                          Bei einer übergebenen {schadorg_gruppe} enthält die Rückgabe nur die direkten Children, also Schadorganismen zu der korrepondierenden Schadorganismusgruppe.
                          Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

        Der eindeutige Identifizierer bestimmt sich aus dem {schadorg}, und der {schadorg_gruppe}.
        {schadorg} ist der Kode eines Schadorganismus. (Child). Zeichenkette aus maximal 20 Zeichen, Bsp: BRORM.
        {schadorg_gruppe} ist der Kode der Schdorganismusgruppe des zugeordneten Schadorganismus. (Parent). Zeichenkette aus maximal 20 Zeichen, Bsp: TTTMM.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
 Tabelle: staerkung
*****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'staerkung/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'staerkung/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM staerkung WHERE kennr = NVL(:kennr, kennr) AND antragsteller_nr = NVL(:antragsteller_nr, antragsteller_nr)',
            p_items_per_page => 100,
            p_comments		 => 'Liefert eine Liste von zugelassenen Stärkungsmitteln.
                          Optional kann auf die Kennummer des Stärkungsmittels {kennr} und/oder den Anstragsteller {antragsteller_nr} gefiltert werden.
                          Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

        {kennr} ist der eindeutige Identifizierer, die Kennummer einer Stärkung, referenziert aus dem Endpunkt /mittel. Zeichenkette aus 9 Zeichen, Bsp: 025125-00.
        {antragsteller_nr} ist die Nummer des Antragstellers, referenziert wird die adresse_nr des Endpunktes /adresse. Zeichenfolge aus 20 Zeichen, Bsp: 10612.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: staerkung_vertrieb
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'staerkung_vertrieb/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'staerkung_vertrieb/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM staerkung_vertrieb WHERE kennr = NVL(:kennr, kennr) AND vertriebsfirma_nr = NVL(:vertriebsfirma_nr, vertriebsfirma_nr)',
            p_items_per_page => 100,
            p_comments		 => 'Liefert eine Zuordnung von Stärungsmitteln auf die Vertriebsfirmen der Stärkungsmittel.
                          Optional kann auf die Kennummer des Stärkungsmittels {kennr} und/oder die Vertriebsfirma {vertriebsfirma_nr} gefiltert werden.
                          Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    {kennr] ist der eindeutige Identifizierer, die Kennummer einer Stärkung, referenziert aus dem Endpunkt /mittel. Zeichenkette aus 9 Zeichen, Bsp: 007713-00.
    {vertriebsfirma_nr} ist die Nummer der Vertriebsfirma, referenziert wird die adresse_nr des Endpunktes /adresse. Zeichenfolge aus 20 Zeichen, Bsp: 12791.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: stand
*****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'stand/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'stand/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM stand',
            p_items_per_page => 100,
            p_comments       => 'Liefert das Release-Datum für den aktuellen Datenbestand. Das heißt, das Datum an dem die Daten das letzte Mal aktualisiert wurden.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');


/*****************************************************************************************************
  Tabelle: wirkstoff
*****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'wirkstoff/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'wirkstoff/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM wirkstoff WHERE wirknr = NVL(:wirknr, wirknr)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Liste von zugelassenen Wirkstoffen.
                            Optional kann auf einen Wirkstoff anhand der korrespondierenden Wirknummer {wirknr} gefiltert werden.
                            Der Paramter ist optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    {wirknr} ist der eindeutige Identifizierer des Wirkstoffes. Zeichenkette aus maximal 4 Zeichen, Bsp: 1122.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: wirkstoff_gehalt
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'wirkstoff_gehalt/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'wirkstoff_gehalt/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM wirkstoff_gehalt WHERE wirknr = NVL(:wirknr, wirknr) AND kennr = NVL(:kennr, kennr)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Zuordnung der Mittel und des korrespondierenden Wirkstoffgehalts.
                            Optional kann auf die Nummer eines Wirkstoffes {wirknr} und/oder eines Mittels {kennr} gefiltert werden.
                            Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer setzt sich zusammen aus der {wirknr}, der {kennr} und der wirkvar.
    {wirknr} ist die Nummer des Wirkstoffes, referenziert aus dem Endpunkt /wirkstoff. Zeichenkette aus maximal 4 Zeichen, Bsp: 0875.
    {kennr} ist die Kennummer eines Mittels, referenziert aus dem Endpunkt /mittel. Zeichenkette aus 9 Zeichen, Bsp: 024994-00.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: zusatzstoff
*****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'zusatzstoff/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'zusatzstoff/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM zusatzstoff WHERE kennr = NVL(:kennr, kennr) AND antragsteller_nr = NVL(:antragsteller_nr, antragsteller_nr)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Liste der Zusatzstoffe zu Mitteln.
                            Optional kann auf die Nummer des Zusatzstoffes {:kennr} oder die Nummer eines Antragstellers {antragsteller_nr} gefiltert werden.
                            Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    {kennr} ist der eindeutige Identifizierer, die Kennummer des Zusatzstoffes. Zeichenfolge aus 9 Zeichen, Bsp: 008339-00.
    {antragsteller_nr} ist die Nummer des Antragsstellers, referenziert wird die adresse_nr des Endpunktes /adresse. Ziffernfolge aus maximal 22 Ziffern, Bsp: 12051.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

/*****************************************************************************************************
  Tabelle: zusatzstoff_vertrieb
 *****************************************************************************************************/
    ORDS.define_template(
            p_module_name  => 'api-v1',
            p_pattern      => 'zusatzstoff_vertrieb/');

    ORDS.define_handler(
            p_module_name    => 'api-v1',
            p_pattern        => 'zusatzstoff_vertrieb/',
            p_method         => 'GET',
            p_source_type    => ORDS.source_type_collection_feed,
            p_source         => 'SELECT * FROM zusatzstoff_vertrieb WHERE kennr = NVL(:kennr, kennr) AND vertriebsfirma_nr = NVL(:vertriebsfirma_nr, vertriebsfirma_nr)',
            p_items_per_page => 100,
            p_comments       => 'Liefert eine Zuordnung von Zusatzstoffen auf die Vertriebsfirmen der Zusatzstoffe.
                            Optional kann auf die Kennummer des Zusatzstoffes {kennr} und/oder die Vertriebsfirma {vertriebsfirma_nr} gefiltert werden.
                            Die Paramter sind optional; werden keine Parameter übergeben, enthält die Rückgabe alle Einträge.

    Der eindeutige Identifizierer setzt sich zusammen aus allen Attributen des Endpunkts.
    {kennr} ist die Kennummer des Zusatzstoffes, referenziert aus dem Endpunkt /zusatzstoff. Zeichenkette aus 9 Zeichen, Bsp: 005697-00.
    {vertriebsfirma_nr} ist die Nummer der Vertriebsfirma, referenziert wird die adresse_nr des Endpunktes /adresse. Ziffernfolge aus maximal 22 Ziffern, Bsp: 10799.

Wenn auf andere Parameter gefiltert oder Teilabfragen gestellt werden sollen, können gesonderte Filtermethoden verwendet werden. Siehe dazu Abschnitt "*JSON Queries*" in der oberen allgemeinen API Beschreibung');

    COMMIT;
END;

