@isTest
public class weatherCalloutsTest {

    @isTest
    static void testGetCallout1(){

    }

    @isTest 
    static  void testGetCallout() {

        Test.setMock(HttpCalloutMock.class, new weatherCalloutHttpMock()); 

        // Call method to test
        HttpResponse response = weatherCallouts.weatherInfoGetCallout('Izmir');
        
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');

        String actualValue = response.getBody();
        
        System.debug(response.getBody());
        String expectedValue = '{"coord":{"lon":27.0923,"lat":38.4622},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],' + 
        '"base":"stations","main":{"temp":282.88,"feels_like":278.64,"temp_min":282.88,"temp_max":282.88,"pressure":1017,"humidity":81},' + 
        '"visibility":10000,"wind":{"speed":11.83,"deg":360},"clouds":{"all":0},"dt":1679270393,' + 
        '"sys":{"type":1,"id":6977,"country":"TR","sunrise":1679285759,"sunset":1679329350},"timezone":10800,"id":311044,"name":"İzmir","cod":200}';
        System.assertEquals(expectedValue, actualValue);
        System.assertEquals(200, response.getStatusCode());
        
    }   

}