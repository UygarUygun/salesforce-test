@isTest
public class testContactCreation {
    public static Account acc0 = new Account(name='Account0');
    
    static List<Contact> acc0Conts = new List<Contact>();
    
    static List<Contact> conts = new List<Contact>();
    
    
    @testSetup 
    static void setup(){    
        
        insert acc0;
        
        for(Integer i=0; i<50; i++){
            //default contacts
            acc0Conts.add(new Contact(firstName='Test '+i, lastName='0', AccountId=acc0.id));
        }
        conts.addAll(acc0Conts);
        
        insert conts;
    }
    
    @isTest
    static void testValidNewPrimaryInsert(){
        //Map<Id, Account> accMap = new Map<Id, Account>(accs);
        Contact primaryContact = new Contact(firstName='Valid', lastName='Primary', AccountId=acc0.Id, is_Primary_Contact__c=true, Primary_Contact_Phone__c='111222333');
        Test.startTest();
        Database.UpsertResult result = Database.upsert(primaryContact);
        Test.stopTest();
        System.assert(result.getErrors().size() == 0);
    }
    
    @isTest
    static void testNonValidPrimaryInsert(){
        Contact primaryContact = new Contact(firstName='Valid', lastName='Primary', AccountId=acc0.Id, is_Primary_Contact__c=true, Primary_Contact_Phone__c='111222333');
        Contact nonValidPrimaryContact = new Contact(firstName='NonValid', lastName='Primary', AccountId=acc0.Id, is_Primary_Contact__c=true, Primary_Contact_Phone__c='111222333');
        Database.UpsertResult result = Database.upsert(primaryContact);
        Boolean expectedExceptionThrown = false;
        
        try{
            Test.startTest();
        	result = Database.upsert(nonValidPrimaryContact);
            Test.stopTest();
        }
        catch(DmlException e){
            expectedExceptionThrown =  e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION');
        }        
        
        System.assert(expectedExceptionThrown);
        
    }
    
    /*
    @isTest
    static void testBulkValidInsert(){
        
    }
    
    @isTest
    static void testBulkNonValidInsert(){
        
    }
	*/
}