public with sharing class CommunitiesLoginController {
    public String username { get; set; }
    public String password { get; set; }

    public CommunitiesLoginController() {
    }

    public PageReference login() {
        return null;
    }

    // Method referenced by pages
    public PageReference forwardToAuthPage() {
        return null;
    }
}