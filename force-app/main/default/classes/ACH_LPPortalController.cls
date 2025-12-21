/**
 * @description Controller for LP Portal Lightning Web Components
 * Exposes ACH_LPDataAccess methods to LWC with proper error handling
 * 
 * @author Apex Capital Hub Team
 * @date December 21, 2025
 */
public with sharing class ACH_LPPortalController {
    
    /**
     * @description Get Capital Call Lines for current LP user
     * @return List of Capital Call Lines with related data
     */
    @AuraEnabled(cacheable=true)
    public static List<SK_ACH_Capital_Call_Line__c> getCapitalCallLines() {
        try {
            return ACH_LPDataAccess.getMyCapitalCallLines();
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving capital call lines: ' + e.getMessage());
        }
    }
    
    /**
     * @description Get Distribution Lines for current LP user
     * @return List of Distribution Lines with related data
     */
    @AuraEnabled(cacheable=true)
    public static List<SK_ACH_Distribution_Line__c> getDistributionLines() {
        try {
            return ACH_LPDataAccess.getMyDistributionLines();
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving distribution lines: ' + e.getMessage());
        }
    }
    
    /**
     * @description Get financial summary for current LP
     * @return Map with total outstanding and total distributions
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Decimal> getFinancialSummary() {
        try {
            Map<String, Decimal> summary = new Map<String, Decimal>();
            summary.put('totalOutstanding', ACH_LPDataAccess.getMyTotalOutstanding());
            summary.put('totalDistributions', ACH_LPDataAccess.getMyTotalDistributions());
            
            // Calculate net cash flow (distributions - outstanding)
            Decimal netCashFlow = summary.get('totalDistributions') - summary.get('totalOutstanding');
            summary.put('netCashFlow', netCashFlow);
            
            return summary;
        } catch (Exception e) {
            throw new AuraHandledException('Error calculating financial summary: ' + e.getMessage());
        }
    }
    
    /**
     * @description Get investor details for current LP user
     * @return Investor record with commitment information
     */
    @AuraEnabled(cacheable=true)
    public static InvestorWrapper getInvestorDetails() {
        try {
            Id currentUserId = UserInfo.getUserId();
            
            List<SK_ACH_Investor__c> investors = [
                SELECT Id, Name, 
                       SK_ACH_Investor_Type__c,
                       SK_ACH_Email__c,
                       SK_ACH_Phone__c,
                       (SELECT Id, SK_ACH_Fund__r.Name, 
                               SK_ACH_Commitment_Amount__c,
                               SK_ACH_Total_Called__c,
                               SK_ACH_Total_Paid__c,
                               SK_ACH_Total_Distributed__c,
                               SK_ACH_Unfunded_Balance__c
                        FROM Commitments__r)
                FROM SK_ACH_Investor__c 
                WHERE SK_ACH_Portal_User__c = :currentUserId
                LIMIT 1
            ];
            
            if (investors.isEmpty()) {
                return null;
            }
            
            InvestorWrapper wrapper = new InvestorWrapper();
            wrapper.investor = investors[0];
            wrapper.commitments = investors[0].Commitments__r;
            
            return wrapper;
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving investor details: ' + e.getMessage());
        }
    }
    
    /**
     * Wrapper class for investor data
     */
    public class InvestorWrapper {
        @AuraEnabled public SK_ACH_Investor__c investor { get; set; }
        @AuraEnabled public List<SK_ACH_Commitment__c> commitments { get; set; }
    }
}
