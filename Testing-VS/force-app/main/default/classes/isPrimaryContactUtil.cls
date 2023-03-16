public class isPrimaryContactUtil {
    
    //checks the accounts contacts returns true if any contact of that account is set as primary contact
    public static Boolean hasPrimaryContact(Id accId){
        Boolean res = false;
        List<Contact> primaryContacts = [SELECT Id, Name FROM Contact WHERE AccountId=:accId AND is_Primary_Contact__c=true];
        if (!primaryContacts.isEmpty()){
        	    res=true;
        }        
        return res;
    }
    
    //updates all the contacts primary phone number if they are not set as the primary contact
    public static void updateAllContactsPhone(  List<Contact> insertedContacts){
        List<Contact> contactList = new List<Contact>();

        for (Contact iContact : insertedContacts){
            if(iContact.is_Primary_Contact__c == true){
                List<Contact> contactsToBeUpdated = [SELECT id, Primary_Contact_Phone__c FROM Contact WHERE AccountId=:iContact.AccountId];
                for (Contact c : contactsToBeUpdated){
                    c.Primary_Contact_Phone__c = iContact.Primary_Contact_Phone__c;
                }
                contactList.addAll(contactsToBeUpdated);
            }
            else{
                iContact.Primary_Contact_Phone__c = [SELECT id, Primary_Contact_Phone__c FROM Contact 
                                                    WHERE AccountId=:iContact.AccountId AND is_Primary_Contact__c=true LIMIT 1][0].Primary_Contact_Phone__c;
            }
        }

        update contactList;

        /*
        List<Contact> relatedContacts = [SELECT Id, Name FROM Contact WHERE AccountId=:acc.Id AND is_Primary_Contact__c=false];
        for (Contact cont : relatedContacts){
            cont.Primary_Contact_Phone__c = PhoneNumber;
        }
        update relatedContacts;
        */
    }
    
    
    //sarting of logic to prevent user to create primary contact if there is any existing primary contact under account
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
    
    
    
}