public with sharing class CapitalCallService {

    /**
     * Invocable method to generate Capital Call Lines
     * @param fundId - The ID of the Fund
     * @param capitalCallAmount - The total Capital Call Amount
     */
    @InvocableMethod
    public static void generateCapitalCallLines(List<CapitalCallInput> inputs) {
        for (CapitalCallInput input : inputs) {
            generateCapitalCall(input.fundId, input.capitalCallAmount);
        }
    }

    /**
     * Core logic to generate Capital Call Lines
     * @param fundId - The ID of the Fund
     * @param capitalCallAmount - The total Capital Call Amount
     */
    private static void generateCapitalCall(Id fundId, Decimal capitalCallAmount) {
        // Step 1: Retrieve Commitments for the Fund
        List<SK_ACH_Commitment__c> commitments = [
            SELECT Id, SK_ACH_Investor__c, SK_ACH_Unfunded_Balance__c, SK_ACH_Total_Called__c, SK_ACH_Commitment_Amount__c
            FROM SK_ACH_Commitment__c
            WHERE SK_ACH_Fund__c = :fundId AND SK_ACH_Unfunded_Balance__c > 0
        ];

        // Check if commitments exist
        if (commitments.isEmpty()) {
            throw new CapitalCallException('No commitments found with unfunded balance for this fund.');
        }

        // Step 2: Calculate total unfunded balance
        Decimal totalUnfunded = 0;
        for (SK_ACH_Commitment__c commitment : commitments) {
            totalUnfunded += commitment.SK_ACH_Unfunded_Balance__c;
        }

        // Check for division by zero
        if (totalUnfunded == 0) {
            throw new CapitalCallException('Total unfunded balance is zero.');
        }

        // Create a Capital Call record first
        SK_ACH_Capital_Call__c capitalCall = new SK_ACH_Capital_Call__c(
            SK_ACH_Fund__c = fundId,
            SK_ACH_Call_Date__c = Date.today(),
            SK_ACH_Due_Date__c = Date.today().addDays(30),
            SK_ACH_Total_Amount__c = capitalCallAmount,
            SK_ACH_Purpose__c = 'Investment',
            SK_ACH_Capital_Call_Status__c = 'Draft'
        );
        insert capitalCall;

        // Step 3: Create Capital Call Lines
        List<SK_ACH_Capital_Call_Line__c> capitalCallLines = new List<SK_ACH_Capital_Call_Line__c>();
        for (SK_ACH_Commitment__c commitment : commitments) {
            Decimal proRataShare = (commitment.SK_ACH_Unfunded_Balance__c / totalUnfunded) * capitalCallAmount;

            // Create Capital Call Line
            SK_ACH_Capital_Call_Line__c line = new SK_ACH_Capital_Call_Line__c(
                SK_ACH_Capital_Call__c = capitalCall.Id,
                SK_ACH_Commitment__c = commitment.Id,
                SK_ACH_Line_Amount__c = proRataShare,
                SK_ACH_Line_Status__c = 'Pending'
            );
            capitalCallLines.add(line);

            // Update Commitment Total Called
            commitment.SK_ACH_Total_Called__c = (commitment.SK_ACH_Total_Called__c != null ? commitment.SK_ACH_Total_Called__c : 0) + proRataShare;
        }

        // Step 4: Insert Capital Call Lines and update Commitments
        if (!capitalCallLines.isEmpty()) {
            insert capitalCallLines;
            update commitments;
        }
    }

    // Custom exception class
    public class CapitalCallException extends Exception {}


    /**
     * Input class for Invocable Method
     */
    public class CapitalCallInput {
        @InvocableVariable(required=true)
        public Id fundId;

        @InvocableVariable(required=true)
        public Decimal capitalCallAmount;
    }
}