/**
 * @description Helper class for LPs to query their own Capital Call Lines and Distribution Lines
 * Since these are Master-Detail children, filtering is done via SOQL on Commitment relationship
 * 
 * @author Apex Capital Hub Team
 * @date December 21, 2025
 */
public with sharing class ACH_LPDataAccess {
    
    /**
     * @description Get all Capital Call Lines for the current LP user
     * Filters based on commitments linked to user's investor record
     * @return List of Capital Call Lines for this LP only
     */
    public static List<SK_ACH_Capital_Call_Line__c> getMyCapitalCallLines() {
        // Get commitments for current user's investor
        Set<Id> myCommitmentIds = getMyCommitmentIds();
        
        if (myCommitmentIds.isEmpty()) {
            return new List<SK_ACH_Capital_Call_Line__c>();
        }
        
        return [SELECT Id, Name, 
                       SK_ACH_Capital_Call__c, 
                       SK_ACH_Capital_Call__r.Name,
                       SK_ACH_Commitment__c,
                       SK_ACH_Commitment__r.Name,
                       SK_ACH_Line_Amount__c,
                       SK_ACH_Amount_Paid__c,
                       SK_ACH_Amount_Outstanding__c,
                       SK_ACH_Line_Status__c,
                       SK_ACH_Payment_Date__c,
                       SK_ACH_Payment_Method__c
                FROM SK_ACH_Capital_Call_Line__c
                WHERE SK_ACH_Commitment__c IN :myCommitmentIds
                ORDER BY SK_ACH_Capital_Call__r.SK_ACH_Call_Date__c DESC];
    }
    
    /**
     * @description Get all Distribution Lines for the current LP user
     * Filters based on commitments linked to user's investor record
     * @return List of Distribution Lines for this LP only
     */
    public static List<SK_ACH_Distribution_Line__c> getMyDistributionLines() {
        // Get commitments for current user's investor
        Set<Id> myCommitmentIds = getMyCommitmentIds();
        
        if (myCommitmentIds.isEmpty()) {
            return new List<SK_ACH_Distribution_Line__c>();
        }
        
        return [SELECT Id, Name,
                       SK_ACH_Distribution__c,
                       SK_ACH_Distribution__r.Name,
                       SK_ACH_Commitment__c,
                       SK_ACH_Commitment__r.Name,
                       SK_ACH_Distribution_Line_Amount__c,
                       SK_ACH_Distribution_Line_Status__c,
                       SK_ACH_Line_Payment_Date__c,
                       SK_ACH_Line_Payment_Method__c,
                       SK_ACH_Line_Return_of_Capital__c,
                       SK_ACH_Line_Preferred_Return__c,
                       SK_ACH_Line_Profit_Distribution__c
                FROM SK_ACH_Distribution_Line__c
                WHERE SK_ACH_Commitment__c IN :myCommitmentIds
                ORDER BY SK_ACH_Distribution__r.SK_ACH_Distribution_Date__c DESC];
    }
    
    /**
     * @description Get commitment IDs for the current user's investor record
     * Uses the SK_ACH_Portal_User__c field to link User to Investor
     * @return Set of Commitment IDs this user can access
     */
    private static Set<Id> getMyCommitmentIds() {
        Set<Id> commitmentIds = new Set<Id>();
        Id currentUserId = UserInfo.getUserId();
        
        // Find investor linked to this portal user
        List<SK_ACH_Investor__c> myInvestors = [SELECT Id 
                                                 FROM SK_ACH_Investor__c 
                                                 WHERE SK_ACH_Portal_User__c = :currentUserId
                                                 LIMIT 1];
        
        if (myInvestors.isEmpty()) {
            return commitmentIds;
        }
        
        // Get all commitments for this investor
        for (SK_ACH_Commitment__c comm : [SELECT Id 
                                           FROM SK_ACH_Commitment__c 
                                           WHERE SK_ACH_Investor__c = :myInvestors[0].Id]) {
            commitmentIds.add(comm.Id);
        }
        
        return commitmentIds;
    }
    
    /**
     * @description Get total outstanding capital calls for current LP
     * @return Sum of all outstanding amounts
     */
    public static Decimal getMyTotalOutstanding() {
        Set<Id> myCommitmentIds = getMyCommitmentIds();
        
        if (myCommitmentIds.isEmpty()) {
            return 0;
        }
        
        AggregateResult[] results = [SELECT SUM(SK_ACH_Amount_Outstanding__c) total
                                     FROM SK_ACH_Capital_Call_Line__c
                                     WHERE SK_ACH_Commitment__c IN :myCommitmentIds
                                     AND SK_ACH_Line_Status__c = 'Pending'];
        
        return results[0].get('total') != null ? (Decimal)results[0].get('total') : 0;
    }
    
    /**
     * @description Get total distributions received by current LP
     * @return Sum of all paid distribution amounts
     */
    public static Decimal getMyTotalDistributions() {
        Set<Id> myCommitmentIds = getMyCommitmentIds();
        
        if (myCommitmentIds.isEmpty()) {
            return 0;
        }
        
        AggregateResult[] results = [SELECT SUM(SK_ACH_Distribution_Line_Amount__c) total
                                     FROM SK_ACH_Distribution_Line__c
                                     WHERE SK_ACH_Commitment__c IN :myCommitmentIds
                                     AND SK_ACH_Distribution_Line_Status__c = 'Paid'];
        
        return results[0].get('total') != null ? (Decimal)results[0].get('total') : 0;
    }
}
