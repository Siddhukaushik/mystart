public with sharing class ACH_OTPValidate {
    public class ValidateOTPRequest {
        @InvocableVariable(label='Investor Id' required=true)
        public Id investorId;
        @InvocableVariable(label='OTP' required=true)
        public String otp;
    }

    @InvocableMethod(label='Validate Investor OTP')
    public static List<Boolean> validateInvestorOTP(List<ValidateOTPRequest> requests) {
        List<Boolean> results = new List<Boolean>();
        for (ValidateOTPRequest req : requests) {
            results.add(ACH_OTPService.validateOTP(req.investorId, req.otp));
        }
        return results;
    }
}
