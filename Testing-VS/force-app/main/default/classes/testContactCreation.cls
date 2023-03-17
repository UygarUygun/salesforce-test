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
        for(Integer i=0; i<20; i++){
            //default contacts
            acc0Conts.add(new Contact(firstName='Test '+i, lastName='0', AccountId=acc0.id));
            acc1Conts.add(new Contact(firstName='Test '+i, lastName='1', AccountId=acc1.id));
        }
        Contact primaryContact = new Contact(firstName='Valid', lastName='Primary', AccountId=acc1.Id, is_Primary_Contact__c=true, Primary_Contact_Phone__c='000000000');
        //conts.add(primaryContact);
        conts.addAll(acc0Conts);
        conts.addAll(acc1Conts);
        insert conts;
    }
    
    @isTest
    //assert that the new contact is successfully inserted without errors
    static void testValidNewPrimaryInsert(){
        Contact primaryContact = new Contact(firstName='Valid', lastName='Primary', AccountId=acc0.Id, is_Primary_Contact__c=true, Primary_Contact_Phone__c='111222333');
        Test.startTest();
        Database.UpsertResult result = Database.upsert(primaryContact);
        Test.stopTest();
        System.assert(result.getErrors().size() == 0);
    }
    
    @isTest
    //assert that a second priamry contact insertion fails but does not disrupt the other contact insertions
    static void testNonValidPrimaryInsert(){
        Boolean flag = false;
        Account acc = [SELECT id FROM Account LIMIT 1][0];
        
        try{
            Test.startTest();
            Contact validPrimary = new Contact(firstName='NONVALID', lastName='Primary', AccountId=acc.Id, is_Primary_Contact__c=true, Primary_Contact_Phone__c='111111111');
            Contact nonValidPrimary = new Contact(firstName='NONVALID 2', lastName='Primary', AccountId=acc.Id, is_Primary_Contact__c=true, Primary_Contact_Phone__c='222222222');
            Contact validNonPrimaryContact = new Contact(firstName='Valid', lastName='NONPrimary', AccountId=acc.Id, is_Primary_Contact__c=false);
            List<Contact> newContacts = new List<Contact>();
            //newContacts.add(anotherPrimaryContact);
            insert validPrimary;
            newContacts.add(nonValidPrimary);
            newContacts.add(validNonPrimaryContact);
            
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
        List<Contact> chosenPrims = [SELECT id FROM Contact WHERE AccountId=:acc.Id AND is_Primary_Contact__c=true];
        List<Contact> successfullyInsertedContacts = [SELECT id FROM Contact WHERE AccountId=:acc.Id AND Primary_Contact_Phone__c = '111111111'];
        
        System.assertEquals(1, chosenPrims.size());
        System.assertEquals(22, successfullyInsertedContacts.size());
    }
}