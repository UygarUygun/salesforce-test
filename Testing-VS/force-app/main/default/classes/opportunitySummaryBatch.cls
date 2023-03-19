public class opportunitySummaryBatch implements Database.Batchable<sObject>, Database.StateFul {
    
    //public List<String> opportunityStagesToChoose = new List<String>('Closed Won', 'Closed Lost');
    public Map<Id, List<Decimal>> accountOppsSummarized = new Map<Id, List<Decimal>>();
    public List<Account> allAccounts = new List<Account>();
    public Map<Id, String> accountPrimaryContactMailMap = new Map<Id, String>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        //collect all acoounts and their primary contacts and opportunities to pass to exe
        return Database.getQueryLocator(
            'SELECT Id, Name, (SELECT Amount, StageName FROM Opportunities), (SELECT Email, AccountId FROM Contacts WHERE is_Primary_Contact__c=true) FROM Account'
        );

    }
    public void execute(Database.BatchableContext bc, List<Account> accounts){
        // process each batch of records
        allAccounts.addAll(accounts);

        for (Account acc : accounts){

            //[0] is open, [1] is closed won, [2] is closed lost
            List<Decimal> oppAmountsByStage = new List<Decimal>();

            for (Opportunity opp: acc.Opportunities){
                //Summarize the opp amounts by stage
                if(opp.StageName == 'Closed Lost'){
                    oppAmountsByStage[2] = oppAmountsByStage[2] + opp.Amount;
                } else if(opp.StageName == 'Closed Won'){
                    oppAmountsByStage[1] = oppAmountsByStage[1] + opp.Amount;
                } else {
                    oppAmountsByStage[0] = oppAmountsByStage[0] + opp.Amount;
                }
            }
            
            //save oppAmounts summary and primary contact mail in a map
            accountOppsSummarized.put(acc.Id, oppAmountsByStage);
            accountPrimaryContactMailMap.put(acc.Id, acc.Contacts[0].Email);
        }

    }
    public void finish(Database.BatchableContext bc){
        // send emails through some util class to respective classes
        /*
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        */
        for(Account a : allAccounts){
            EmailUtil.sendOppSummaryEmail(a.Name, accountOppsSummarized.get(a.Id), accountPrimaryContactMailMap.get(a.Id));
        }
    }
}