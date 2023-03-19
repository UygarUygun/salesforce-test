public class weatherCallouts {

    private static String APIKEY = 'bb5654fe7257c497c08673677c9e11dd'; 

    //returns the map of information we need to display on the page, makes a http get request by city name
    public static Map<String, Object> weatherInfoGetCallout(String cityName){
        Map<String, Object> weatherDataResponseMap = new Map<String, Object>();

        String calloutMsg = 'https://api.openweathermap.org/data/2.5/weather?q=' + cityName + '&appid=' + APIKEY;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(calloutMsg);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            // Deserializes the JSON string into collections of primitive data types.
            System.debug(response.getBody());            
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

            // Cast the values in the 'weather' key as a map
            List<Object> weatherData = (List<Object>) results.get('weather');
            weatherDataResponseMap = (Map<String, Object>) weatherData[0];
            System.debug('Received the following data:');
            System.debug(weatherData[0]);
            System.debug(weatherDataResponseMap.get('description'));
            System.debug(weatherDataResponseMap.get('main'));
            System.debug(weatherDataResponseMap.get('icon'));

        } else {
            System.debug('There was an error with HTTP Get request: ' + response.getStatusCode());
        }
        return weatherDataResponseMap;
    }

}