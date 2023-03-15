public class isPrimaryContactUtil {
    
    //checks the accounts contacts returns true if any contact of that account is set as primary contact
    public static Boolean hasPrimaryContact(Id accId){
        Boolean res = false;
        List<Contact> primaryContacts = [SELECT Id, Name FROM Contact WHERE AccountId=:accId AND is_Primary_Contact__c=true];
        if (!primaryContacts.isEmpty()){
        	    res=true;
        }        
        return res;
    }
    
    //updates all the contacts primary phone number if they are not set as the primary contact
    public static void updateAllContactsPhone(Account acc, String PhoneNumber){
        List<Contact> relatedContacts = [SELECT Id, Name FROM Contact WHERE AccountId=:acc.Id AND is_Primary_Contact__c=false];
        for (Contact cont : relatedContacts){
            cont.Primary_Contact_Phone__c = PhoneNumber;
        }
        update relatedContacts;
    }
    
}