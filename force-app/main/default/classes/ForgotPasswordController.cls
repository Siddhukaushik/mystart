public with sharing class ForgotPasswordController {
    public String username { get; set; }
    public String message { get; set; }

    public ForgotPasswordController() {
    }

    public PageReference sendReset() {
        // Minimal stub: implement password reset flow in real controller
        return null;
    }
}
