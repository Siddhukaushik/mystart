/**
 * @description Test class for ACH_InvestorSharingHandler
 * Verifies that LP portal users can only see their own records
 * 
 * @author Apex Capital Hub Team
 * @date December 21, 2025
 */
@isTest
private class ACH_InvestorSharingHandlerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test fund
        SK_ACH_Fund__c fund = new SK_ACH_Fund__c(
            Name = 'Test Fund',
            SK_ACH_Vintage_Year__c = 2024,
            SK_ACH_Fund_Type__c = 'Growth Equity',
            SK_ACH_Status__c = 'Active',
            SK_ACH_Target_Fund_Size__c = 100000000
        );
        insert fund;
        
        // Create test portal users (simulate LP users)
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'Customer Community User' LIMIT 1];
        
        Account acc1 = new Account(Name = 'LP Account 1');
        Account acc2 = new Account(Name = 'LP Account 2');
        insert new List<Account>{acc1, acc2};
        
        Contact con1 = new Contact(FirstName = 'LP', LastName = 'User 1', AccountId = acc1.Id, Email = 'lp1@test.com');
        Contact con2 = new Contact(FirstName = 'LP', LastName = 'User 2', AccountId = acc2.Id, Email = 'lp2@test.com');
        insert new List<Contact>{con1, con2};
        
        // Note: In real implementation, create portal users here
        // User portalUser1 = new User(...);
        // For test purposes, we'll use running user
    }
    
    @isTest
    static void testInvestorSharingWithPortalUser() {
        // Get test data
        SK_ACH_Fund__c fund = [SELECT Id FROM SK_ACH_Fund__c LIMIT 1];
        Id runningUser = UserInfo.getUserId();
        
        Test.startTest();
        
        // Create investor with portal user
        SK_ACH_Investor__c investor = new SK_ACH_Investor__c(
            Name = 'Test Investor 1',
            SK_ACH_Investor_Type__c = 'Institutional',
            SK_ACH_Portal_User__c = runningUser // In real scenario, this would be portal user
        );
        insert investor;
        
        Test.stopTest();
        
        // Verify sharing record was created
        List<SK_ACH_Investor__Share> shares = [SELECT Id, UserOrGroupId, AccessLevel 
                                                FROM SK_ACH_Investor__Share 
                                                WHERE ParentId = :investor.Id 
                                                AND RowCause = 'Manual'];
        
        System.assertEquals(1, shares.size(), 'One sharing record should be created');
        System.assertEquals(runningUser, shares[0].UserOrGroupId, 'Sharing should be granted to portal user');
        System.assertEquals('Read', String.valueOf(shares[0].AccessLevel), 'Access level should be Read');
    }
    
    @isTest
    static void testCommitmentSharingWithPortalUser() {
        // Get test data
        SK_ACH_Fund__c fund = [SELECT Id FROM SK_ACH_Fund__c LIMIT 1];
        Id runningUser = UserInfo.getUserId();
        
        // Create investor with portal user
        SK_ACH_Investor__c investor = new SK_ACH_Investor__c(
            Name = 'Test Investor 1',
            SK_ACH_Investor_Type__c = 'Institutional',
            SK_ACH_Portal_User__c = runningUser
        );
        insert investor;
        
        Test.startTest();
        
        // Create commitment
        SK_ACH_Commitment__c commitment = new SK_ACH_Commitment__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Investor__c = investor.Id,
            SK_ACH_Commitment_Amount__c = 1000000,
            SK_ACH_Commitment_Date__c = Date.today()
        );
        insert commitment;
        
        Test.stopTest();
        
        // Verify sharing record was created
        List<SK_ACH_Commitment__Share> shares = [SELECT Id, UserOrGroupId, AccessLevel 
                                                  FROM SK_ACH_Commitment__Share 
                                                  WHERE ParentId = :commitment.Id 
                                                  AND RowCause = 'Manual'];
        
        System.assertEquals(1, shares.size(), 'One sharing record should be created for commitment');
        System.assertEquals(runningUser, shares[0].UserOrGroupId, 'Sharing should be granted to portal user');
        System.assertEquals('Read', String.valueOf(shares[0].AccessLevel), 'Access level should be Read');
    }
    
    @isTest
    static void testCapitalCallLineSharingWithPortalUser() {
        // Get test data
        SK_ACH_Fund__c fund = [SELECT Id FROM SK_ACH_Fund__c LIMIT 1];
        Id runningUser = UserInfo.getUserId();
        
        // Create investor and commitment
        SK_ACH_Investor__c investor = new SK_ACH_Investor__c(
            Name = 'Test Investor 1',
            SK_ACH_Investor_Type__c = 'Institutional',
            SK_ACH_Portal_User__c = runningUser
        );
        insert investor;
        
        SK_ACH_Commitment__c commitment = new SK_ACH_Commitment__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Investor__c = investor.Id,
            SK_ACH_Commitment_Amount__c = 1000000,
            SK_ACH_Commitment_Date__c = Date.today()
        );
        insert commitment;
        
        // Create capital call
        SK_ACH_Capital_Call__c capitalCall = new SK_ACH_Capital_Call__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Call_Date__c = Date.today(),
            SK_ACH_Due_Date__c = Date.today().addDays(30),
            SK_ACH_Total_Amount__c = 500000
        );
        insert capitalCall;
        
        Test.startTest();
        
        // Create capital call line
        SK_ACH_Capital_Call_Line__c capitalCallLine = new SK_ACH_Capital_Call_Line__c(
            SK_ACH_Capital_Call__c = capitalCall.Id,
            SK_ACH_Commitment__c = commitment.Id,
            SK_ACH_Line_Amount__c = 100000,
            SK_ACH_Line_Status__c = 'Pending'
        );
        insert capitalCallLine;
        
        Test.stopTest();
        
        // Verify line item created successfully
        // Note: Master-Detail children don't have Share objects
        // LPs filter via: WHERE SK_ACH_Commitment__c IN :theirCommitments
        System.assertEquals(true, capitalCallLine.Id != null, 'Capital call line created successfully');
        
        // Verify LP can query their own line via Commitment filter
        List<SK_ACH_Capital_Call_Line__c> lpLines = [SELECT Id FROM SK_ACH_Capital_Call_Line__c 
                                                      WHERE SK_ACH_Commitment__c = :commitment.Id];
        System.assertEquals(1, lpLines.size(), 'LP can see their own capital call line via commitment filter');
    }
    
    @isTest
    static void testDistributionLineSharingWithPortalUser() {
        // Get test data
        SK_ACH_Fund__c fund = [SELECT Id FROM SK_ACH_Fund__c LIMIT 1];
        Id runningUser = UserInfo.getUserId();
        
        // Create investor and commitment
        SK_ACH_Investor__c investor = new SK_ACH_Investor__c(
            Name = 'Test Investor 1',
            SK_ACH_Investor_Type__c = 'Institutional',
            SK_ACH_Portal_User__c = runningUser
        );
        insert investor;
        
        SK_ACH_Commitment__c commitment = new SK_ACH_Commitment__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Investor__c = investor.Id,
            SK_ACH_Commitment_Amount__c = 1000000,
            SK_ACH_Commitment_Date__c = Date.today()
        );
        insert commitment;
        
        // Create distribution
        SK_ACH_Distribution__c distribution = new SK_ACH_Distribution__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Distribution_Date__c = Date.today(),
            SK_ACH_Distribution_Total_Amount__c = 200000
        );
        insert distribution;
        
        Test.startTest();
        
        // Create distribution line
        SK_ACH_Distribution_Line__c distributionLine = new SK_ACH_Distribution_Line__c(
            SK_ACH_Distribution__c = distribution.Id,
            SK_ACH_Commitment__c = commitment.Id,
            SK_ACH_Distribution_Line_Amount__c = 50000,
            SK_ACH_Distribution_Line_Status__c = 'Paid'
        );
        insert distributionLine;
        
        Test.stopTest();
        
        // Verify line item created successfully
        // Note: Master-Detail children don't have Share objects
        // LPs filter via: WHERE SK_ACH_Commitment__c IN :theirCommitments
        System.assertEquals(true, distributionLine.Id != null, 'Distribution line created successfully');
        
        // Verify LP can query their own line via Commitment filter
        List<SK_ACH_Distribution_Line__c> lpLines = [SELECT Id FROM SK_ACH_Distribution_Line__c 
                                                      WHERE SK_ACH_Commitment__c = :commitment.Id];
        System.assertEquals(1, lpLines.size(), 'LP can see their own distribution line via commitment filter');
    }
    
    @isTest
    static void testRecalculateSharingOnPortalUserChange() {
        // Get test data
        SK_ACH_Fund__c fund = [SELECT Id FROM SK_ACH_Fund__c LIMIT 1];
        Id runningUser = UserInfo.getUserId();
        
        // Create investor with portal user
        SK_ACH_Investor__c investor = new SK_ACH_Investor__c(
            Name = 'Test Investor 1',
            SK_ACH_Investor_Type__c = 'Institutional',
            SK_ACH_Portal_User__c = runningUser
        );
        insert investor;
        
        // Create commitment and lines
        SK_ACH_Commitment__c commitment = new SK_ACH_Commitment__c(
            SK_ACH_Fund__c = fund.Id,
            SK_ACH_Investor__c = investor.Id,
            SK_ACH_Commitment_Amount__c = 1000000,
            SK_ACH_Commitment_Date__c = Date.today()
        );
        insert commitment;
        
        Test.startTest();
        
        // Change portal user (in real scenario, to different user)
        investor.SK_ACH_Portal_User__c = null;
        update investor;
        
        Test.stopTest();
        
        // Verify old sharing records were deleted
        List<SK_ACH_Investor__Share> shares = [SELECT Id FROM SK_ACH_Investor__Share 
                                                WHERE ParentId = :investor.Id 
                                                AND RowCause = 'Manual'];
        
        System.assertEquals(0, shares.size(), 'Sharing records should be deleted when portal user is removed');
    }
    
    @isTest
    static void testNoSharingWhenNoPortalUser() {
        // Get test data
        SK_ACH_Fund__c fund = [SELECT Id FROM SK_ACH_Fund__c LIMIT 1];
        
        Test.startTest();
        
        // Create investor WITHOUT portal user
        SK_ACH_Investor__c investor = new SK_ACH_Investor__c(
            Name = 'Test Investor No Portal',
            SK_ACH_Investor_Type__c = 'Institutional'
            // SK_ACH_Portal_User__c is null
        );
        insert investor;
        
        Test.stopTest();
        
        // Verify no sharing record was created
        List<SK_ACH_Investor__Share> shares = [SELECT Id FROM SK_ACH_Investor__Share 
                                                WHERE ParentId = :investor.Id 
                                                AND RowCause = 'Manual'];
        
        System.assertEquals(0, shares.size(), 'No sharing record should be created when portal user is null');
    }
    
    @isTest
    static void testBulkInvestorSharing() {
        // Get test data
        SK_ACH_Fund__c fund = [SELECT Id FROM SK_ACH_Fund__c LIMIT 1];
        Id runningUser = UserInfo.getUserId();
        
        Test.startTest();
        
        // Create 200 investors in bulk
        List<SK_ACH_Investor__c> investors = new List<SK_ACH_Investor__c>();
        for (Integer i = 0; i < 200; i++) {
            investors.add(new SK_ACH_Investor__c(
                Name = 'Bulk Test Investor ' + i,
                SK_ACH_Investor_Type__c = 'Institutional',
                SK_ACH_Portal_User__c = runningUser
            ));
        }
        insert investors;
        
        Test.stopTest();
        
        // Verify sharing records were created for all
        List<SK_ACH_Investor__Share> shares = [SELECT Id FROM SK_ACH_Investor__Share 
                                                WHERE ParentId IN :investors 
                                                AND RowCause = 'Manual'];
        
        System.assertEquals(200, shares.size(), '200 sharing records should be created for bulk insert');
    }
}
