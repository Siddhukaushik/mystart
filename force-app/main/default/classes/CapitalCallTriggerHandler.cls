/**
 * Trigger Handler for Capital Call to calculate Fund aggregations
 */
public with sharing class CapitalCallTriggerHandler {
    
    public static void updateFundTotals(Set<Id> fundIds) {
        Map<Id, Decimal> fundCalledCapitalTotals = new Map<Id, Decimal>();
        
        // Aggregate capital call amounts by Fund
        for (AggregateResult ar : [
            SELECT SK_ACH_Fund__c fundId, SUM(SK_ACH_Total_Amount__c) total
            FROM SK_ACH_Capital_Call__c
            WHERE SK_ACH_Fund__c IN :fundIds
            GROUP BY SK_ACH_Fund__c
        ]) {
            fundCalledCapitalTotals.put((Id)ar.get('fundId'), (Decimal)ar.get('total'));
        }
        
        // Update Fund records
        List<SK_ACH_Fund__c> fundsToUpdate = new List<SK_ACH_Fund__c>();
        for (Id fundId : fundIds) {
            fundsToUpdate.add(new SK_ACH_Fund__c(
                Id = fundId,
                SK_ACH_Total_Called_Capital__c = fundCalledCapitalTotals.containsKey(fundId) ? 
                    fundCalledCapitalTotals.get(fundId) : 0
            ));
        }
        
        if (!fundsToUpdate.isEmpty()) {
            update fundsToUpdate;
        }
    }
}
