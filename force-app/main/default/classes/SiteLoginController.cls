public with sharing class SiteLoginController {
    // Properties referenced by Visualforce pages/components
    public String username { get; set; }
    public String password { get; set; }
    public String errorMessage { get; set; }

    public SiteLoginController() {
    }

    public PageReference login() {
        // Minimal stub: real logic should authenticate the user
        return null;
    }

    public PageReference logout() {
        // Minimal stub: real logic should clear session and redirect
        return null;
    }
}