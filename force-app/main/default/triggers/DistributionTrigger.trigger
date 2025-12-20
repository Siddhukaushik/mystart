/**
 * Trigger on Distribution to update Fund and Investment totals
 */
trigger DistributionTrigger on SK_ACH_Distribution__c (after insert, after update, after delete, after undelete) {
    Set<Id> fundIds = new Set<Id>();
    Set<Id> investmentIds = new Set<Id>();
    
    if (Trigger.isDelete) {
        for (SK_ACH_Distribution__c dist : Trigger.old) {
            if (dist.SK_ACH_Fund__c != null) {
                fundIds.add(dist.SK_ACH_Fund__c);
            }
            if (dist.SK_ACH_Source_Investment__c != null) {
                investmentIds.add(dist.SK_ACH_Source_Investment__c);
            }
        }
    } else {
        for (SK_ACH_Distribution__c dist : Trigger.new) {
            if (dist.SK_ACH_Fund__c != null) {
                fundIds.add(dist.SK_ACH_Fund__c);
            }
            if (dist.SK_ACH_Source_Investment__c != null) {
                investmentIds.add(dist.SK_ACH_Source_Investment__c);
            }
        }
        
        // Handle lookup changes on update
        if (Trigger.isUpdate) {
            for (SK_ACH_Distribution__c dist : Trigger.old) {
                if (dist.SK_ACH_Fund__c != null && 
                    dist.SK_ACH_Fund__c != Trigger.newMap.get(dist.Id).SK_ACH_Fund__c) {
                    fundIds.add(dist.SK_ACH_Fund__c);
                }
                if (dist.SK_ACH_Source_Investment__c != null && 
                    dist.SK_ACH_Source_Investment__c != Trigger.newMap.get(dist.Id).SK_ACH_Source_Investment__c) {
                    investmentIds.add(dist.SK_ACH_Source_Investment__c);
                }
            }
        }
    }
    
    if (!fundIds.isEmpty()) {
        DistributionTriggerHandler.updateFundTotals(fundIds);
    }
    
    if (!investmentIds.isEmpty()) {
        DistributionTriggerHandler.updateInvestmentTotals(investmentIds);
    }
}
