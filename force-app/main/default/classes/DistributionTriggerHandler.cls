/**
 * Trigger Handler for Distribution to calculate Fund aggregations
 */
public with sharing class DistributionTriggerHandler {
    
    public static void updateFundTotals(Set<Id> fundIds) {
        Map<Id, Decimal> fundDistributionTotals = new Map<Id, Decimal>();
        
        // Aggregate distribution amounts by Fund
        for (AggregateResult ar : [
            SELECT SK_ACH_Fund__c fundId, SUM(SK_ACH_Distribution_Total_Amount__c) total
            FROM SK_ACH_Distribution__c
            WHERE SK_ACH_Fund__c IN :fundIds
            GROUP BY SK_ACH_Fund__c
        ]) {
            fundDistributionTotals.put((Id)ar.get('fundId'), (Decimal)ar.get('total'));
        }
        
        // Update Fund records
        List<SK_ACH_Fund__c> fundsToUpdate = new List<SK_ACH_Fund__c>();
        for (Id fundId : fundIds) {
            fundsToUpdate.add(new SK_ACH_Fund__c(
                Id = fundId,
                SK_ACH_Total_Distributions__c = fundDistributionTotals.containsKey(fundId) ? 
                    fundDistributionTotals.get(fundId) : 0
            ));
        }
        
        if (!fundsToUpdate.isEmpty()) {
            update fundsToUpdate;
        }
    }
    
    public static void updateInvestmentTotals(Set<Id> investmentIds) {
        Map<Id, Decimal> investmentDistributionTotals = new Map<Id, Decimal>();
        
        // Aggregate distribution amounts by Investment
        for (AggregateResult ar : [
            SELECT SK_ACH_Source_Investment__c investmentId, SUM(SK_ACH_Distribution_Total_Amount__c) total
            FROM SK_ACH_Distribution__c
            WHERE SK_ACH_Source_Investment__c IN :investmentIds
            GROUP BY SK_ACH_Source_Investment__c
        ]) {
            investmentDistributionTotals.put((Id)ar.get('investmentId'), (Decimal)ar.get('total'));
        }
        
        // Update Investment records
        List<SK_ACH_Investment__c> investmentsToUpdate = new List<SK_ACH_Investment__c>();
        for (Id investmentId : investmentIds) {
            investmentsToUpdate.add(new SK_ACH_Investment__c(
                Id = investmentId,
                SK_ACH_Total_Distributions_Received__c = investmentDistributionTotals.containsKey(investmentId) ? 
                    investmentDistributionTotals.get(investmentId) : 0
            ));
        }
        
        if (!investmentsToUpdate.isEmpty()) {
            update investmentsToUpdate;
        }
    }
}
