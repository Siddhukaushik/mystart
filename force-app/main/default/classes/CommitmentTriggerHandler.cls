/**
 * Trigger Handler for Commitment object to calculate Fund aggregations
 */
public with sharing class CommitmentTriggerHandler {
    
    public static void updateFundTotals(Set<Id> fundIds) {
        Map<Id, Decimal> fundCommitmentTotals = new Map<Id, Decimal>();
        
        // Aggregate commitment amounts by Fund
        for (AggregateResult ar : [
            SELECT SK_ACH_Fund__c fundId, SUM(SK_ACH_Commitment_Amount__c) total
            FROM SK_ACH_Commitment__c
            WHERE SK_ACH_Fund__c IN :fundIds
            GROUP BY SK_ACH_Fund__c
        ]) {
            fundCommitmentTotals.put((Id)ar.get('fundId'), (Decimal)ar.get('total'));
        }
        
        // Update Fund records
        List<SK_ACH_Fund__c> fundsToUpdate = new List<SK_ACH_Fund__c>();
        for (Id fundId : fundIds) {
            fundsToUpdate.add(new SK_ACH_Fund__c(
                Id = fundId,
                SK_ACH_Total_Commitments__c = fundCommitmentTotals.containsKey(fundId) ? 
                    fundCommitmentTotals.get(fundId) : 0
            ));
        }
        
        if (!fundsToUpdate.isEmpty()) {
            update fundsToUpdate;
        }
    }
}
