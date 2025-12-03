public with sharing class MyProfilePageController {
    public MyProfilePageController() {
    }
    
    public User getCurrentUser() {
        return [SELECT Id, Name, Email FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    }
}
