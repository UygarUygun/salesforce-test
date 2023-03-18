public class isPrimaryContactUtil {    

    //////////////////////////////////LEGACY ALGORTIHM I'M LEAVING IT HERE FOR COMPARISON WITH THE NEW ALGORITHM @CONTACTQUEUEABLE CLASS////////////////////////////
/*
    //updates all the contacts primary phone number if they are not set as the primary contact
    public static void updateAllContactsPhone(List<Contact> insertedContacts){
        List<Contact> contactList = new List<Contact>();

        for (Contact iContact : insertedContacts){
            //update related contacts primary contact phone field with the current contacts primary contact phone field value
            if(iContact.is_Primary_Contact__c == true){
                
                //TODO: take this query out of for loop
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

        update contactList;
    }  
*/  
    //////////////////////////////////END OF LEGACY ALGORTIHM I'M LEAVING IT HERE FOR COMPARISON WITH THE NEW ALGORITHM @CONTACTQUEUEABLE CLASS////////////////////////////
    

    //after insertion triggers this method will update all contacts in the database by querying all contacts into two groups
    //primaryContacts list will determine the account primary contact phone and nonPrimaryContacts will be updated with their accounts 
    //primary contact phone number
    public static void updateAllContactsPhone(List<Contact> insertedContacts){
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
            System.debug('Contact inserted');
        }
        catch(Exception e){
            System.debug('Contact can not be inserted: ' + e.getMessage());
        }
    }

    
    //sorting of logic to prevent user to create primary contact if there is any existing primary contact under account
    public static void preventCreatePrimaryContactOnInsert(List<Contact> contactList){
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id,Contact> accountIdContactMap = new Map<Id,Contact>();

        for(Contact contactObj:contactList){
            if(contactObj.is_Primary_Contact__c==true && contactObj.AccountID!=null){               
                accountIdSet.add(contactObj.AccountID);
            }
        }
        if(accountIdSet!=null && accountIdSet.size()>0){            
            //Preparation of map accountIdContactMap for existing primary contact
            for(Contact contObj:[select id,is_Primary_Contact__c,AccountId from Contact 
                    where AccountId in:accountIdSet and is_Primary_Contact__c=true]){
                    accountIdContactMap.put(contObj.AccountId,contObj);
            }
            //validation starts
            for(Contact contactObj:contactList){
                if(contactObj.is_Primary_Contact__c==true && contactObj.AccountID!=null
                     && accountIdContactMap.get(contactObj.AccountId)!=null){
                        contactObj.addError('You can\'t create more than one primary contact.');
                    }                       
            }
        }        
    }

    //
    
    
}