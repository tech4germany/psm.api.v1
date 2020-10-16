package de.psm.data.api;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectReader;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import org.testng.Assert;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Test;
import org.testng.log4testng.Logger;
import psm.library.dto.*;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

public class PsmProductTest extends AbstractBaseTest
{
    public Logger log = Logger.getLogger(PsmGetByIdTest.class);

    public static List<Mittel> mittelList = null;
    public static List<Antrag> antragList = null;
    public static List<Auflagen> auflagenList = null;
    public static List<Awg> awgList = null;
    public static List<MittelGefahrenSymbol> mittelGefahrenSymbolList = null;

    public static ObjectMapper mapper = new ObjectMapper().enable(DeserializationFeature.ACCEPT_SINGLE_VALUE_AS_ARRAY);
    public static ObjectReader mittelReader = mapper.readerFor(new TypeReference<List<Mittel>>() {});
    public static ObjectReader antragReader = mapper.readerFor(new TypeReference<List<Antrag>>() {});
    public static ObjectReader auflagenReader = mapper.readerFor(new TypeReference<List<Auflagen>>() {});
    public static ObjectReader awgReader = mapper.readerFor(new TypeReference<List<Awg>>() {});
    public static ObjectReader mittelGefahrenSymbolReader = mapper.readerFor(new TypeReference<List<MittelGefahrenSymbol>>() {});

    // limit requests by MAX_ITEMS
    public static final String queryParam = "?" + PsmApiTestConst.URL_PARAM_NAME_MAX_ITEMS + "=" + PsmApiTestConst.URL_PARAM_MAX_ITEMS_VALUE;


    private static <T> T getFromResponse(Response response, ObjectReader reader) throws IOException
    {
        Assert.assertEquals(PsmApiTestConst.RESPONSE_STATUS_CODE_200, response.getStatusCode(), PsmApiTestConst.ERROR_MESSAGE_UNEXPECTED_STATUS_CODE);
        JsonNode jsonNode = response.body().as(JsonNode.class);
        return reader.readValue(jsonNode.get(PsmApiTestConst.RESPONSE_JSON_ARRAY_KEY));
    }

    @BeforeSuite
    public static void setup() throws IOException
    {
        RestAssured.baseURI = PsmApiTestConst.BASE_HTTP_URL_TEST;

        // request all getAll endpoints
        mittelList = getFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL + queryParam), mittelReader);
        antragList = getFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_ANTRAG + queryParam), antragReader);
        auflagenList = getFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AUFLAGEN + queryParam), auflagenReader);
        awgList = getFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_AWG + queryParam), awgReader);
        mittelGefahrenSymbolList = getFromResponse(RestAssured.get(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL_GEFAHRENSYMBOL + queryParam), mittelGefahrenSymbolReader);
    }

    @Test
    public void productDuplicatedNameTest()
    {
        Map<String, List<Mittel>> mittelMap= new LinkedHashMap<>();
        for (Mittel mittel : mittelList)
        {
            mittelMap.computeIfAbsent(mittel.getMittelname(), x -> new ArrayList<>()).add(mittel);
        }
        mittelMap.entrySet().stream().filter(entry -> entry.getValue().size() > 2);
        Assert.assertEquals(0, mittelMap.entrySet().stream().filter(entry -> entry.getValue().size() > 2).count());
    }

    // MITTEL ohne übereinstimmenden Antrag
    @Test
    public void productWithoutApplicationTest() throws IOException, InterruptedException {
        for (Mittel mittel : mittelList)
        {
            log.info("start request: " + PsmApiTestConst.REQUEST_ENDPOINT_ANTRAG + " " + PsmApiTestConst.REQUEST_PARAMTER_KENNR + " " + mittel.getKennr());
            Response response = RestAssured.given().when()
                    .queryParam(PsmApiTestConst.REQUEST_PARAMTER_KENNR, mittel.getKennr())
                    .get(PsmApiTestConst.REQUEST_ENDPOINT_ANTRAG);

            Assert.assertEquals(PsmApiTestConst.RESPONSE_STATUS_CODE_200, response.getStatusCode(), PsmApiTestConst.ERROR_MESSAGE_UNEXPECTED_STATUS_CODE);
            log.info("request: " + PsmApiTestConst.REQUEST_ENDPOINT_ANTRAG + " " + PsmApiTestConst.REQUEST_PARAMTER_KENNR + " "  + mittel.getKennr() + " success");
            List<Antrag> loadedAntragListe = getFromResponse(response, antragReader);
            Assert.assertNotEquals(0, loadedAntragListe.size());

            slowDown(PsmApiTestConst.BE_NICE);
        }
    }



    // MITTEL ohne übereinstimmende AWG
    @Test
    public void productWithoutUsageTest() throws IOException, InterruptedException {
        for (Mittel mittel : mittelList)
        {
            log.info("start request: " + PsmApiTestConst.REQUEST_ENDPOINT_AWG + " " + PsmApiTestConst.REQUEST_PARAMTER_KENNR + " " +  mittel.getKennr());
            Response response = RestAssured.given().when().queryParam(PsmApiTestConst.REQUEST_PARAMTER_KENNR, mittel.getKennr()).get(PsmApiTestConst.REQUEST_ENDPOINT_AWG);
            Assert.assertEquals(PsmApiTestConst.RESPONSE_STATUS_CODE_200, response.getStatusCode(), PsmApiTestConst.ERROR_MESSAGE_UNEXPECTED_STATUS_CODE);
            log.info("request: " + PsmApiTestConst.REQUEST_ENDPOINT_AWG + " " + PsmApiTestConst.REQUEST_PARAMTER_KENNR + mittel.getKennr() +  " success");
            List<Awg> laodedAwgList = getFromResponse(response, awgReader);
            Assert.assertNotEquals(0, laodedAwgList.size());

            slowDown(PsmApiTestConst.BE_NICE);
        }
    }

    //MITTEL_AUFLAGE ohne übereinstimmende MITTEL
    @Test
    public void productConstraintWithoutProductTest() throws IOException, InterruptedException {
        List<Auflagen> mittelAuflagenListe = auflagenList.stream().filter(auflagen -> auflagen.getEbene().length() == 0).collect(Collectors.toList());
        for (Auflagen auflagen : mittelAuflagenListe)
        {
            log.info("start request: " + PsmApiTestConst.REQUEST_ENDPOINT_MITTEL + " " + PsmApiTestConst.REQUEST_PARAMTER_KENNR + " " + auflagen.getEbene());
            Response response = RestAssured.given().when().queryParam(PsmApiTestConst.REQUEST_PARAMTER_KENNR, auflagen.getEbene()).get(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL);
            Assert.assertEquals(PsmApiTestConst.RESPONSE_STATUS_CODE_200, response.getStatusCode(), PsmApiTestConst.ERROR_MESSAGE_UNEXPECTED_STATUS_CODE);
            log.info("request: " + PsmApiTestConst.REQUEST_ENDPOINT_MITTEL + " " + PsmApiTestConst.REQUEST_PARAMTER_KENNR + " " + " success");
            List<Mittel> loadedMittelList = getFromResponse(response, mittelReader);
            Assert.assertNotEquals(0, loadedMittelList.size());

            slowDown(PsmApiTestConst.BE_NICE);
        }
    }

    // MITTEL_GEFAHREN_SYMBOL ohne über. MITTEL
    @Test
    public void productDangerSymbolWithoutProductTest() throws IOException, InterruptedException {
        for (MittelGefahrenSymbol mittelGefahrenSymbol : mittelGefahrenSymbolList)
        {
            log.info("start request: " + PsmApiTestConst.REQUEST_ENDPOINT_MITTEL + " " + PsmApiTestConst.REQUEST_PARAMTER_KENNR + ": " + mittelGefahrenSymbol.getKennr());
            Response response = RestAssured.given().when().queryParam(PsmApiTestConst.REQUEST_PARAMTER_KENNR, mittelGefahrenSymbol.getKennr()).get(PsmApiTestConst.REQUEST_ENDPOINT_MITTEL);
            Assert.assertEquals(PsmApiTestConst.RESPONSE_STATUS_CODE_200, response.getStatusCode(), PsmApiTestConst.ERROR_MESSAGE_UNEXPECTED_STATUS_CODE);
            log.info("request: " + PsmApiTestConst.REQUEST_ENDPOINT_MITTEL + " " + PsmApiTestConst.REQUEST_PARAMTER_KENNR + ": " + mittelGefahrenSymbol.getKennr() + " success");
            List<Mittel> loadedMittelList = getFromResponse(response, mittelReader);
            Assert.assertNotEquals(0, loadedMittelList.size());

            slowDown(PsmApiTestConst.BE_NICE);
        }
    }

}
