public with sharing class MyProfilePageController {
    public Boolean isEdit { get; set; }

    public MyProfilePageController() {
        this.isEdit = false;
    }

    public User getCurrentUser() {
        return [SELECT Id, Name, Email FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    }

    public PageReference toggleEdit() {
        this.isEdit = !this.isEdit;
        return null;
    }

    // Method referenced by Visualforce page to save profile changes
    public PageReference save() {
        // Minimal stub: implement save logic in real controller
        return null;
    }
}
