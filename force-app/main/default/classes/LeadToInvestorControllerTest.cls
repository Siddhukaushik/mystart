@isTest
private class LeadToInvestorControllerTest {
    
    @isTest
    static void testConvertQualifiedLead() {
        // Create test Lead
        Lead testLead = new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Company = 'Doe Investments LLC',
            Email = 'john.doe@example.com',
            Phone = '555-1234',
            Status = 'Working - Contacted',
            Description = 'High net worth individual'
        );
        insert testLead;
        
        Test.startTest();
        LeadToInvestorController.ConversionResult result = 
            LeadToInvestorController.convertLeadToInvestor(testLead.Id);
        Test.stopTest();
        
        // Verify Investor was created
        System.assertNotEquals(null, result.investorId);
        System.assertEquals(true, result.success);
        
        SK_ACH_Investor__c investor = [
            SELECT Id, Name, SK_ACH_Email__c, SK_ACH_Phone__c, SK_ACH_Investor_Status__c
            FROM SK_ACH_Investor__c 
            WHERE Id = :result.investorId
        ];
        
        System.assertEquals('Doe Investments LLC', investor.Name);
        System.assertEquals('john.doe@example.com', investor.SK_ACH_Email__c);
        System.assertEquals('Active', investor.SK_ACH_Investor_Status__c);
        
        // Verify Lead status was updated
        Lead updatedLead = [SELECT Status FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Converted', updatedLead.Status);
    }
    
    @isTest
    static void testConvertUnqualifiedLead() {
        // Create test Lead that is not qualified
        Lead testLead = new Lead(
            FirstName = 'Jane',
            LastName = 'Smith',
            Company = 'Smith Capital',
            Email = 'jane.smith@example.com',
            Status = 'Open - Not Contacted'
        );
        insert testLead;
        
        Test.startTest();
        try {
            LeadToInvestorController.convertLeadToInvestor(testLead.Id);
            System.assert(false, 'Expected exception was not thrown');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Working - Contacted'));
        }
        Test.stopTest();
    }
    
    @isTest
    static void testConvertLeadWithMinimalData() {
        // Create test Lead with minimal data
        Lead testLead = new Lead(
            LastName = 'Minimal',
            Company = 'Minimal Inc',
            Status = 'Working - Contacted'
        );
        insert testLead;
        
        Test.startTest();
        LeadToInvestorController.ConversionResult result = 
            LeadToInvestorController.convertLeadToInvestor(testLead.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, result.investorId);
        System.assertEquals(true, result.success);
    }
}