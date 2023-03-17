trigger setAsPrimaryTrigger on Contact (before delete,after update,before insert,before update,after insert) {
    //this trigger will fire on inserts and updates to validate the related account does not have any primary contacts
    //if the account already has primary contacts and current contact is set as primary contact too then throw error
    //if the account does not have a primary contact, allow the current contact to be set as primary AND update all related contacts primary contact phone field
    
    
    if(trigger.isBefore && trigger.isInsert){
        isPrimaryContactUtil.preventCreatePrimaryContactOnInsert(trigger.new);
        isPrimaryContactUtil.updateAllContactsPhone(trigger.new);
        //Database.executeBatch(new ContactUpdateBatch(trigger.new));
    }
    
}