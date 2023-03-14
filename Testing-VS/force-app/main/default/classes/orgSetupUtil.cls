public class orgSetupUtil{
    
    /*
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
*/
    
    /*
// Constructs the Tooling API wrapper (default constructor uses user session Id)
ToolingAPI toolingAPI = new ToolingAPI();

// Query CustomObject object by DeveloperName (note no __c suffix required)
List<ToolingAPI.CustomObject> customObjects = (List<ToolingAPI.CustomObject>)
toolingAPI.query('Select Id, DeveloperName, NamespacePrefix From CustomObject Where DeveloperName = \'Test\'').records;

// Query CustomField object by TableEnumOrId (use CustomObject Id not name for Custom Objects)
ToolingAPI.CustomObject customObject = customObjects[0];
Id customObjectId = customObject.Id;
List<ToolingAPI.CustomField> customFields = (List<ToolingAPI.CustomField>)
toolingAPI.query('Select Id, DeveloperName, NamespacePrefix, TableEnumOrId From CustomField Where TableEnumOrId = \'' + customObjectId + '\'').records;

// Dump field names (reapply the __c suffix) and their Id's
System.debug(customObject.DeveloperName + '__c : ' + customObject.Id);
for(ToolingAPI.CustomField customField : customFields)
System.debug(
customObject.DeveloperName + '__c.' +
customField.DeveloperName + '__c : ' +
customField.Id);

*/
    
    public static void addIsPrimaryContactField(){
        Metadata.customMetadata cont = new Metadata.CustomMetadata();
        cont.fullName = 'MyNamespace__MetadataTypeName.MetadataRecordName';
        Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue(); 
		customField.field = 'isPrimaryContact__c';
        customField.value = 'New value';
        cont.values.add(customField);
    }
    
    public static void addPrimaryContactPhoneField(){
        
    }
}