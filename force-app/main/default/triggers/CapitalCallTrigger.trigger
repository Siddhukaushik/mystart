/**
 * Trigger on Capital Call to update Fund totals
 */
trigger CapitalCallTrigger on SK_ACH_Capital_Call__c (after insert, after update, after delete, after undelete) {
    Set<Id> fundIds = new Set<Id>();
    
    if (Trigger.isDelete) {
        for (SK_ACH_Capital_Call__c call : Trigger.old) {
            if (call.SK_ACH_Fund__c != null) {
                fundIds.add(call.SK_ACH_Fund__c);
            }
        }
    } else {
        for (SK_ACH_Capital_Call__c call : Trigger.new) {
            if (call.SK_ACH_Fund__c != null) {
                fundIds.add(call.SK_ACH_Fund__c);
            }
        }
        
        // Handle fund change on update
        if (Trigger.isUpdate) {
            for (SK_ACH_Capital_Call__c call : Trigger.old) {
                if (call.SK_ACH_Fund__c != null && 
                    call.SK_ACH_Fund__c != Trigger.newMap.get(call.Id).SK_ACH_Fund__c) {
                    fundIds.add(call.SK_ACH_Fund__c);
                }
            }
        }
    }
    
    if (!fundIds.isEmpty()) {
        CapitalCallTriggerHandler.updateFundTotals(fundIds);
    }
}
