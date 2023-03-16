trigger setAsPrimaryTrigger on Contact (before delete,after update,before insert,before update,after insert) {
    //this trigger will fire on inserts and updates to validate the related account does not have any primary contacts
    //if the account already has primary contacts and current contact is set as primary contact too then throw error
    //if the account does not have a primary contact, allow the current contact to be set as primary AND update all related contacts primary contact phone field
    
    /*
    List<Contact> nonPrimaryContacts = new List<Contact>();
    
    for (Contact c : Trigger.new){
        List<Contact> primaryContacts = [SELECT Id, Name, Primary_Contact_Phone__c FROM Contact WHERE AccountId=:c.AccountId AND is_Primary_Contact__c=true];
        nonPrimaryContacts = [SELECT Id, Name, Primary_Contact_Phone__c FROM Contact WHERE AccountId=:c.AccountId AND is_Primary_Contact__c=false];
        Boolean accHasPrimaryC = !primaryContacts.isEmpty();
        
        if(c.is_Primary_Contact__c && accHasPrimaryC){
            //error statement
            c.addError(
                'Cannot add contact as primary contact to an account with existing primary contact.');
        }        
        else if (c.is_Primary_Contact__c || accHasPrimaryC){
            for (Contact nonPrimc : nonPrimaryContacts){
                nonPrimc.Primary_Contact_Phone__c = primaryContacts[0].Primary_Contact_Phone__c;
            }
            
        }
        if(!c.is_Primary_Contact__c && c.Primary_Contact_Phone__c != '' && accHasPrimaryC){
            c.Primary_Contact_Phone__c = primaryContacts[0].Primary_Contact_Phone__c;
        }
        
    }
    
    if (Trigger.isBefore){
        upsert nonPrimaryContacts;
        System.debug('Contact inserted');
    }
    */
    
    /*
    ContactQueueable contactQueueable = new ContactQueueable(Trigger.new);
    System.enqueueJob(contactQueueable);
    */
    
    if(trigger.isBefore && trigger.isInsert){
        isPrimaryContactUtil.preventCreatePrimaryContactOnInsert(trigger.new);
        isPrimaryContactUtil.updateAllContactsPhone(trigger.new);
    }
    
}