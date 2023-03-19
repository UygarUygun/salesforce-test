public class EmailUtil {

    public static void sendOppSummaryEmail(String accName, List<Decimal> content, String address) {
        List<String> addresses = new List<String>();
        addresses.add(address);
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        //List<String> address = new List<String>{'sani@hicglobalsolutions.com'};
            
       	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Opportunity Summary');
        //mail.setplaintextbody('Welcome to HIC Global Solutions');
        String bdy = createHtmlTableForOppSummary(accName, content);
        mail.setHtmlBody(bdy);
        mail.setToAddresses(addresses);
        emailList.add(mail);
        
        if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList);
        }
    } 

    public static String createHtmlTableForOppSummary(String accName, List<Decimal> content){
        String ret = '';
        ret = '<table><tr><th>Account</th><th>Stage</th><th>Amount</th></tr><tr><td>' + accName + '</td><td>Open</td><td>' +
         content[0] + '</td></tr><tr><td>accName</td><td>Closed Won</td><td>' + content[1] + 
         '</td></tr><tr><td>' + accName + '</td><td>Closed Lost</td><td> ' + content[2] + '</td></tr></table>';
        return ret; 
    }
}