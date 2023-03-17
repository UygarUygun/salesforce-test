global class ContactUpdateBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
private List<Contact> contactsToUpdate;

global ContactUpdateBatch(List<Contact> contactsToUpdate) {
    this.contactsToUpdate = contactsToUpdate;
}

global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator([SELECT Id, AccountId, is_Primary_Contact__c, Primary_Contact_Phone__c FROM Contact WHERE Id IN :contactsToUpdate]);
}

global void execute(Database.BatchableContext BC, List<Contact> scope) {
    try {
        List<Contact> contactList = new List<Contact>();

        for (Contact iContact : scope){
            //update related contacts primary contact phone field with the current contacts primary contact phone field value
            if(iContact.is_Primary_Contact__c == true){
                List<Contact> contactsToBeUpdated = [SELECT id, Primary_Contact_Phone__c FROM Contact WHERE AccountId=:iContact.AccountId];
                for (Contact c : contactsToBeUpdated){
                    c.Primary_Contact_Phone__c = iContact.Primary_Contact_Phone__c;
                }
                contactList.addAll(contactsToBeUpdated);
            }
            //autopopulate current contacts primary contact phone field with the primary contact of its related accounts primary contact phone value
            else{
                try{
                    iContact.Primary_Contact_Phone__c = [SELECT id, Primary_Contact_Phone__c FROM Contact 
                                                        WHERE AccountId=:iContact.AccountId AND is_Primary_Contact__c=true LIMIT 1][0].Primary_Contact_Phone__c;
                }
                catch (Exception e){
                    System.debug('The account does not have a primary account set the primary contact field did not auto populate');
                }
            }
        }

        //update scope;
        update contactList;
    } catch (Exception e) {
        System.debug(e.getMessage());
        }
    }

    global void finish(Database.BatchableContext BC) {}
}