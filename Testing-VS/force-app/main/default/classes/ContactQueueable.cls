public class ContactQueueable implements System.Queueable {
    private List<Contact> ContactsToProcess = new List<Contact>();
    
    public ContactQueueable(List<Contact> contactsToProcess) {
        this.contactsToProcess = contactsToProcess;
    }
    
    public void execute(System.QueueableContext context) {
        isPrimaryContactUtil.updateAllContactsPhone(ContactsToProcess);
    }
}