@isTest
private class WaterfallCalculatorServiceTest {

    @isTest
    static void testCalculateWaterfall() {
        // Step 1: Create test data
        SK_ACH_Fund__c fund = new SK_ACH_Fund__c(Name = 'Test Fund');
        insert fund;

        SK_ACH_Commitment__c commitment1 = new SK_ACH_Commitment__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Commitment_Amount__c = 1000000,
            SK_ACH_Total_Called__c = 500000,
            SK_ACH_Total_Distributed__c = 0
        );
        SK_ACH_Commitment__c commitment2 = new SK_ACH_Commitment__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Commitment_Amount__c = 1000000,
            SK_ACH_Total_Called__c = 500000,
            SK_ACH_Total_Distributed__c = 0
        );
        insert new List<SK_ACH_Commitment__c>{commitment1, commitment2};

        SK_ACH_Distribution__c distribution = new SK_ACH_Distribution__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Distribution_Total_Amount__c = 1000000
        );
        insert distribution;

        // Step 2: Call the service
        Test.startTest();
        WaterfallCalculatorService.calculateWaterfall(distribution.Id);
        Test.stopTest();

        // Step 3: Verify results
        List<SK_ACH_Distribution_Line__c> lines = [
            SELECT SK_ACH_Commitment__c, SK_ACH_Distribution_Line_Amount__c
            FROM SK_ACH_Distribution_Line__c
        ];
        System.assertEquals(4, lines.size(), 'Four Distribution Lines should be created.');
        System.assertEquals(500000, lines[0].SK_ACH_Distribution_Line_Amount__c, 'First Commitment Return of Capital should be 500,000.');
        System.assertEquals(500000, lines[1].SK_ACH_Distribution_Line_Amount__c, 'Second Commitment Return of Capital should be 500,000.');
    }
}