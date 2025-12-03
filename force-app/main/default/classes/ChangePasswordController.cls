public with sharing class ChangePasswordController {
    public String oldPassword { get; set; }
    public String newPassword { get; set; }
    public String confirmPassword { get; set; }
    public String message { get; set; }

    public ChangePasswordController() {
    }

    public PageReference changePassword() {
        // Minimal stub: implement password change logic in real controller
        return null;
    }
}
