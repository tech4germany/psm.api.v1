package de.psm.data.api;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import org.testng.Assert;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Test;
import org.testng.log4testng.Logger;

import java.io.StringReader;

/**
 * This class tests if all get by ID endpoints of the PSM API V1 return something and if the return value matches the given ID.
 * In special cases it also tests that exactly one item is returned.
 * For performance reasons, all endpoints are fetched in the beginning and only one item is queried per get by ID endpoint.
 *
 * The methods are structured by endpoints. In one method there are all parameters of that endpoint tested.
 */
public class PsmGetByIdTest extends AbstractBaseTest {

    public Logger log = Logger.getLogger(PsmGetByIdTest.class);

    public static JsonNode adresseResponse = null;
    public static JsonNode antragResponse = null;
    public static JsonNode auflageReduResponse = null;
    public static JsonNode auflagenResponse = null;
    public static JsonNode awgResponse = null;
    public static JsonNode awgAufwandResponse = null;
    public static JsonNode awgBemResponse = null;
    public static JsonNode awgKulturResponse = null;
    public static JsonNode awgPartnerResponse = null;
    public static JsonNode awgPartnerAufwandResponse = null;
    public static JsonNode awgSchadorgResponse = null;
    public static JsonNode awgVerwendungszweckResponse = null;
    public static JsonNode awgWartezeitResponse = null;
    public static JsonNode awgWartezeitAusgKulturResponse = null;
    public static JsonNode awgZeitpunktResponse = null;
    public static JsonNode awgZulassungResponse = null;
    public static JsonNode ghsGefahrenhinweiseResponse = null;
    public static JsonNode ghsGefahrensymboleResponse = null;
    public static JsonNode ghsSicherheitshinweiseResponse = null;
    public static JsonNode ghsSignalwoerterResponse = null;
    public static JsonNode hinweisResponse = null;
    public static JsonNode kodeResponse = null;
    public static JsonNode kodelisteResponse = null;
    public static JsonNode kodelisteFeldnameResponse = null;
    public static JsonNode kulturGruppeResponse = null;
    public static JsonNode mittelResponse = null;
    public static JsonNode mittelAbgelaufenResponse = null;
    public static JsonNode mittelAbpackungResponse = null;
    public static JsonNode mittelGefahrenSymbolResponse = null;
    public static JsonNode mittelVertriebResponse = null;
    public static JsonNode mittelWirkbereichResponse = null;
    public static JsonNode parallelimportAbgelaufenResponse = null;
    public static JsonNode parallelimportGueltigResponse = null;
    public static JsonNode schadorgGruppeResponse = null;
    public static JsonNode staerkungResponse = null;
    public static JsonNode staerkungVertriebResponse = null;
    public static JsonNode standResponse = null;
    public static JsonNode wirkstoffResponse = null;
    public static JsonNode wirkstoffGehaltResponse = null;
    public static JsonNode zusatzstoffResponse = null;
    public static JsonNode zusatzstoffVertriebResponse = null;

    public static final String ITEMS_PARAMETER = "items";

    private static JsonNode getJsonFromResponse(Response response) {
        Assert.assertEquals(200, response.getStatusCode(), "Returns correct Status Code");

        JsonNode responseObject;
        try {
            responseObject = new ObjectMapper().readTree(new StringReader(response.body().asString()));
            return responseObject.get(ITEMS_PARAMETER);
        }
        catch (java.io.IOException e) {
            Assert.fail(e.toString());
        }
        return null;
    }

    /**
     * This method takes the specification of one getById endpoint and asserts that this endpoint
     * 1) returns status code 200,
     * 2) returns exactly one item and
     * 3) returns the item with the correct ID.
     *
     * @param endpoint       String representing the endpoint to query.
     * @param parameterValue String containing the expected value, the expected ID to the queried item.
     * @param parameterName  String representing the parameter name to give in the getById query.
     */
    private void testForExactlyOne(String endpoint, String parameterValue, String parameterName) throws InterruptedException{
        log.info("call endpoint: " + endpoint + " with parameter: " + parameterName + "=" + parameterValue);
        Response getByIdResponse = RestAssured.given().when().queryParam(parameterName, parameterValue).get(endpoint);
        Assert.assertEquals(200, getByIdResponse.getStatusCode(), "Returns correct Status Code");
        slowDown(PsmApiTestConst.BE_NICE);

        JsonNode responseObject;
        JsonNode allMatchingItems = null;
        try {
            responseObject = new ObjectMapper().readTree(new StringReader(getByIdResponse.body().asString()));
            allMatchingItems = responseObject.get(ITEMS_PARAMETER);
        }
        catch (java.io.IOException e) {
            Assert.fail(e.toString());
        }

        Assert.assertEquals(1, allMatchingItems.size());
        Assert.assertEquals(parameterValue, allMatchingItems.get(0).get(parameterName).asText());
    }

    /**
     * This method takes the specification of one getById endpoint and asserts that this endpoint
     * 1) returns status code 200,
     * 2) returns at least one item and
     * 3) returns the item with the correct ID for the first item.
     *
     * @param endpoint       String representing the endpoint to query.
     * @param parameterValue String containing the expected value, the expected ID to the queried item(s).
     * @param parameterName  String representing the parameter name to give in the getById query.
     */
    private void testForAtLeastOne(String endpoint, String parameterValue, String parameterName, JsonNode getAllItems) throws InterruptedException {
        log.info("call endpoint: " + endpoint + " with parameter: " + parameterName + "=" + parameterValue);
        Response getByIdResponse = RestAssured.given().when().queryParam(parameterName, parameterValue).get(endpoint);
        Assert.assertEquals(200, getByIdResponse.getStatusCode(), "Returns correct Status Code");
        slowDown(PsmApiTestConst.BE_NICE);

        JsonNode responseObject;
        JsonNode allMatchingItems = null;
        try {
            responseObject = new ObjectMapper().readTree(new StringReader(getByIdResponse.body().asString()));
            allMatchingItems = responseObject.get(ITEMS_PARAMETER);
        }
        catch (java.io.IOException e) {
            Assert.fail(e.toString());
        }

        Assert.assertNotEquals(0, allMatchingItems.size());
        for (JsonNode item: allMatchingItems)
        {
            Assert.assertEquals(parameterValue, item.get(parameterName).asText());
        }

    }

    @BeforeSuite
    public static void setup() {
        RestAssured.baseURI = PsmApiTestConst.BASE_HTTP_URL_TEST;
        RestAssured.port = 80;

        // limit requests by MAX_ITEMS
        final String queryParam = "?" + PsmApiTestConst.URL_PARAM_NAME_MAX_ITEMS + "=" + PsmApiTestConst.URL_PARAM_MAX_ITEMS_VALUE;

        // request all getAll endpoints
        adresseResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_ADRESSE + queryParam));
        antragResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_ANTRAG + queryParam));
        auflageReduResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AUFLAGE_REDU + queryParam));
        auflagenResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AUFLAGEN + queryParam));
        awgResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AWG + queryParam));
        awgAufwandResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AWG_AUFWAND + queryParam));
        awgBemResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AWG_BEM + queryParam));
        awgKulturResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AWG_KULTUR + queryParam));
        awgPartnerResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AWG_PARTNER + queryParam));
        awgPartnerAufwandResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AWG_PARTNER_AUFWAND + queryParam));
        awgSchadorgResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AWG_SCHADORG + queryParam));
        awgVerwendungszweckResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AWG_VERWENDUNGSZWECK + queryParam));
        awgWartezeitResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AWG_WARTEZEIT + queryParam));
        awgWartezeitAusgKulturResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AWG_WARTEZEIT_ASUG_KULTUR + queryParam));
        awgZeitpunktResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AWG_ZEITPUNKT + queryParam));
        awgZulassungResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AWG_ZULASSUNG + queryParam));
        ghsGefahrenhinweiseResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_GHS_GEFAHRENHINWEISE + queryParam));
        ghsGefahrensymboleResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_GHS_GEFAHRENSYMBOLE + queryParam));
        ghsSicherheitshinweiseResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_GHS_SICHERHEITSHINWEISE + queryParam));
        ghsSignalwoerterResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_GHS_SIGNALWOERTER + queryParam));
        hinweisResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_HINWEIS + queryParam));
        kodeResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_KDOE + queryParam));
        kodelisteResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_KODELISTE + queryParam));
        kodelisteFeldnameResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_KODELISTE_FELDNAME + queryParam));
        kulturGruppeResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_KULTUR_GRUPPE + queryParam));
        mittelResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL + queryParam));
        mittelAbgelaufenResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL_ABGELAUFEN + queryParam));
        mittelAbpackungResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL_ABPACKUNG + queryParam));
        mittelGefahrenSymbolResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL_GEFAHRENSYMBOL + queryParam));
        mittelVertriebResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL_VERTRIEB + queryParam));
        mittelWirkbereichResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL_WIRKBEREICH + queryParam));
        parallelimportAbgelaufenResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_PARALLELIMPORT_ABGELAUFEN + queryParam));
        parallelimportGueltigResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_PARALLELIMPORT_GUELTIG + queryParam));
        schadorgGruppeResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_SCHADORG_GRUPPE + queryParam));
        staerkungResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_STAERKUNG + queryParam));
        staerkungVertriebResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_STAERKUNG_VERTRIEB + queryParam));
        standResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_STAND + queryParam));
        wirkstoffResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_WIRKSTOFF + queryParam));
        wirkstoffGehaltResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_WIRKSTOFF_GEHALT + queryParam));
        zusatzstoffResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_ZUSATZSTOFF + queryParam));
        zusatzstoffVertriebResponse = getJsonFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_ZUSATZSTOFF_VERTRIEB + queryParam));
    }

    @Test
    public void adresseEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < adresseResponse.size() - 1; i++)
        {
            String adresseNr = adresseResponse.get(i).get("adresse_nr").asText();
            testForExactlyOne("/adresse", adresseNr, "adresse_nr");
        }
    }

    @Test
    public void antragEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < antragResponse.size() - 1; i++)
        {
            String antragnr = antragResponse.get(i).get("antragnr").asText();
            String kennr = antragResponse.get(i).get("kennr").asText();
            String antragstellernr = antragResponse.get(i).get("antragsteller_nr").asText();

            // Test with antragnr
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_ANTRAG, antragnr, "antragnr", antragResponse);

            // Test with kennr
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_ANTRAG, kennr, "kennr", antragResponse);

            // Test with antragnr + kennr
            Response specificResponse = RestAssured.given().when()
                    .queryParam("antragnr", antragnr)
                    .queryParam("kennr", kennr).get(PsmApiTestConst.REQUEST_ENDPOINT_ANTRAG);
            Assert.assertEquals(200, specificResponse.getStatusCode(), "Returns correct Status Code");
            slowDown(PsmApiTestConst.BE_NICE);

            JsonNode responseObject;
            JsonNode allMatchingItems = null;
            try {
                responseObject = new ObjectMapper().readTree(new StringReader(specificResponse.body().asString()));
                allMatchingItems = responseObject.get(ITEMS_PARAMETER);
            }
            catch (java.io.IOException e) {
                Assert.fail(e.toString());
            }
            Assert.assertEquals(1, allMatchingItems.size());
            Assert.assertEquals(antragnr, allMatchingItems.get(0).get("antragnr").asText());
            Assert.assertEquals(kennr, allMatchingItems.get(0).get("kennr").asText());

            // Test with antragsteller_nr
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_ANTRAG, antragstellernr, "antragsteller_nr", antragResponse);
        }
    }

    @Test
    public void auflageReduEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < auflageReduResponse.size() - 1; i++)
        {
            String auflagenr = auflageReduResponse.get(i).get("auflagenr").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AUFLAGE_REDU, auflagenr, "auflagenr", auflagenResponse);
        }
    }

    @Test
    public void auflagenEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < auflagenResponse. size() -1; i++)
        {
            String auflage = auflagenResponse.get(i).get("auflage").asText();
            String auflagenr = auflagenResponse.get(i).get("auflagenr").asText();
            String ebene = auflagenResponse.get(i).get("ebene").asText();

            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AUFLAGEN, auflage, "auflage", auflagenResponse);
            testForExactlyOne(PsmApiTestConst.REQUEST_ENDPOINT_AUFLAGEN, auflagenr, "auflagenr");
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AUFLAGEN, ebene, "ebene", auflagenResponse);

            // Test with auflagenr + ebene
            Response specificResponse = RestAssured.given().when()
                    .queryParam("auflagenr", auflagenr)
                    .queryParam("ebene", ebene)
                    .get(PsmApiTestConst.REQUEST_ENDPOINT_AUFLAGEN);

            Assert.assertEquals(200, specificResponse.getStatusCode(), "Returns correct Status Code");
            slowDown(PsmApiTestConst.BE_NICE);

            JsonNode responseObject;
            JsonNode allMatchingItems = null;
            try {
                responseObject = new ObjectMapper().readTree(new StringReader(specificResponse.body().asString()));
                allMatchingItems = responseObject.get(ITEMS_PARAMETER);
            }
            catch (java.io.IOException e) {
                Assert.fail(e.toString());
            }

            Assert.assertEquals(1, allMatchingItems.size());
            Assert.assertEquals(auflagenr, allMatchingItems.get(0).get("auflagenr").asText());
            Assert.assertEquals(ebene, allMatchingItems.get(0).get("ebene").asText());
        }
    }

    @Test
    public void awgEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < awgResponse.size() - 1; i++)
        {
            String awgId = awgResponse.get(i).get("awg_id").asText();
            String kennr = awgResponse.get(i).get("kennr").asText();
            testForExactlyOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG, awgId, "awg_id");
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG, kennr, "kennr", awgResponse);
        }
    }

    @Test
    public void awgAufwandEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < awgAufwandResponse.size() - 1; i++)
        {
            String awgId = awgAufwandResponse.get(i).get("awg_id").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG_AUFWAND, awgId, "awg_id", awgAufwandResponse);
        }
    }

    @Test
    public void awgBemEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < awgBemResponse.size() - 1; i++)
        {
            String awgId = awgBemResponse.get(i).get("awg_id").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG_BEM, awgId, "awg_id", awgBemResponse);
        }
    }

    @Test
    public void awgKulturEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < awgKulturResponse.size() - 1; i++)
        {
            String awgId = awgKulturResponse.get(i).get("awg_id").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG_KULTUR, awgId, "awg_id", awgKulturResponse);
        }
    }

    @Test
    public void awgPartnerEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < awgPartnerResponse.size() - 1; i++)
        {
            String awgId = awgPartnerResponse.get(i).get("awg_id").asText();
            testForExactlyOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG_PARTNER, awgId, "awg_id");
        }
    }

    @Test
    public void awgPartnerAufwandEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < awgPartnerAufwandResponse.size() - 1; i++)
        {
            String awgId = awgPartnerAufwandResponse.get(i).get("awg_id").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG_PARTNER_AUFWAND, awgId, "awg_id", awgPartnerAufwandResponse);
        }
    }

    @Test
    public void awgSchadorgEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < awgSchadorgResponse.size() - 1; i++)
        {
            String awgId = awgSchadorgResponse.get(i).get("awg_id").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG_SCHADORG, awgId, "awg_id", awgSchadorgResponse);
        }
    }

    @Test
    public void awgVerwendungszweckEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < awgVerwendungszweckResponse.size() - 1; i++)
        {
            String awgId = awgVerwendungszweckResponse.get(i).get("awg_id").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG_VERWENDUNGSZWECK, awgId, "awg_id", awgVerwendungszweckResponse);
        }
    }

    @Test
    public void awgWartezeitEndpointsTest() throws InterruptedException
    {
        JsonNode awgWartezeit;
        for (int i=0; i < awgWartezeitResponse.size() - 1; i++)
        {
            awgWartezeit =  awgWartezeitResponse.get(i);
            final String awgId = awgWartezeit.get("awg_id").asText();
            final String awgWartezeitNr = awgWartezeit.get("awg_wartezeit_nr").asText();
            final String kultur = awgWartezeit.get("kultur").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG_WARTEZEIT, awgId, "awg_id", awgWartezeitResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG_WARTEZEIT, awgWartezeitNr, "awg_wartezeit_nr", awgWartezeitResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG_WARTEZEIT, kultur, "kultur", awgWartezeitResponse);
        }
    }

    @Test
    public void awgWartezeitAusgKulturEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < awgWartezeitAusgKulturResponse.size() - 1; i++)
        {
            String awgWartezeitNr = awgWartezeitAusgKulturResponse.get(i).get("awg_wartezeit_nr").asText();
            String kultur = awgWartezeitAusgKulturResponse.get(i).get("kultur").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG_WARTEZEIT_ASUG_KULTUR, awgWartezeitNr, "awg_wartezeit_nr", awgWartezeitAusgKulturResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG_WARTEZEIT_ASUG_KULTUR, kultur, "kultur", awgWartezeitAusgKulturResponse);
        }
    }

    @Test
    public void awgZeitpunktEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < awgZeitpunktResponse.size() - 1; i++)
        {
            String awgId = awgZeitpunktResponse.get(i).get("awg_id").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG_ZEITPUNKT, awgId, "awg_id", awgZeitpunktResponse);
        }
    }

    @Test
    public void awgZulassungEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < awgZulassungResponse.size() - 1; i++)
        {
            String awgId = awgZulassungResponse.get(i).get("awg_id").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_AWG_ZULASSUNG, awgId, "awg_id", awgZulassungResponse);
        }
    }

    @Test
    public void ghsGefahrenhinweiseEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < ghsGefahrenhinweiseResponse.size() - 1; i++)
        {
            String kennr = ghsGefahrenhinweiseResponse.get(i).get("kennr").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_GHS_GEFAHRENHINWEISE, kennr, "kennr", ghsGefahrenhinweiseResponse);
        }
    }

    @Test
    public void ghsGefahrensymboleEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < ghsGefahrensymboleResponse.size() - 1; i++)
        {
            String kennr = ghsGefahrensymboleResponse.get(i).get("kennr").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_GHS_GEFAHRENSYMBOLE, kennr, "kennr", ghsGefahrensymboleResponse);
        }
    }

    @Test
    public void ghsSicherheitshinweiseEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < ghsSicherheitshinweiseResponse.size() - 1; i++)
        {
            String kennr = ghsSicherheitshinweiseResponse.get(i).get("kennr").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_GHS_SICHERHEITSHINWEISE, kennr, "kennr", ghsSicherheitshinweiseResponse);
        }
    }

    @Test
    public void ghsSignalwoerterEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < ghsSignalwoerterResponse.size() - 1; i++)
        {
            String kennr = ghsSignalwoerterResponse.get(i).get("kennr").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_GHS_SIGNALWOERTER, kennr, "kennr", ghsSignalwoerterResponse);
        }
    }

    @Test
    public void hinweisEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < hinweisResponse.size() - 1; i++)
        {
            String ebene = hinweisResponse.get(i).get("ebene").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_HINWEIS, ebene, "ebene", hinweisResponse);
        }
    }

    @Test
    public void kodeEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < kodeResponse.size() - 1; i++)
        {
            String kode = kodeResponse.get(i).get("kode").asText();
            String kodeliste = kodeResponse.get(i).get("kodeliste").asText();
            String sprache = kodeResponse.get(i).get("sprache").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_KDOE, kode, "kode", kodeResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_KDOE, kodeliste, "kodeliste", kodeResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_KDOE, sprache, "sprache", kodeResponse);

            // Test with Kode + Kodeliste
            Response specificResponse = RestAssured.given().when()
                    .queryParam("kode", kode)
                    .queryParam("kodeliste", kodeliste)
                    .get(PsmApiTestConst.REQUEST_ENDPOINT_KDOE);

            Assert.assertEquals(200, specificResponse.getStatusCode(), "Returns correct Status Code");
            slowDown(PsmApiTestConst.BE_NICE);

            JsonNode responseObject = null;
            JsonNode allMatchingItems = null;
            try {
                responseObject = new ObjectMapper().readTree(new StringReader(specificResponse.body().asString()));
                allMatchingItems = responseObject.get(ITEMS_PARAMETER);
            }
            catch (java.io.IOException e) {
                Assert.fail(e.toString());
            }

            Assert.assertNotEquals(0, allMatchingItems.size()); // there are multiple languages so we cannot test for one specific number
            for (JsonNode item: allMatchingItems)
            {
                Assert.assertEquals(kode, item.get("kode").asText());
                Assert.assertEquals(kodeliste, item.get("kodeliste").asText());
            }

            // Test with Kode + Kodeliste + sprache
            specificResponse = RestAssured.given().when()
                    .queryParam("kode", kode)
                    .queryParam("kodeliste", kodeliste).queryParam("sprache", sprache)
                    .get(PsmApiTestConst.REQUEST_ENDPOINT_KDOE);

            Assert.assertEquals(200, specificResponse.getStatusCode(), "Returns correct Status Code");
            slowDown(PsmApiTestConst.BE_NICE);

            try {
                responseObject = new ObjectMapper().readTree(new StringReader(specificResponse.body().asString()));
            }
            catch (java.io.IOException e) {
                Assert.fail(e.toString());
            }
            allMatchingItems = responseObject.get(ITEMS_PARAMETER);
            Assert.assertEquals(1, allMatchingItems.size());
            Assert.assertEquals(kode, allMatchingItems.get(0).get("kode").asText());
            Assert.assertEquals(kodeliste, allMatchingItems.get(0).get("kodeliste").asText());
        }
    }

    @Test
    public void kodelisteEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < kodelisteResponse.size() - 1; i++)
        {
            String kodeliste = kodelisteResponse.get(i).get("kodeliste").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_KODELISTE, kodeliste, "kodeliste", kodelisteResponse);
        }
    }

    @Test
    public void kodelisteFeldnameEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < kodelisteFeldnameResponse.size() - 1; i++)
        {
            String kodeliste = kodelisteFeldnameResponse.get(i).get("kodeliste").asText();
            String tabelle = kodelisteFeldnameResponse.get(i).get("tabelle").asText();
            String feldname = kodelisteFeldnameResponse.get(i).get("feldname").asText();

            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_KODELISTE_FELDNAME, kodeliste, "kodeliste", kodelisteFeldnameResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_KODELISTE_FELDNAME, feldname, "feldname", kodelisteFeldnameResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_KODELISTE_FELDNAME, tabelle, "tabelle", kodelisteFeldnameResponse);

            // Test with Kode + Kodeliste + sprache
            Response specificResponse = RestAssured.given().when()
                    .queryParam("kodeliste", kodeliste)
                    .queryParam("tabelle", tabelle)
                    .queryParam("feldname", feldname)
                    .get(PsmApiTestConst.REQUEST_ENDPOINT_KODELISTE_FELDNAME);

            Assert.assertEquals(200, specificResponse.getStatusCode(), "Returns correct Status Code");
            slowDown(PsmApiTestConst.BE_NICE);

            JsonNode responseObject;
            JsonNode allMatchingItems = null;
            try {
                responseObject = new ObjectMapper().readTree(new StringReader(specificResponse.body().asString()));
                allMatchingItems = responseObject.get(ITEMS_PARAMETER);
            }
            catch (java.io.IOException e) {
                Assert.fail(e.toString());
            }
            Assert.assertEquals(1, allMatchingItems.size());
            Assert.assertEquals(kodeliste, allMatchingItems.get(0).get("kodeliste").asText());
            Assert.assertEquals(tabelle, allMatchingItems.get(0).get("tabelle").asText());
            Assert.assertEquals(feldname, allMatchingItems.get(0).get("feldname").asText());
        }
    }

    @Test
    public void kulturGruppeEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < kulturGruppeResponse.size() - 1; i++)
        {
            String kulturGruppe = kulturGruppeResponse.get(i).get("kultur_gruppe").asText();
            String kultur = kulturGruppeResponse.get(i).get("kultur").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_KULTUR_GRUPPE, kulturGruppe, "kultur_gruppe", kulturGruppeResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_KULTUR_GRUPPE, kultur, "kultur", kulturGruppeResponse);
        }
    }

    @Test
    public void mittelEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < mittelResponse.size() - 1; i++)
        {
            String kennr = mittelResponse.get(i).get("kennr").asText();
            testForExactlyOne(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL, kennr, "kennr");
        }
    }

    @Test
    public void mittelAbgelaufenEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < mittelAbgelaufenResponse.size() - 1; i++)
        {
            String kennr = mittelAbgelaufenResponse.get(i).get("kennr").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL_ABGELAUFEN, kennr, "kennr", mittelAbgelaufenResponse);
        }
    }

    @Test
    public void mittelAbpackungEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < mittelAbpackungResponse.size() - 1; i++)
        {
            String kennr = mittelAbpackungResponse.get(i).get("kennr").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL_ABPACKUNG, kennr, "kennr", mittelAbpackungResponse);
        }
    }

    @Test
    public void mittelGefahrenSymbolEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < mittelGefahrenSymbolResponse.size() - 1; i++)
        {
            String kennr = mittelGefahrenSymbolResponse.get(i).get("kennr").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL_GEFAHRENSYMBOL, kennr, "kennr", mittelGefahrenSymbolResponse);
        }
    }

    @Test
    public void mittelVertriebEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < mittelVertriebResponse.size() - 1; i++)
        {
            String kennr = mittelVertriebResponse.get(i).get("kennr").asText();
            String vertriebsfirmaNr = mittelVertriebResponse.get(i).get("vertriebsfirma_nr").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL_VERTRIEB, kennr, "kennr", mittelVertriebResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL_VERTRIEB, vertriebsfirmaNr, "vertriebsfirma_nr", mittelVertriebResponse);
        }
    }

    @Test
    public void mittelWirkbereichEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < mittelWirkbereichResponse.size() - 1; i++)
        {
            String kennr = mittelWirkbereichResponse.get(i).get("kennr").asText();
            String wirkungsbereich = mittelWirkbereichResponse.get(i).get("wirkungsbereich").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL_WIRKBEREICH, kennr, "kennr", mittelWirkbereichResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL_WIRKBEREICH, wirkungsbereich, "wirkungsbereich", mittelWirkbereichResponse);
        }
    }

    @Test
    public void parallelimportAbgelaufenEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < parallelimportAbgelaufenResponse.size() - 1; i++)
        {
            String importeurNr = parallelimportAbgelaufenResponse.get(i).get("importeur_nr").asText();
            String piReferenzKennr = parallelimportAbgelaufenResponse.get(i).get("pi_referenz_kennr").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_PARALLELIMPORT_ABGELAUFEN, importeurNr, "importeur_nr", parallelimportAbgelaufenResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_PARALLELIMPORT_ABGELAUFEN, piReferenzKennr, "pi_referenz_kennr", parallelimportAbgelaufenResponse);
        }
    }

    @Test
    public void parallelimportGueltigEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < parallelimportGueltigResponse.size() - 1; i++)
        {
            String importeurNr = parallelimportGueltigResponse.get(i).get("importeur_nr").asText();
            String piReferenzKennr = parallelimportGueltigResponse.get(i).get("pi_referenz_kennr").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_PARALLELIMPORT_GUELTIG, importeurNr, "importeur_nr", parallelimportGueltigResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_PARALLELIMPORT_GUELTIG, piReferenzKennr, "pi_referenz_kennr", parallelimportGueltigResponse);
        }
    }

    @Test
    public void schadorgGruppeEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < schadorgGruppeResponse.size() - 1; i++)
        {
            String schadorg = schadorgGruppeResponse.get(i).get("schadorg").asText();
            String schadorgGruppe = schadorgGruppeResponse.get(i).get("schadorg_gruppe").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_SCHADORG_GRUPPE, schadorg, "schadorg", schadorgGruppeResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_SCHADORG_GRUPPE, schadorgGruppe, "schadorg_gruppe", schadorgGruppeResponse);
        }
    }

    @Test
    public void staerkungEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < staerkungResponse.size() - 1; i++)
        {
            String kennr = staerkungResponse.get(i).get("kennr").asText();
            String antragstellerNr = staerkungResponse.get(i).get("antragsteller_nr").asText();
            testForExactlyOne(PsmApiTestConst.REQUEST_ENDPOINT_STAERKUNG, kennr, "kennr");
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_STAERKUNG, antragstellerNr, "antragsteller_nr", staerkungResponse);
        }
    }

    @Test
    public void staerkungVertriebEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < staerkungVertriebResponse.size() - 1; i++)
        {
            String kennr = staerkungVertriebResponse.get(i).get("kennr").asText();
            String vertriebsfirmaNr = staerkungVertriebResponse.get(i).get("vertriebsfirma_nr").asText();
            testForExactlyOne(PsmApiTestConst.REQUEST_ENDPOINT_STAERKUNG_VERTRIEB, kennr, "kennr");
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_STAERKUNG_VERTRIEB, vertriebsfirmaNr, "vertriebsfirma_nr", staerkungVertriebResponse);
        }
    }

    @Test
    public void wirkstoffEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < wirkstoffResponse.size() - 1; i++)
        {
            String wirknr = wirkstoffResponse.get(i).get("wirknr").asText();
            testForExactlyOne(PsmApiTestConst.REQUEST_ENDPOINT_WIRKSTOFF, wirknr, "wirknr");
        }
    }

    @Test
    public void wirkstoffGehaltEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < wirkstoffGehaltResponse.size() - 1; i++)
        {
            String kennr = wirkstoffGehaltResponse.get(i).get("kennr").asText();
            String wirknr = wirkstoffGehaltResponse.get(i).get("wirknr").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_WIRKSTOFF_GEHALT, kennr, "kennr", wirkstoffGehaltResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_WIRKSTOFF_GEHALT, wirknr, "wirknr", wirkstoffGehaltResponse);
        }
    }

    @Test
    public void zusatzstoffEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < zusatzstoffResponse.size() - 1; i++)
        {
            String antragstellerNr = zusatzstoffResponse.get(i).get("antragsteller_nr").asText();
            String kennr = zusatzstoffResponse.get(i).get("kennr").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_ZUSATZSTOFF, antragstellerNr, "antragsteller_nr", zusatzstoffResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_ZUSATZSTOFF, kennr, "kennr", zusatzstoffResponse);
        }
    }

    @Test
    public void zusatzstoffVertriebEndpointsTest() throws InterruptedException
    {
        for (int i=0; i < zusatzstoffVertriebResponse.size() - 1; i++)
        {
            String kennr = zusatzstoffVertriebResponse.get(i).get("kennr").asText();
            String vertriebsfirmaNr = zusatzstoffVertriebResponse.get(i).get("vertriebsfirma_nr").asText();
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_ZUSATZSTOFF_VERTRIEB, kennr, "kennr", zusatzstoffVertriebResponse);
            testForAtLeastOne(PsmApiTestConst.REQUEST_ENDPOINT_ZUSATZSTOFF_VERTRIEB, vertriebsfirmaNr, "vertriebsfirma_nr", zusatzstoffVertriebResponse);
        }
    }

}
