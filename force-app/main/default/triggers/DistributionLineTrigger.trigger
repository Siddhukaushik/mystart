/**
 * Trigger on Distribution Line to update Commitment totals
 */
trigger DistributionLineTrigger on SK_ACH_Distribution_Line__c (after insert, after update, after delete, after undelete) {
    Set<Id> commitmentIds = new Set<Id>();
    
    if (Trigger.isDelete) {
        for (SK_ACH_Distribution_Line__c line : Trigger.old) {
            if (line.SK_ACH_Commitment__c != null) {
                commitmentIds.add(line.SK_ACH_Commitment__c);
            }
        }
    } else {
        for (SK_ACH_Distribution_Line__c line : Trigger.new) {
            if (line.SK_ACH_Commitment__c != null) {
                commitmentIds.add(line.SK_ACH_Commitment__c);
            }
        }
        
        // Handle commitment change on update
        if (Trigger.isUpdate) {
            for (SK_ACH_Distribution_Line__c line : Trigger.old) {
                if (line.SK_ACH_Commitment__c != null && 
                    line.SK_ACH_Commitment__c != Trigger.newMap.get(line.Id).SK_ACH_Commitment__c) {
                    commitmentIds.add(line.SK_ACH_Commitment__c);
                }
            }
        }
    }
    
    if (!commitmentIds.isEmpty()) {
        DistributionLineTriggerHandler.updateCommitmentTotals(commitmentIds);
    }
}
