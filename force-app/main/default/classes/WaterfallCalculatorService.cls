public with sharing class WaterfallCalculatorService {

    /**
     * Calculates the distribution waterfall for a given Distribution record.
     * @param distributionId - The ID of the Distribution record.
     */
    public static void calculateWaterfall(Id distributionId) {
        // Step 1: Retrieve the Distribution and related Commitments
        SK_ACH_Distribution__c distribution = [
            SELECT Id, SK_ACH_Distribution_Total_Amount__c, SK_ACH_Fund__c
            FROM SK_ACH_Distribution__c
            WHERE Id = :distributionId
        ];

        List<SK_ACH_Commitment__c> commitments = [
            SELECT Id, SK_ACH_Investor__c, SK_ACH_Total_Called__c, SK_ACH_Total_Distributed__c
            FROM SK_ACH_Commitment__c
            WHERE SK_ACH_Fund__c = :distribution.SK_ACH_Fund__c
        ];

        Decimal totalDistribution = distribution.SK_ACH_Distribution_Total_Amount__c;
        List<SK_ACH_Distribution_Line__c> distributionLines = new List<SK_ACH_Distribution_Line__c>();

        // Step 2: Return of Capital
        for (SK_ACH_Commitment__c commitment : commitments) {
            Decimal returnOfCapital = Math.min(commitment.SK_ACH_Total_Called__c, totalDistribution);
            totalDistribution -= returnOfCapital;

            distributionLines.add(new SK_ACH_Distribution_Line__c(
                SK_ACH_Commitment__c = commitment.Id,
                SK_ACH_Distribution_Line_Amount__c = returnOfCapital
            ));
        }

        // Step 3: Preferred Return (Hurdle)
        if (totalDistribution > 0) {
            for (SK_ACH_Commitment__c commitment : commitments) {
                Decimal preferredReturn = Math.min(commitment.SK_ACH_Total_Called__c * 0.08, totalDistribution);
                totalDistribution -= preferredReturn;

                distributionLines.add(new SK_ACH_Distribution_Line__c(
                    SK_ACH_Commitment__c = commitment.Id,
                    SK_ACH_Distribution_Line_Amount__c = preferredReturn
                ));
            }
        }

        // Step 4: Catch-Up
        if (totalDistribution > 0) {
            for (SK_ACH_Commitment__c commitment : commitments) {
                Decimal catchUp = Math.min(commitment.SK_ACH_Total_Called__c * 0.2, totalDistribution);
                totalDistribution -= catchUp;

                distributionLines.add(new SK_ACH_Distribution_Line__c(
                    SK_ACH_Commitment__c = commitment.Id,
                    SK_ACH_Distribution_Line_Amount__c = catchUp
                ));
            }
        }

        // Step 5: Carried Interest
        if (totalDistribution > 0) {
            for (SK_ACH_Commitment__c commitment : commitments) {
                Decimal carriedInterest = totalDistribution * 0.2;
                totalDistribution -= carriedInterest;

                distributionLines.add(new SK_ACH_Distribution_Line__c(
                    SK_ACH_Commitment__c = commitment.Id,
                    SK_ACH_Distribution_Line_Amount__c = carriedInterest
                ));
            }
        }

        // Step 6: Insert Distribution Lines
        if (!distributionLines.isEmpty()) {
            insert distributionLines;
        }
    }
}