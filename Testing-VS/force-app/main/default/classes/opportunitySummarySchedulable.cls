public class opportunitySummarySchedulable implements Schedulable {
    public void execute(SchedulableContext ctx) {
        
        opportunitySummaryBatch summaryBatch = new opportunitySummaryBatch();
        Id batchId = Database.executeBatch(summaryBatch);



        /*
        in order to schedule this schedulable we must use the following anonymous apex script in the developer console

        // Schedule the job to run daily at 10:00 AM
        System.schedule('Daily Opportunity Summary', '0 0 10 * * ?', new opportunitySummarySchedulable());

        // Schedule the job to run every Friday at 1:00 PM
        System.schedule('Weekly Opportunity Summary', '0 0 13 ? * FRI', new opportunitySummarySchedulable());

        // Schedule the job to run on the last Friday of every month at 6:00 PM
        System.schedule('Monthly Opportunity Summary', '0 0 18 ? * 6L', new opportunitySummarySchedulable());

        */

    }

}