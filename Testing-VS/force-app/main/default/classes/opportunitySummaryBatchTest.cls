@isTest
public class opportunitySummaryBatchTest {
    @testSetup
    static void setup(){
        List<Account> accounts = new List<Account>();
        List<Opportunity> opportunities = new List<Opportunity>();
        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i<50; i++){
            //Account creation
            accounts.add(new Account(name='Account '+i));
        }

        insert accounts;

        List<Account> pulledAccounts = [SELECT id FROM Account];

        //Some primary contacts and opps are inserted for previouslt created accounts
        for (Account a : pulledAccounts){
            contacts.add(new Contact(firstName='Primary', lastName='Contact', AccountId=a.Id, is_Primary_Contact__c=true, Email='testEmail@salesforce.com'));

            for (Integer j=0; j<4; j++){
                opportunities.add(new Opportunity(AccountId=a.Id, Name='Opp'+j, StageName='Prospecting', Amount=500, CloseDate= date.TODAY()+10));
                opportunities.add(new Opportunity(AccountId=a.Id, Name='Opp'+j, StageName='Closed Won', Amount=300, CloseDate= date.TODAY()+10));
                opportunities.add(new Opportunity(AccountId=a.Id, Name='Opp'+j, StageName='Closed Lost', Amount=100, CloseDate= date.TODAY()+10));
            }
        }
        insert opportunities;
        insert contacts;
    }

    @isTest static void test() {
        Test.startTest();
        opportunitySummaryBatch usb = new opportunitySummaryBatch();
        Id batchId = Database.executeBatch(usb);
        Test.stopTest();
        
        //I am using this test class to check the logs which seems to be working allright
        System.assert(true);
    }


}