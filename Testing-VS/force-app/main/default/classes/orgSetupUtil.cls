public class orgSetupUtil{
    public static HttpResponse addIsPrimaryContactField(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('/services/data/v42.0/tooling/sobjects/CustomField');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{"FullName": "CO1__c.test__c", "Metadata": { "label": "test", "description": "my new test field", "required": false, "externalId": false, "type": "Text", "length": 32 }}');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        return response;
    }
    
    public static void addPrimaryContactPhoneField(){
        
    }
}