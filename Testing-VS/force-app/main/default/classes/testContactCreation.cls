@isTest
public class testContactCreation {
    public static Account acc0 = new Account(name='Account0');
    public static Account acc1 = new Account(name='Account1');
    
    static List<Contact> acc0Conts = new List<Contact>();
    static List<Contact> acc1Conts = new List<Contact>();
    
    static List<Contact> conts = new List<Contact>();
    
    @testSetup 
    static void setup(){            
        insert acc0;
        insert acc1;        
        for(Integer i=0; i<90; i++){
            //default contacts
            acc0Conts.add(new Contact(firstName='Test '+i, lastName='0', AccountId=acc0.id));
            acc1Conts.add(new Contact(firstName='Test '+i, lastName='1', AccountId=acc1.id));
        }
        Contact primaryContact = new Contact(firstName='Valid', lastName='Primary', AccountId=acc1.Id, is_Primary_Contact__c=true, Primary_Contact_Phone__c='000000000');
        conts.add(primaryContact);
        conts.addAll(acc0Conts);
        conts.addAll(acc1Conts);
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
        Boolean flag = false;
        
        try{
            Test.startTest();
            Contact anotherPrimaryContact = new Contact(firstName='NONVALID', lastName='Primary', AccountId=acc1.Id, is_Primary_Contact__c=true);
            Contact yetAnother = new Contact(firstName='NONVALID 2', lastName='Primary', AccountId=acc1.Id, is_Primary_Contact__c=true);
            List<Contact> newContacts = new List<Contact>();
            newContacts.add(anotherPrimaryContact);
            newContacts.add(yetAnother);
            
            List<Database.SaveResult> result;
            result = Database.insert(newContacts, false);
            //result = Database.insert(yetAnother);
            Test.stopTest();
        }
        catch(Exception e){
            System.debug(e.getMessage());
            flag = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION');
        }
        //System.assert(flag);
        List<Contact> chosenPrims = [SELECT id FROM Contact WHERE AccountId=:acc1.Id AND is_Primary_Contact__c=true];
        System.assertEquals(1, chosenPrims.size());
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