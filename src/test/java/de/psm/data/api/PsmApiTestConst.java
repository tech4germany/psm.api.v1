package de.psm.data.api;

public class PsmApiTestConst
{
    public static final String BASE_HTTP_URL_TEST = "http://127.0.0.1:8080/ords/psm/api-v1/";

    // Adjust this number to query and check more or less items per endpoint.
    // The more items are queried, the longer the tests will take.
    public static final int    URL_PARAM_MAX_ITEMS_VALUE = 200;

    // activate be_nice mode, to make sure not getting blocked by the server
    public static final boolean BE_NICE = true;

    public static final String URL_PARAM_NAME_MAX_ITEMS = "limit";
    public static final String RESPONSE_JSON_ARRAY_KEY = "items";

    public static final String REQUEST_PARAMTER_KENNR = "kennr";
    public static final String ERROR_MESSAGE_UNEXPECTED_STATUS_CODE = "Returns unexpected Status Code";
    public static final int    RESPONSE_STATUS_CODE_200 = 200;

    // URL Endpoints
    public static final String REQUEST_ENDPOINT_ADRESSE  = "/adresse/";
    public static final String REQUEST_ENDPOINT_ANTRAG  = "/antrag/";
    public static final String REQUEST_ENDPOINT_AUFLAGE_REDU = "/auflage_redu/";
    public static final String REQUEST_ENDPOINT_AUFLAGEN  = "/auflagen/";
    public static final String REQUEST_ENDPOINT_AWG = "/awg/";
    public static final String REQUEST_ENDPOINT_AWG_AUFWAND = "/awg_aufwand/";
    public static final String REQUEST_ENDPOINT_AWG_BEM = "/awg_bem/";
    public static final String REQUEST_ENDPOINT_AWG_KULTUR = "/awg_kultur/";
    public static final String REQUEST_ENDPOINT_AWG_PARTNER = "/awg_partner/";
    public static final String REQUEST_ENDPOINT_AWG_PARTNER_AUFWAND = "/awg_partner_aufwand/";
    public static final String REQUEST_ENDPOINT_AWG_SCHADORG = "/awg_schadorg/";
    public static final String REQUEST_ENDPOINT_AWG_VERWENDUNGSZWECK = "/awg_verwendungszweck/";
    public static final String REQUEST_ENDPOINT_AWG_WARTEZEIT = "/awg_wartezeit/";
    public static final String REQUEST_ENDPOINT_AWG_WARTEZEIT_ASUG_KULTUR = "/awg_wartezeit_ausg_kultur/";
    public static final String REQUEST_ENDPOINT_AWG_ZEITPUNKT = "/awg_zeitpunkt/";
    public static final String REQUEST_ENDPOINT_AWG_ZULASSUNG = "/awg_zulassung/";
    public static final String REQUEST_ENDPOINT_GHS_GEFAHRENHINWEISE = "/ghs_gefahrenhinweise/";
    public static final String REQUEST_ENDPOINT_GHS_GEFAHRENSYMBOLE = "/ghs_gefahrensymbole/";
    public static final String REQUEST_ENDPOINT_GHS_SICHERHEITSHINWEISE = "/ghs_sicherheitshinweise/";
    public static final String REQUEST_ENDPOINT_GHS_SIGNALWOERTER = "/ghs_signalwoerter/";
    public static final String REQUEST_ENDPOINT_HINWEIS = "/hinweis/";
    public static final String REQUEST_ENDPOINT_KDOE = "/kode/";
    public static final String REQUEST_ENDPOINT_KODELISTE = "/kodeliste/";
    public static final String REQUEST_ENDPOINT_KODELISTE_FELDNAME = "/kodeliste_feldname/";
    public static final String REQUEST_ENDPOINT_KULTUR_GRUPPE = "/kultur_gruppe/";
    public static final String REQUEST_ENDPOINT_MITTEL = "/mittel/";
    public static final String REQUEST_ENDPOINT_MITTEL_ABGELAUFEN = "/mittel_abgelaufen/";
    public static final String REQUEST_ENDPOINT_MITTEL_ABPACKUNG = "/mittel_abpackung/";
    public static final String REQUEST_ENDPOINT_MITTEL_GEFAHRENSYMBOL  = "/mittel_gefahren_symbol";
    public static final String REQUEST_ENDPOINT_MITTEL_VERTRIEB = "/mittel_vertrieb/";
    public static final String REQUEST_ENDPOINT_MITTEL_WIRKBEREICH = "/mittel_wirkbereich/";
    public static final String REQUEST_ENDPOINT_PARALLELIMPORT_ABGELAUFEN = "/parallelimport_abgelaufen/";
    public static final String REQUEST_ENDPOINT_PARALLELIMPORT_GUELTIG = "/parallelimport_gueltig/";
    public static final String REQUEST_ENDPOINT_SCHADORG_GRUPPE = "/schadorg_gruppe/";
    public static final String REQUEST_ENDPOINT_STAERKUNG = "/staerkung/";
    public static final String REQUEST_ENDPOINT_STAERKUNG_VERTRIEB = "/staerkung_vertrieb/";
    public static final String REQUEST_ENDPOINT_STAND = "/stand/";
    public static final String REQUEST_ENDPOINT_WIRKSTOFF = "/wirkstoff/";
    public static final String REQUEST_ENDPOINT_WIRKSTOFF_GEHALT = "/wirkstoff_gehalt/";
    public static final String REQUEST_ENDPOINT_ZUSATZSTOFF = "/zusatzstoff/";
    public static final String REQUEST_ENDPOINT_ZUSATZSTOFF_VERTRIEB = "/zusatzstoff_vertrieb/";

}
