/**
 * @description Test class for ACH_OTPGenerateAndSend
 * Covers invocable method for OTP generation and email
 *
 * @author Apex Capital Hub Team
 * @date December 22, 2025
 */
@isTest
private class ACH_OTPGenerateAndSendTest {
    @testSetup
    static void setupInvestor() {
        SK_ACH_Investor__c investor = new SK_ACH_Investor__c(
            Name = 'Flow LP',
            SK_ACH_Investor_Type__c = 'Institutional',
            SK_ACH_Email__c = 'testlp@example.com'
        );
        insert investor;
    }

    @isTest
    static void testGenerateAndSendOTP() {
        SK_ACH_Investor__c investor = [SELECT Id FROM SK_ACH_Investor__c WHERE Name = 'Flow LP' LIMIT 1];
        List<Id> ids = new List<Id>{investor.Id};
        Test.startTest();
        ACH_OTPGenerateAndSend.generateAndSendOTP(ids);
        Test.stopTest();
        investor = [SELECT SK_ACH_OTP__c, SK_ACH_OTP_Expiry__c FROM SK_ACH_Investor__c WHERE Id = :investor.Id];
        System.assertNotEquals(null, investor.SK_ACH_OTP__c, 'OTP should be set');
        System.assertNotEquals(null, investor.SK_ACH_OTP_Expiry__c, 'OTP expiry should be set');
    }
}
