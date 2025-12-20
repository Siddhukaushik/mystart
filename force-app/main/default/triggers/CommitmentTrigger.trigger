/**
 * Trigger on Commitment to update Fund totals
 */
trigger CommitmentTrigger on SK_ACH_Commitment__c (after insert, after update, after delete, after undelete) {
    Set<Id> fundIds = new Set<Id>();
    
    if (Trigger.isDelete) {
        for (SK_ACH_Commitment__c commitment : Trigger.old) {
            if (commitment.SK_ACH_Fund__c != null) {
                fundIds.add(commitment.SK_ACH_Fund__c);
            }
        }
    } else {
        for (SK_ACH_Commitment__c commitment : Trigger.new) {
            if (commitment.SK_ACH_Fund__c != null) {
                fundIds.add(commitment.SK_ACH_Fund__c);
            }
        }
        
        // Handle fund change on update
        if (Trigger.isUpdate) {
            for (SK_ACH_Commitment__c commitment : Trigger.old) {
                if (commitment.SK_ACH_Fund__c != null && 
                    commitment.SK_ACH_Fund__c != Trigger.newMap.get(commitment.Id).SK_ACH_Fund__c) {
                    fundIds.add(commitment.SK_ACH_Fund__c);
                }
            }
        }
    }
    
    if (!fundIds.isEmpty()) {
        CommitmentTriggerHandler.updateFundTotals(fundIds);
    }
}
