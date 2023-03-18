public class ContactQueueable implements System.Queueable {
    private List<Contact> ContactsToProcess = new List<Contact>();
    
    public ContactQueueable(List<Contact> contactsToProcess) {
        this.contactsToProcess = contactsToProcess;
    }
    
    public void execute(System.QueueableContext context) {
        // Process each contact asynchronously

        List<Contact> primaryContacts = [SELECT Id, Name, AccountId, Primary_Contact_Phone__c FROM Contact WHERE is_Primary_Contact__c=true];
        List<Contact> nonPrimaryContacts = [SELECT Id, Name, AccountId, Primary_Contact_Phone__c FROM Contact WHERE is_Primary_Contact__c=false];

        Map<Id, String> accountPrimaryContactPhoneMap = new Map<Id, String>();

        //map the primary contact phone of accounts
        for (contact c : primaryContacts){
            accountPrimaryContactPhoneMap.put(c.AccountId, c.Primary_Contact_Phone__c);

        }

        //check every nonprimary contacts related account for a primary contact phone, if it exists update their respective fields
        for (Contact c : nonPrimaryContacts){
            try{
                c.Primary_Contact_Phone__c = accountPrimaryContactPhoneMap.get(c.AccountId);
            }
            catch(Exception e){
                System.debug('No primary contact set for this contacts account');
            }
        }      
        
        
        try{
            update nonPrimaryContacts;
        }
        catch(Exception e){
            System.debug('Contact can not be inserted: ' + ContactsToProcess);
        }
        
        System.debug('Contact inserted');
    }
}