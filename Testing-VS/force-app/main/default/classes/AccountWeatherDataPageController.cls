public class AccountWeatherDataPageController {
    public Account account { get; private set; }
    public String billingCity { get; set; }

    public Decimal temperature { get; set; }
    public String description { get; set; }
    public String iconUrl { get; set; }


    public AccountWeatherDataPageController(ApexPages.StandardController stdController){
        account = (Account)stdController.getRecord();
    }
    
    public PageReference saveBillingCity() {
        if (billingCity != null && billingCity.trim() != ''){
            account.BillingCity = billingCity;
        }
        return null;
    }

    public void calculateWeatherData(){
        HttpResponse response = weatherCallouts.weatherInfoGetCallout(account.billingCity);

        //LOGIC STARTS HERE
        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

        // Cast the values in the 'weather' key as a map
        List<Object> weatherData = (List<Object>) results.get('weather');
        Map<String, Object> weatherDataResponseMap = (Map<String, Object>) weatherData[0];
        System.debug('Received the following data:');
        System.debug(weatherData[0]);
        System.debug(weatherDataResponseMap.get('description'));
        System.debug(weatherDataResponseMap.get('main'));
        System.debug(weatherDataResponseMap.get('icon'));
        //LOGIC ENDS HERE

        Map<String, Object> main = (Map<String, Object>) results.get('main');
        temperature = (Decimal) main.get('temp') - 273.15; //conversion from kelvin to celcius
        description = (String) weatherDataResponseMap.get('description');
        iconUrl = 'https://openweathermap.org/img/wn/' + (String) weatherDataResponseMap.get('icon') + '.png';
    }
}