/**
 * @description Test class for ACH_LPDataAccess
 * Verifies that LPs can only query their own Capital Call Lines and Distribution Lines
 * 
 * @author Apex Capital Hub Team
 * @date December 21, 2025
 */
@isTest
private class ACH_LPDataAccessTest {
    
    @testSetup
    static void setupTestData() {
        // Create test fund
        SK_ACH_Fund__c fund = new SK_ACH_Fund__c(
            Name = 'Test Growth Fund',
            SK_ACH_Vintage_Year__c = 2024,
            SK_ACH_Fund_Type__c = 'Growth Equity',
            SK_ACH_Status__c = 'Active',
            SK_ACH_Target_Fund_Size__c = 50000000
        );
        insert fund;
        
        // Create two investors (LP-A and LP-B)
        Id currentUserId = UserInfo.getUserId();
        
        SK_ACH_Investor__c investorA = new SK_ACH_Investor__c(
            Name = 'LP-A Pension Fund',
            SK_ACH_Investor_Type__c = 'Institutional',
            SK_ACH_Portal_User__c = currentUserId // Link to current test user
        );
        
        SK_ACH_Investor__c investorB = new SK_ACH_Investor__c(
            Name = 'LP-B Family Office',
            SK_ACH_Investor_Type__c = 'Individual'
            // No portal user link - represents different LP
        );
        
        insert new List<SK_ACH_Investor__c>{investorA, investorB};
        
        // Create commitments for both investors
        SK_ACH_Commitment__c commitmentA = new SK_ACH_Commitment__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Investor__c = investorA.Id,
            SK_ACH_Commitment_Amount__c = 5000000,
            SK_ACH_Commitment_Date__c = Date.today()
        );
        
        SK_ACH_Commitment__c commitmentB = new SK_ACH_Commitment__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Investor__c = investorB.Id,
            SK_ACH_Commitment_Amount__c = 3000000,
            SK_ACH_Commitment_Date__c = Date.today()
        );
        
        insert new List<SK_ACH_Commitment__c>{commitmentA, commitmentB};
        
        // Create capital calls
        SK_ACH_Capital_Call__c capitalCall = new SK_ACH_Capital_Call__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Call_Date__c = Date.today(),
            SK_ACH_Due_Date__c = Date.today().addDays(30),
            SK_ACH_Total_Amount__c = 2000000
        );
        insert capitalCall;
        
        // Create capital call lines for both LPs
        SK_ACH_Capital_Call_Line__c lineA = new SK_ACH_Capital_Call_Line__c(
            SK_ACH_Capital_Call__c = capitalCall.Id,
            SK_ACH_Commitment__c = commitmentA.Id,
            SK_ACH_Line_Amount__c = 1000000,
            SK_ACH_Amount_Paid__c = 600000,
            SK_ACH_Line_Status__c = 'Pending'
        );
        
        SK_ACH_Capital_Call_Line__c lineB = new SK_ACH_Capital_Call_Line__c(
            SK_ACH_Capital_Call__c = capitalCall.Id,
            SK_ACH_Commitment__c = commitmentB.Id,
            SK_ACH_Line_Amount__c = 600000,
            SK_ACH_Amount_Paid__c = 600000,
            SK_ACH_Line_Status__c = 'Paid'
        );
        
        insert new List<SK_ACH_Capital_Call_Line__c>{lineA, lineB};
        
        // Create distribution
        SK_ACH_Distribution__c distribution = new SK_ACH_Distribution__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Distribution_Date__c = Date.today(),
            SK_ACH_Distribution_Total_Amount__c = 500000
        );
        insert distribution;
        
        // Create distribution lines for both LPs
        SK_ACH_Distribution_Line__c distLineA = new SK_ACH_Distribution_Line__c(
            SK_ACH_Distribution__c = distribution.Id,
            SK_ACH_Commitment__c = commitmentA.Id,
            SK_ACH_Distribution_Line_Amount__c = 300000,
            SK_ACH_Distribution_Line_Status__c = 'Paid'
        );
        
        SK_ACH_Distribution_Line__c distLineB = new SK_ACH_Distribution_Line__c(
            SK_ACH_Distribution__c = distribution.Id,
            SK_ACH_Commitment__c = commitmentB.Id,
            SK_ACH_Distribution_Line_Amount__c = 200000,
            SK_ACH_Distribution_Line_Status__c = 'Paid'
        );
        
        insert new List<SK_ACH_Distribution_Line__c>{distLineA, distLineB};
    }
    
    @isTest
    static void testGetMyCapitalCallLines_ReturnsOnlyMyLines() {
        Test.startTest();
        
        // Query as LP-A (current user has portal user link to Investor A)
        List<SK_ACH_Capital_Call_Line__c> myLines = ACH_LPDataAccess.getMyCapitalCallLines();
        
        Test.stopTest();
        
        // Should return only 1 line (LP-A's line)
        System.assertEquals(1, myLines.size(), 'Should return only one capital call line for LP-A');
        System.assertEquals(1000000, myLines[0].SK_ACH_Line_Amount__c, 'Should be LP-A line with $1M');
        System.assertEquals('Pending', myLines[0].SK_ACH_Line_Status__c, 'Status should be Pending');
    }
    
    @isTest
    static void testGetMyDistributionLines_ReturnsOnlyMyLines() {
        Test.startTest();
        
        // Query as LP-A (current user has portal user link to Investor A)
        List<SK_ACH_Distribution_Line__c> myLines = ACH_LPDataAccess.getMyDistributionLines();
        
        Test.stopTest();
        
        // Should return only 1 line (LP-A's line)
        System.assertEquals(1, myLines.size(), 'Should return only one distribution line for LP-A');
        System.assertEquals(300000, myLines[0].SK_ACH_Distribution_Line_Amount__c, 'Should be LP-A line with $300K');
        System.assertEquals('Paid', myLines[0].SK_ACH_Distribution_Line_Status__c, 'Status should be Paid');
    }
    
    @isTest
    static void testGetMyTotalOutstanding_CalculatesCorrectly() {
        Test.startTest();
        
        // Query as LP-A
        Decimal totalOutstanding = ACH_LPDataAccess.getMyTotalOutstanding();
        
        Test.stopTest();
        
        // LP-A has $1M line with $600K paid = $400K outstanding (status = Pending)
        System.assertEquals(400000, totalOutstanding, 'Total outstanding should be $400K for LP-A');
    }
    
    @isTest
    static void testGetMyTotalDistributions_CalculatesCorrectly() {
        Test.startTest();
        
        // Query as LP-A
        Decimal totalDistributions = ACH_LPDataAccess.getMyTotalDistributions();
        
        Test.stopTest();
        
        // LP-A has $300K in paid distributions
        System.assertEquals(300000, totalDistributions, 'Total distributions should be $300K for LP-A');
    }
    
    @isTest
    static void testGetMyCapitalCallLines_NoInvestorLinked() {
        // Delete the portal user link to simulate user with no investor
        SK_ACH_Investor__c investorA = [SELECT Id, SK_ACH_Portal_User__c 
                                         FROM SK_ACH_Investor__c 
                                         WHERE Name = 'LP-A Pension Fund' 
                                         LIMIT 1];
        investorA.SK_ACH_Portal_User__c = null;
        update investorA;
        
        Test.startTest();
        
        // Query should return empty list
        List<SK_ACH_Capital_Call_Line__c> myLines = ACH_LPDataAccess.getMyCapitalCallLines();
        
        Test.stopTest();
        
        System.assertEquals(0, myLines.size(), 'Should return empty list when no investor is linked');
    }
    
    @isTest
    static void testGetMyDistributionLines_NoInvestorLinked() {
        // Delete the portal user link
        SK_ACH_Investor__c investorA = [SELECT Id, SK_ACH_Portal_User__c 
                                         FROM SK_ACH_Investor__c 
                                         WHERE Name = 'LP-A Pension Fund' 
                                         LIMIT 1];
        investorA.SK_ACH_Portal_User__c = null;
        update investorA;
        
        Test.startTest();
        
        // Query should return empty list
        List<SK_ACH_Distribution_Line__c> myLines = ACH_LPDataAccess.getMyDistributionLines();
        
        Test.stopTest();
        
        System.assertEquals(0, myLines.size(), 'Should return empty list when no investor is linked');
    }
    
    @isTest
    static void testGetMyTotalOutstanding_NoCommitments() {
        // Delete the portal user link
        SK_ACH_Investor__c investorA = [SELECT Id FROM SK_ACH_Investor__c WHERE Name = 'LP-A Pension Fund' LIMIT 1];
        investorA.SK_ACH_Portal_User__c = null;
        update investorA;
        
        Test.startTest();
        
        Decimal totalOutstanding = ACH_LPDataAccess.getMyTotalOutstanding();
        
        Test.stopTest();
        
        System.assertEquals(0, totalOutstanding, 'Should return 0 when no commitments');
    }
    
    @isTest
    static void testGetMyTotalDistributions_NoCommitments() {
        // Delete the portal user link
        SK_ACH_Investor__c investorA = [SELECT Id FROM SK_ACH_Investor__c WHERE Name = 'LP-A Pension Fund' LIMIT 1];
        investorA.SK_ACH_Portal_User__c = null;
        update investorA;
        
        Test.startTest();
        
        Decimal totalDistributions = ACH_LPDataAccess.getMyTotalDistributions();
        
        Test.stopTest();
        
        System.assertEquals(0, totalDistributions, 'Should return 0 when no commitments');
    }
    
    @isTest
    static void testDataIsolation_LPCannotSeeLPBData() {
        // This test verifies LP-A cannot see LP-B's data
        
        Test.startTest();
        
        // Query as LP-A
        List<SK_ACH_Capital_Call_Line__c> myLines = ACH_LPDataAccess.getMyCapitalCallLines();
        
        Test.stopTest();
        
        // Verify none of the returned lines belong to LP-B
        for (SK_ACH_Capital_Call_Line__c line : myLines) {
            SK_ACH_Commitment__c commitment = [SELECT SK_ACH_Investor__r.Name 
                                                FROM SK_ACH_Commitment__c 
                                                WHERE Id = :line.SK_ACH_Commitment__c];
            System.assertNotEquals('LP-B Family Office', commitment.SK_ACH_Investor__r.Name, 
                                   'LP-A should not see LP-B data');
        }
    }
    
    @isTest
    static void testBulkQuery_MultipleCommitments() {
        // Add second commitment for LP-A
        SK_ACH_Fund__c fund = [SELECT Id FROM SK_ACH_Fund__c LIMIT 1];
        SK_ACH_Investor__c investorA = [SELECT Id FROM SK_ACH_Investor__c WHERE Name = 'LP-A Pension Fund' LIMIT 1];
        
        SK_ACH_Commitment__c commitment2 = new SK_ACH_Commitment__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Investor__c = investorA.Id,
            SK_ACH_Commitment_Amount__c = 2000000,
            SK_ACH_Commitment_Date__c = Date.today()
        );
        insert commitment2;
        
        // Create capital call
        SK_ACH_Capital_Call__c capitalCall2 = new SK_ACH_Capital_Call__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Call_Date__c = Date.today(),
            SK_ACH_Due_Date__c = Date.today().addDays(30),
            SK_ACH_Total_Amount__c = 500000
        );
        insert capitalCall2;
        
        // Create line for second commitment
        SK_ACH_Capital_Call_Line__c line2 = new SK_ACH_Capital_Call_Line__c(
            SK_ACH_Capital_Call__c = capitalCall2.Id,
            SK_ACH_Commitment__c = commitment2.Id,
            SK_ACH_Line_Amount__c = 500000,
            SK_ACH_Line_Status__c = 'Pending'
        );
        insert line2;
        
        Test.startTest();
        
        // Query should return both lines for LP-A
        List<SK_ACH_Capital_Call_Line__c> myLines = ACH_LPDataAccess.getMyCapitalCallLines();
        
        Test.stopTest();
        
        System.assertEquals(2, myLines.size(), 'Should return 2 lines for LP-A with multiple commitments');
    }
}
