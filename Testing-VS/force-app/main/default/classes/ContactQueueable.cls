public class ContactQueueable implements System.Queueable {
    private List<Contact> ContactsToProcess = new List<Contact>();
    
    public ContactQueueable(List<Contact> contactsToProcess) {
        this.contactsToProcess = contactsToProcess;
    }
    
    public void execute(System.QueueableContext context) {
        // Process each contact asynchronously
        List<Contact> nonPrimaryContacts = new List<Contact>();
        for(Contact c : contactsToProcess) {
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
        
        
        try{
            upsert nonPrimaryContacts;
        }
        catch(Exception e){
            System.debug('Contact can not be inserted: ' + ContactsToProcess);
        }
        
        System.debug('Contact inserted ');
    }
}