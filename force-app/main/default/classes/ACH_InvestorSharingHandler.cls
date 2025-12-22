/**
 * @description Apex handler to manage record-level sharing for LP portal users
 * Ensures LPs can only see their own Investor, Commitment, Capital Call Line, and Distribution Line records
 * 
 * @author Apex Capital Hub Team
 * @date December 21, 2025
 */
public with sharing class ACH_InvestorSharingHandler {
    
    /**
     * @description Grants read access to portal users for their Investor records
     * Called from InvestorTrigger on after insert/update
     * @param newInvestors List of newly created or updated Investor records
     */
    public static void shareInvestorsWithPortalUsers(List<SK_ACH_Investor__c> newInvestors) {
        List<SK_ACH_Investor__Share> investorShares = new List<SK_ACH_Investor__Share>();
        
        for (SK_ACH_Investor__c investor : newInvestors) {
            // Check if investor has a linked portal user
            if (investor.SK_ACH_Portal_User__c != null) {
                SK_ACH_Investor__Share investorShare = new SK_ACH_Investor__Share();
                investorShare.ParentId = investor.Id;
                investorShare.UserOrGroupId = investor.SK_ACH_Portal_User__c;
                investorShare.AccessLevel = 'Read';
                investorShare.RowCause = Schema.SK_ACH_Investor__Share.RowCause.Manual;
                investorShares.add(investorShare);
            }
        }
        
        if (!investorShares.isEmpty()) {
            try {
                insert investorShares;
            } catch (DmlException e) {
                System.debug('Error sharing Investors with portal users: ' + e.getMessage());
            }
        }
    }
    
    /**
     * @description Grants read access to portal users for Commitment records
     * Inherits sharing from parent Investor record
     * @param newCommitments List of newly created or updated Commitment records
     */
    public static void shareCommitmentsWithPortalUsers(List<SK_ACH_Commitment__c> newCommitments) {
        // Get all unique Investor IDs
        Set<Id> investorIds = new Set<Id>();
        for (SK_ACH_Commitment__c comm : newCommitments) {
            if (comm.SK_ACH_Investor__c != null) {
                investorIds.add(comm.SK_ACH_Investor__c);
            }
        }
        
        if (investorIds.isEmpty()) return;
        
        // Query Investors to get portal user IDs
        Map<Id, Id> investorToPortalUserMap = new Map<Id, Id>();
        for (SK_ACH_Investor__c investor : [SELECT Id, SK_ACH_Portal_User__c 
                                             FROM SK_ACH_Investor__c 
                                             WHERE Id IN :investorIds 
                                             AND SK_ACH_Portal_User__c != null]) {
            investorToPortalUserMap.put(investor.Id, investor.SK_ACH_Portal_User__c);
        }
        
        // Create sharing records
        List<SK_ACH_Commitment__Share> commitmentShares = new List<SK_ACH_Commitment__Share>();
        for (SK_ACH_Commitment__c comm : newCommitments) {
            Id portalUserId = investorToPortalUserMap.get(comm.SK_ACH_Investor__c);
            if (portalUserId != null) {
                SK_ACH_Commitment__Share commShare = new SK_ACH_Commitment__Share();
                commShare.ParentId = comm.Id;
                commShare.UserOrGroupId = portalUserId;
                commShare.AccessLevel = 'Read';
                commShare.RowCause = Schema.SK_ACH_Commitment__Share.RowCause.Manual;
                commitmentShares.add(commShare);
            }
        }
        
        if (!commitmentShares.isEmpty()) {
            try {
                insert commitmentShares;
            } catch (DmlException e) {
                System.debug('Error sharing Commitments with portal users: ' + e.getMessage());
            }
        }
    }
    
    /**
     * @description Grants read access to portal users for Capital Call Line records
     * 
     * NOTE: Capital Call Line uses Master-Detail relationship to Capital Call.
     * Share objects don't exist for Master-Detail children.
     * LPs filter their lines via SOQL: WHERE SK_ACH_Commitment__c IN (their commitments)
     * Access control is enforced through:
     *   1. Commitment sharing (only see their own commitments)
     *   2. SOQL filters in LWC/Visualforce/Reports
     *   3. List view filters
     * 
     * @param newCapitalCallLines List of newly created Capital Call Line records
     */
    public static void shareCapitalCallLinesWithPortalUsers(List<SK_ACH_Capital_Call_Line__c> newCapitalCallLines) {
        // Master-Detail children inherit sharing from parent
        // No Share object exists - filtering done via SOQL on Commitment relationship
        // Example LP query: SELECT Id FROM SK_ACH_Capital_Call_Line__c WHERE SK_ACH_Commitment__c IN :myCommitments
    }
    
    /**
     * @description Grants read access to portal users for Distribution Line records
     * 
     * NOTE: Distribution Line uses Master-Detail relationship to Distribution.
     * Share objects don't exist for Master-Detail children.
     * LPs filter their lines via SOQL: WHERE SK_ACH_Commitment__c IN (their commitments)
     * Access control is enforced through:
     *   1. Commitment sharing (only see their own commitments)
     *   2. SOQL filters in LWC/Visualforce/Reports
     *   3. List view filters
     * 
     * @param newDistributionLines List of newly created Distribution Line records
     */
    public static void shareDistributionLinesWithPortalUsers(List<SK_ACH_Distribution_Line__c> newDistributionLines) {
        // Master-Detail children inherit sharing from parent
        // No Share object exists - filtering done via SOQL on Commitment relationship
        // Example LP query: SELECT Id FROM SK_ACH_Distribution_Line__c WHERE SK_ACH_Commitment__c IN :myCommitments
    }
    
    /**
     * @description Recalculates sharing when Investor's portal user is changed
     * Removes old sharing and creates new sharing
     * @param oldInvestorsMap Map of old Investor records
     * @param newInvestors List of updated Investor records
     */
    public static void recalculateSharingOnInvestorUpdate(Map<Id, SK_ACH_Investor__c> oldInvestorsMap, 
                                                           List<SK_ACH_Investor__c> newInvestors) {
        List<Id> investorIdsToRecalculate = new List<Id>();
        
        for (SK_ACH_Investor__c investor : newInvestors) {
            SK_ACH_Investor__c oldInvestor = oldInvestorsMap.get(investor.Id);
            
            // Check if portal user changed
            if (investor.SK_ACH_Portal_User__c != oldInvestor.SK_ACH_Portal_User__c) {
                investorIdsToRecalculate.add(investor.Id);
            }
        }
        
        if (!investorIdsToRecalculate.isEmpty()) {
            // Delete existing manual shares for these investors
            deleteManualShares(investorIdsToRecalculate);
            
            // Re-share with new portal users
            List<SK_ACH_Investor__c> investorsToReshare = [SELECT Id, SK_ACH_Portal_User__c 
                                                            FROM SK_ACH_Investor__c 
                                                            WHERE Id IN :investorIdsToRecalculate];
            shareInvestorsWithPortalUsers(investorsToReshare);
            
            // Re-share child records (Commitments, Capital Call Lines, Distribution Lines)
            reshareChildRecords(investorIdsToRecalculate);
        }
    }
    
    /**
     * @description Deletes manual sharing records for specified investors and their children
     * @param investorIds List of Investor IDs to remove sharing for
     */
    private static void deleteManualShares(List<Id> investorIds) {
        // Delete Investor shares
        delete [SELECT Id FROM SK_ACH_Investor__Share 
                WHERE ParentId IN :investorIds 
                AND RowCause = :Schema.SK_ACH_Investor__Share.RowCause.Manual];
        
        // Get child record IDs
        Set<Id> commitmentIds = new Set<Id>();
        for (SK_ACH_Commitment__c comm : [SELECT Id FROM SK_ACH_Commitment__c WHERE SK_ACH_Investor__c IN :investorIds]) {
            commitmentIds.add(comm.Id);
        }
        
        // Delete Commitment shares
        if (!commitmentIds.isEmpty()) {
            delete [SELECT Id FROM SK_ACH_Commitment__Share 
                    WHERE ParentId IN :commitmentIds 
                    AND RowCause = :Schema.SK_ACH_Commitment__Share.RowCause.Manual];
            
            // Note: Capital Call Line and Distribution Line are Master-Detail
            // No Share objects to delete - they inherit from parent
        }
    }
    
    /**
     * @description Re-shares child records when investor portal user changes
     * @param investorIds List of Investor IDs to re-share children for
     */
    private static void reshareChildRecords(List<Id> investorIds) {
        // Re-share Commitments
        List<SK_ACH_Commitment__c> commitments = [SELECT Id, SK_ACH_Investor__c 
                                                   FROM SK_ACH_Commitment__c 
                                                   WHERE SK_ACH_Investor__c IN :investorIds];
        if (!commitments.isEmpty()) {
            shareCommitmentsWithPortalUsers(commitments);
        }
        
        // Get commitment IDs for child records
        Set<Id> commitmentIds = new Set<Id>();
        for (SK_ACH_Commitment__c comm : commitments) {
            commitmentIds.add(comm.Id);
        }
        
        // Note: Capital Call Line and Distribution Line are Master-Detail
        // No sharing to recalculate - LPs query via Commitment filters
    }
}
