public with sharing class RaiseFundsController {
    
    @AuraEnabled(cacheable=true)
    public static List<SK_ACH_Fund__c> getActiveFunds() {
        return [
            SELECT Id, Name, SK_ACH_Fund_Type__c, SK_ACH_Target_Fund_Size__c
            FROM SK_ACH_Fund__c
            WHERE SK_ACH_Status__c = 'Fundraising'
            ORDER BY Name
            LIMIT 200
        ];
    }
}