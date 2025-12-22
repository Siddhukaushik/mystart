@isTest
private class CapitalCallServiceTest {

    @isTest
    static void testGenerateCapitalCallLines() {
        // Step 1: Create test data
        SK_ACH_Fund__c fund = new SK_ACH_Fund__c(Name = 'Test Fund');
        insert fund;

        SK_ACH_Commitment__c commitment1 = new SK_ACH_Commitment__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Commitment_Amount__c = 1000000,
            SK_ACH_Total_Called__c = 500000
        );
        SK_ACH_Commitment__c commitment2 = new SK_ACH_Commitment__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Commitment_Amount__c = 1000000,
            SK_ACH_Total_Called__c = 500000
        );
        insert new List<SK_ACH_Commitment__c>{commitment1, commitment2};

        // Step 2: Call the service
        CapitalCallService.CapitalCallInput input = new CapitalCallService.CapitalCallInput();
        input.fundId = fund.Id;
        input.capitalCallAmount = 1000000;

        Test.startTest();
        CapitalCallService.generateCapitalCallLines(new List<CapitalCallService.CapitalCallInput>{input});
        Test.stopTest();

        // Step 3: Verify results
        List<SK_ACH_Capital_Call_Line__c> lines = [
            SELECT SK_ACH_Commitment__c, SK_ACH_Line_Amount__c
            FROM SK_ACH_Capital_Call_Line__c
        ];
        System.assertEquals(2, lines.size(), 'Two Capital Call Lines should be created.');
        System.assertEquals(500000, lines[0].SK_ACH_Line_Amount__c, 'Pro-rata share should be 500,000.');
        System.assertEquals(500000, lines[1].SK_ACH_Line_Amount__c, 'Pro-rata share should be 500,000.');

        List<SK_ACH_Commitment__c> updatedCommitments = [
            SELECT SK_ACH_Unfunded_Balance__c, SK_ACH_Total_Called__c
            FROM SK_ACH_Commitment__c
        ];
        System.assertEquals(0, updatedCommitments[0].SK_ACH_Unfunded_Balance__c, 'Unfunded balance should be 0 (formula calculated).');
        System.assertEquals(1000000, updatedCommitments[0].SK_ACH_Total_Called__c, 'Total Called should be updated to 1,000,000.');
    }
}