trigger setAsPrimaryTrigger on Contact (before insert) {
    //this trigger will fire on inserts and updates to validate the related account does not have any primary contacts
    //if the account already has primary contacts and current contact is set as primary contact too then throw error
    //if the account does not have a primary contact, allow the current contact to be set as primary AND update all related contacts primary contact phone field
    
    List<Contact> nonPrimaryContacts = new List<Contact>();
    Map<Contact, Account> contToAccPCMap = new Map<Contact, Account>();
    Map<Account, Contact> accToContPCMap = new Map<Account, Contact>();
    
    for (Contact c : Trigger.new){
        if(contToAccPCMap.containsKey(c)){
            
        }
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
    
    
}