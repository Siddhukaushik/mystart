@isTest
private class RaiseFundsControllerTest {
    
    @isTest
    static void testGetActiveFunds() {
        // Create test fund
        SK_ACH_Fund__c fund = new SK_ACH_Fund__c(
            Name = 'Test VC Fund',
            SK_ACH_Fund_Type__c = 'Venture Capital',
            SK_ACH_Status__c = 'Fundraising',
            SK_ACH_Target_Fund_Size__c = 100000000
        );
        insert fund;
        
        Test.startTest();
        List<SK_ACH_Fund__c> funds = RaiseFundsController.getActiveFunds();
        Test.stopTest();
        
        System.assertEquals(1, funds.size());
        System.assertEquals('Test VC Fund', funds[0].Name);
    }
    
    @isTest
    static void testGetActiveFundsEmpty() {
        Test.startTest();
        List<SK_ACH_Fund__c> funds = RaiseFundsController.getActiveFunds();
        Test.stopTest();
        
        System.assertEquals(0, funds.size());
    }
}