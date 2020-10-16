# Automatisierte Tests für die REST Schnittstelle

Um diese Schnittstelle zu testen, befinden sich in dem GitHub-Repository [Unit-Tests](src/test/java/de/psm/data/api), welche die korrekte Ausgabe der Daten über die Schnittstelle prüfen können.

## Unit Tests

Es sind einige beispielhafte Tests vorhanden, um die Schnittstelle zu testen.
Die Unit Tests sind mit Hilfe von [RestAssured](https://github.com/rest-assured/rest-assured) und [TestNG](https://de.wikipedia.org/wiki/TestNG) umgesetzt.

Es gibt eine [Testdatei](src/test/java/de/psm/data/api/PsmGetByIdTest.java), die sämtliche Endpunkte prüft, ob sie:

- einen 200er Statuscode zurückgeben,
- ein valides json zurückgeben und
- ein (erwartetes) `items` Element beinhalten.

Zusätzlich wird in einzelnen Methoden in derselben Datei geprüft, ob auch die Endpunkte bei Übergabe eines Parameters

- einen 200er Statuscode zurückgeben,
- ein valides json zurückgeben,
- ein (erwartetes) `items` Element beinhalten,
- die richtige Anzahl Rückgabewerte haben (genau ein Rückgabe "item" bei Anfrage einer ID) und
- die zurückgegebenen "item"s die angefragen Parameter als Attribute beinhalten (Validierung, dass die Filterlogik funktioniert).

Mit diesen Unit Tests kann sichergestellt werden, dass ORDS korrekt konfiguriert ist und die API funktioniert.
Die Anzahl der abgefragten `items` kann konfiguriert werden, indem der Parameter `URL_PARAM_MAX_ITEMS_VALUE`, angepasst wird:

BaseUrl Einstellung und ähnliche Anpassungen für die Tests können in [PsmApiTestConst.java](src/test/java/de/psm/data/api/PsmApiTestConst.java) gemacht werden.

```bash
public class PsmApiTestConst
{
    public static final String BASE_HTTP_URL_TEST = "http://127.0.0.1:8080/ords/psm/api-v1/";

    // Adjust this number to query and check more or less items per endpoint.
    // The more items are queried, the longer the tests will take.
    public static final int    URL_PARAM_MAX_ITEMS_VALUE = 200;

    // activate be_nice mode, to make sure not getting blocked by the server
    public static final boolean BE_NICE = true;
...

```
|                           |                                                                                    |
|---------------------------|------------------------------------------------------------------------------------|
| BASE_HTTP_URL_TEST        | gibt die basis URL für alle Requests an                                            |
| URL_PARAM_MAX_ITEMS_VALUE | steuert das Page-Limit, in diesem Fall werden maximal 200 Einträge geladen.        |
| BE_NICE                   | sorgt für einen sleep von 1 sek. nach jedem Request                                |


### Maven
Die Tests ausführen mit:
```bash
mvn test
```

### Eclipse

##### TestNG Plugin installieren

https://marketplace.eclipse.org/content/testng-eclipse

## Postman Tests

Analog zu den Unit Tests mit RestAssured kann auch Postman zum Testen der API verwendet werden.

In der Datei [PsmServicePostmanTests.json](postman/PsmServicePostmanTests.json) sind bereits einige beispielhafte Tests vorhanden,
die mit Postman [importiert](https://learning.postman.com/docs/getting-started/importing-and-exporting-data/) werden können. Die Tests wurden zuerst mit [Telosys generiert](https://github.com/telosys-templates-v3/web-rest-postman) und dann händisch um konkrete Parameter ergänzt.

##### Weiterführende Links

[Writing tests in Postman](https://blog.postman.com/writing-tests-in-postman/)

[Using the Collection Runner](https://learning.postman.com/docs/running-collections/intro-to-collection-runs/)


