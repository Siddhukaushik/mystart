/**
 * @description Test class for ACH_OTPService
 * Verifies OTP generation, assignment, expiry, and validation for LPs
 *
 * @author Apex Capital Hub Team
 * @date December 22, 2025
 */
@isTest
private class ACH_OTPServiceTest {
    @testSetup
    static void setupInvestor() {
        SK_ACH_Investor__c investor = new SK_ACH_Investor__c(
            Name = 'Test LP',
            SK_ACH_Investor_Type__c = 'Institutional'
        );
        insert investor;
    }

    @isTest
    static void testGenerateOTP_LengthAndFormat() {
        String otp = ACH_OTPService.generateOTP();
        System.assertEquals(6, otp.length(), 'OTP should be 6 digits');
        System.assert(Pattern.matches('\\d{6}', otp), 'OTP should be numeric');
    }

    @isTest
    static void testAssignOTPToInvestor_SetsFields() {
        SK_ACH_Investor__c investor = [SELECT Id FROM SK_ACH_Investor__c WHERE Name = 'Test LP' LIMIT 1];
        ACH_OTPService.assignOTPToInvestor(investor.Id);
        investor = [SELECT SK_ACH_OTP__c, SK_ACH_OTP_Expiry__c FROM SK_ACH_Investor__c WHERE Id = :investor.Id];
        System.assertNotEquals(null, investor.SK_ACH_OTP__c, 'OTP should be set');
        System.assertNotEquals(null, investor.SK_ACH_OTP_Expiry__c, 'OTP expiry should be set');
        System.assert(investor.SK_ACH_OTP_Expiry__c > System.now(), 'Expiry should be in the future');
    }

    @isTest
    static void testValidateOTP_SuccessAndInvalidation() {
        SK_ACH_Investor__c investor = [SELECT Id FROM SK_ACH_Investor__c WHERE Name = 'Test LP' LIMIT 1];
        ACH_OTPService.assignOTPToInvestor(investor.Id);
        investor = [SELECT SK_ACH_OTP__c FROM SK_ACH_Investor__c WHERE Id = :investor.Id];
        String otp = investor.SK_ACH_OTP__c;
        Boolean valid = ACH_OTPService.validateOTP(investor.Id, otp);
        System.assert(valid, 'OTP should validate successfully');
        investor = [SELECT SK_ACH_OTP__c, SK_ACH_OTP_Expiry__c FROM SK_ACH_Investor__c WHERE Id = :investor.Id];
        System.assertEquals(null, investor.SK_ACH_OTP__c, 'OTP should be cleared after use');
        System.assertEquals(null, investor.SK_ACH_OTP_Expiry__c, 'Expiry should be cleared after use');
    }

    @isTest
    static void testValidateOTP_FailsForWrongOrExpired() {
        SK_ACH_Investor__c investor = [SELECT Id FROM SK_ACH_Investor__c WHERE Name = 'Test LP' LIMIT 1];
        ACH_OTPService.assignOTPToInvestor(investor.Id);
        investor = [SELECT SK_ACH_OTP__c FROM SK_ACH_Investor__c WHERE Id = :investor.Id];
        // Wrong OTP
        Boolean validWrong = ACH_OTPService.validateOTP(investor.Id, '999999');
        System.assert(!validWrong, 'Should not validate with wrong OTP');
        // Expired OTP
        investor = [SELECT Id, SK_ACH_OTP__c FROM SK_ACH_Investor__c WHERE Id = :investor.Id];
        investor.SK_ACH_OTP_Expiry__c = System.now().addMinutes(-1);
        update investor;
        Boolean validExpired = ACH_OTPService.validateOTP(investor.Id, investor.SK_ACH_OTP__c);
        System.assert(!validExpired, 'Should not validate with expired OTP');
    }
}
