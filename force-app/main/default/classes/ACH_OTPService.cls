public with sharing class ACH_OTPService {
    // Generate a 6-digit OTP
    public static String generateOTP() {
        Integer otp = Math.mod(Math.abs(Crypto.getRandomInteger()), 1000000);
        return String.valueOf(otp).leftPad(6, '0');
    }

    // Store OTP for a given LP (Investor) record
    public static void assignOTPToInvestor(Id investorId) {
        String otp = generateOTP();
        // Assuming SK_ACH_Investor__c has a custom field SK_ACH_OTP__c
        SK_ACH_Investor__c investor = [SELECT Id FROM SK_ACH_Investor__c WHERE Id = :investorId LIMIT 1];
        investor.SK_ACH_OTP__c = otp;
        investor.SK_ACH_OTP_Expiry__c = System.now().addMinutes(10); // Add expiry field
        update investor;
        // Optionally, send OTP via email/SMS here
    }

    // Validate OTP for a given LP (Investor) record
    public static Boolean validateOTP(Id investorId, String otp) {
        SK_ACH_Investor__c investor = [SELECT SK_ACH_OTP__c, SK_ACH_OTP_Expiry__c FROM SK_ACH_Investor__c WHERE Id = :investorId LIMIT 1];
        if (investor.SK_ACH_OTP__c == otp && investor.SK_ACH_OTP_Expiry__c > System.now()) {
            // Invalidate OTP after use
            investor.SK_ACH_OTP__c = null;
            investor.SK_ACH_OTP_Expiry__c = null;
            update investor;
            return true;
        }
        return false;
    }
}