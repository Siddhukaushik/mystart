public with sharing class LeadToInvestorController {
    
    @AuraEnabled
    public static ConversionResult convertLeadToInvestor(Id leadId) {
        try {
            // Get Lead details
            Lead lead = [
                SELECT Id, Name, Company, Email, Phone, Status, Description
                FROM Lead 
                WHERE Id = :leadId 
                LIMIT 1
            ];
            
            // Verify lead is contacted
            if (lead.Status != 'Working - Contacted') {
                throw new AuraHandledException('Lead must be in "Working - Contacted" status before conversion.');
            }
            
            // Create new Investor record
            SK_ACH_Investor__c investor = new SK_ACH_Investor__c();
            investor.Name = lead.Company != null ? lead.Company : lead.Name;
            investor.SK_ACH_Email__c = lead.Email;
            investor.SK_ACH_Phone__c = lead.Phone;
            investor.SK_ACH_Investor_Type__c = 'Individual'; // Default type
            investor.SK_ACH_Investor_Status__c = 'Active';
            
            // Add notes about source
            if (lead.Description != null) {
                investor.SK_ACH_Notes__c = 'Converted from Lead: ' + lead.Name + '\n\n' + lead.Description;
            } else {
                investor.SK_ACH_Notes__c = 'Converted from Lead: ' + lead.Name;
            }
            
            insert investor;
            
            // Update Lead status
            lead.Status = 'Converted';
            update lead;
            
            // Create relationship between Lead and Investor (if custom field exists)
            // This could be done with a custom field on Lead to track the converted Investor
            
            // Return result
            ConversionResult result = new ConversionResult();
            result.investorId = investor.Id;
            result.investorName = investor.Name;
            result.success = true;
            
            return result;
            
        } catch (Exception e) {
            throw new AuraHandledException('Error converting lead: ' + e.getMessage());
        }
    }
    
    public class ConversionResult {
        @AuraEnabled public Id investorId;
        @AuraEnabled public String investorName;
        @AuraEnabled public Boolean success;
    }
}