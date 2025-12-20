/**
 * Trigger Handler for Capital Call Line to calculate Commitment aggregations
 */
public with sharing class CapitalCallLineTriggerHandler {
    
    public static void updateCommitmentTotals(Set<Id> commitmentIds) {
        Map<Id, Decimal> commitmentCalledTotals = new Map<Id, Decimal>();
        Map<Id, Decimal> commitmentPaidTotals = new Map<Id, Decimal>();
        
        // Aggregate by Commitment
        for (AggregateResult ar : [
            SELECT SK_ACH_Commitment__c commitmentId, 
                   SUM(SK_ACH_Line_Amount__c) totalCalled,
                   SUM(SK_ACH_Amount_Paid__c) totalPaid
            FROM SK_ACH_Capital_Call_Line__c
            WHERE SK_ACH_Commitment__c IN :commitmentIds
            GROUP BY SK_ACH_Commitment__c
        ]) {
            Id commitmentId = (Id)ar.get('commitmentId');
            commitmentCalledTotals.put(commitmentId, (Decimal)ar.get('totalCalled'));
            commitmentPaidTotals.put(commitmentId, (Decimal)ar.get('totalPaid'));
        }
        
        // Update Commitment records
        List<SK_ACH_Commitment__c> commitmentsToUpdate = new List<SK_ACH_Commitment__c>();
        for (Id commitmentId : commitmentIds) {
            commitmentsToUpdate.add(new SK_ACH_Commitment__c(
                Id = commitmentId,
                SK_ACH_Total_Called__c = commitmentCalledTotals.containsKey(commitmentId) ? 
                    commitmentCalledTotals.get(commitmentId) : 0,
                SK_ACH_Total_Paid__c = commitmentPaidTotals.containsKey(commitmentId) ? 
                    commitmentPaidTotals.get(commitmentId) : 0
            ));
        }
        
        if (!commitmentsToUpdate.isEmpty()) {
            update commitmentsToUpdate;
        }
    }
}
