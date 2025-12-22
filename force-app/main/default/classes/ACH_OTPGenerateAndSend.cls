public with sharing class ACH_OTPGenerateAndSend {
    @InvocableMethod(label='Generate and Send OTP to Investor')
    public static void generateAndSendOTP(List<Id> investorIds) {
        for (Id investorId : investorIds) {
            ACH_OTPService.assignOTPToInvestor(investorId);
            SK_ACH_Investor__c investor = [SELECT Id, SK_ACH_Email__c, SK_ACH_Phone__c, SK_ACH_OTP__c FROM SK_ACH_Investor__c WHERE Id = :investorId LIMIT 1];
            if (String.isNotBlank(investor.SK_ACH_Email__c)) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { investor.SK_ACH_Email__c });
                mail.setSubject('Your OTP for Data Access');
                mail.setPlainTextBody('Your OTP is: ' + investor.SK_ACH_OTP__c + '\nThis OTP is valid for 10 minutes.');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            // (Optional) Add SMS logic here if you have an SMS provider
        }
    }
}
