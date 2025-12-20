/**
 * Trigger Handler for Distribution Line to calculate Commitment aggregations
 */
public with sharing class DistributionLineTriggerHandler {
    
    public static void updateCommitmentTotals(Set<Id> commitmentIds) {
        Map<Id, Decimal> commitmentDistributedTotals = new Map<Id, Decimal>();
        
        // Aggregate distribution line amounts by Commitment
        for (AggregateResult ar : [
            SELECT SK_ACH_Commitment__c commitmentId, SUM(SK_ACH_Distribution_Line_Amount__c) total
            FROM SK_ACH_Distribution_Line__c
            WHERE SK_ACH_Commitment__c IN :commitmentIds
            GROUP BY SK_ACH_Commitment__c
        ]) {
            commitmentDistributedTotals.put((Id)ar.get('commitmentId'), (Decimal)ar.get('total'));
        }
        
        // Update Commitment records
        List<SK_ACH_Commitment__c> commitmentsToUpdate = new List<SK_ACH_Commitment__c>();
        for (Id commitmentId : commitmentIds) {
            commitmentsToUpdate.add(new SK_ACH_Commitment__c(
                Id = commitmentId,
                SK_ACH_Total_Distributed__c = commitmentDistributedTotals.containsKey(commitmentId) ? 
                    commitmentDistributedTotals.get(commitmentId) : 0
            ));
        }
        
        if (!commitmentsToUpdate.isEmpty()) {
            update commitmentsToUpdate;
        }
    }
}
