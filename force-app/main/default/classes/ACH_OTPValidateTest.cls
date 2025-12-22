/**
 * @description Test class for ACH_OTPValidate
 * Covers invocable method for OTP validation
 *
 * @author Apex Capital Hub Team
 * @date December 22, 2025
 */
@isTest
private class ACH_OTPValidateTest {
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
    static void testValidateInvestorOTP() {
        SK_ACH_Investor__c investor = [SELECT Id FROM SK_ACH_Investor__c WHERE Name = 'Flow LP' LIMIT 1];
        ACH_OTPService.assignOTPToInvestor(investor.Id);
        investor = [SELECT SK_ACH_OTP__c FROM SK_ACH_Investor__c WHERE Id = :investor.Id];
        ACH_OTPValidate.ValidateOTPRequest req = new ACH_OTPValidate.ValidateOTPRequest();
        req.investorId = investor.Id;
        req.otp = investor.SK_ACH_OTP__c;
        List<ACH_OTPValidate.ValidateOTPRequest> reqs = new List<ACH_OTPValidate.ValidateOTPRequest>{req};
        List<Boolean> results = ACH_OTPValidate.validateInvestorOTP(reqs);
        System.assertEquals(1, results.size(), 'Should return one result');
        System.assert(results[0], 'OTP should validate successfully');
    }
}
