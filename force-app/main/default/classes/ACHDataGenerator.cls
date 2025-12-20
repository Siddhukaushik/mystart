/**
 * Data Generator for Apex Capital Hub
 * Generates test data across all 9 objects
 */
public class ACHDataGenerator {
    
    public static void generateTestData(Integer numFunds) {
        System.debug('Starting data generation for ' + numFunds + ' funds...');
        
        // Generate Funds
        List<SK_ACH_Fund__c> funds = createFunds(numFunds);
        insert funds;
        System.debug('Created ' + funds.size() + ' Funds');
        
        // Generate Investors (10 per fund)
        List<SK_ACH_Investor__c> investors = createInvestors(numFunds * 10);
        insert investors;
        System.debug('Created ' + investors.size() + ' Investors');
        
        // Generate Commitments (5 per fund)
        List<SK_ACH_Commitment__c> commitments = createCommitments(funds, investors, 5);
        insert commitments;
        System.debug('Created ' + commitments.size() + ' Commitments');
        
        // Generate Capital Calls (3 per fund)
        List<SK_ACH_Capital_Call__c> capitalCalls = createCapitalCalls(funds, 3);
        insert capitalCalls;
        System.debug('Created ' + capitalCalls.size() + ' Capital Calls');
        
        // Generate Capital Call Lines (1 per commitment per call)
        List<SK_ACH_Capital_Call_Line__c> callLines = createCapitalCallLines(capitalCalls, commitments);
        insert callLines;
        System.debug('Created ' + callLines.size() + ' Capital Call Lines');
        
        // Generate Investments (10 per fund)
        List<SK_ACH_Investment__c> investments = createInvestments(funds, 10);
        insert investments;
        System.debug('Created ' + investments.size() + ' Investments');
        
        // Generate Valuations (2 per investment)
        List<SK_ACH_Valuation__c> valuations = createValuations(investments, 2);
        insert valuations;
        System.debug('Created ' + valuations.size() + ' Valuations');
        
        // Generate Distributions (2 per fund)
        List<SK_ACH_Distribution__c> distributions = createDistributions(funds, investments, 2);
        insert distributions;
        System.debug('Created ' + distributions.size() + ' Distributions');
        
        // Generate Distribution Lines (1 per commitment per distribution)
        List<SK_ACH_Distribution_Line__c> distLines = createDistributionLines(distributions, commitments);
        insert distLines;
        System.debug('Created ' + distLines.size() + ' Distribution Lines');
        
        System.debug('Data generation complete!');
    }
    
    private static List<SK_ACH_Fund__c> createFunds(Integer count) {
        List<SK_ACH_Fund__c> funds = new List<SK_ACH_Fund__c>();
        List<String> fundTypes = new List<String>{'Venture Capital', 'Growth Equity', 'Buyout', 'Real Estate'};
        List<String> statuses = new List<String>{'Fundraising', 'Active', 'Harvesting'};
        
        for (Integer i = 0; i < count; i++) {
            funds.add(new SK_ACH_Fund__c(
                SK_ACH_Fund_Type__c = fundTypes[Math.mod(i, fundTypes.size())],
                SK_ACH_Status__c = statuses[Math.mod(i, statuses.size())],
                SK_ACH_Vintage_Year__c = 2020 + Math.mod(i, 5),
                SK_ACH_Target_Fund_Size__c = 100000000 + (i * 10000000),
                SK_ACH_Management_Fee_Percent__c = 2.0,
                SK_ACH_Carried_Interest_Percent__c = 20.0,
                SK_ACH_Hurdle_Rate_Percent__c = 8.0,
                SK_ACH_Fund_Domicile__c = 'Delaware',
                SK_ACH_General_Partner__c = 'GP Partners LLC',
                SK_ACH_Final_Liquidation_Date__c = Date.today().addYears(8)
            ));
        }
        return funds;
    }
    
    private static List<SK_ACH_Investor__c> createInvestors(Integer count) {
        List<SK_ACH_Investor__c> investors = new List<SK_ACH_Investor__c>();
        List<String> types = new List<String>{'Pension Fund', 'Family Office', 'Individual', 'Fund of Funds', 'Endowment', 'Corporate'};
        List<String> entityTypes = new List<String>{'Corporation', 'LLC', 'Partnership', 'Trust'};
        
        for (Integer i = 0; i < count; i++) {
            investors.add(new SK_ACH_Investor__c(
                SK_ACH_Investor_Type__c = types[Math.mod(i, types.size())],
                SK_ACH_Legal_Entity_Type__c = entityTypes[Math.mod(i, entityTypes.size())],
                SK_ACH_Investor_Status__c = 'Active',
                SK_ACH_Tax_Status__c = 'Tax-Exempt',
                SK_ACH_Accreditation_Status__c = 'Accredited',
                SK_ACH_Country__c = 'United States',
                SK_ACH_Primary_Contact_Name__c = 'Contact ' + i,
                SK_ACH_Email__c = 'investor' + i + '@test.com'
            ));
        }
        return investors;
    }
    
    private static List<SK_ACH_Commitment__c> createCommitments(
        List<SK_ACH_Fund__c> funds, 
        List<SK_ACH_Investor__c> investors, 
        Integer perFund
    ) {
        List<SK_ACH_Commitment__c> commitments = new List<SK_ACH_Commitment__c>();
        Integer investorIndex = 0;
        
        for (SK_ACH_Fund__c fund : funds) {
            for (Integer i = 0; i < perFund; i++) {
                commitments.add(new SK_ACH_Commitment__c(
                    SK_ACH_Fund__c = fund.Id,
                    SK_ACH_Investor__c = investors[Math.mod(investorIndex++, investors.size())].Id,
                    SK_ACH_Commitment_Amount__c = 1000000 + (i * 500000),
                    SK_ACH_Commitment_Status__c = 'Executed',
                    SK_ACH_Commitment_Type__c = 'Initial',
                    SK_ACH_Commitment_Date__c = Date.today().addMonths(-6),
                    SK_ACH_Subscription_Agreement_Signed__c = true,
                    SK_ACH_Signature_Date__c = Date.today().addMonths(-6)
                ));
            }
        }
        return commitments;
    }
    
    private static List<SK_ACH_Capital_Call__c> createCapitalCalls(
        List<SK_ACH_Fund__c> funds, 
        Integer perFund
    ) {
        List<SK_ACH_Capital_Call__c> calls = new List<SK_ACH_Capital_Call__c>();
        
        for (SK_ACH_Fund__c fund : funds) {
            for (Integer i = 0; i < perFund; i++) {
                calls.add(new SK_ACH_Capital_Call__c(
                    SK_ACH_Fund__c = fund.Id,
                    SK_ACH_Call_Date__c = Date.today().addMonths(-3 + i),
                    SK_ACH_Due_Date__c = Date.today().addMonths(-3 + i).addDays(30),
                    SK_ACH_Total_Amount__c = 5000000 + (i * 1000000),
                    SK_ACH_Capital_Call_Status__c = i == 0 ? 'Fully Paid' : 'Partially Paid',
                    SK_ACH_Purpose__c = 'Investment',
                    SK_ACH_Notice_Sent_Date__c = Date.today().addMonths(-3 + i).addDays(-5)
                ));
            }
        }
        return calls;
    }
    
    private static List<SK_ACH_Capital_Call_Line__c> createCapitalCallLines(
        List<SK_ACH_Capital_Call__c> calls,
        List<SK_ACH_Commitment__c> commitments
    ) {
        List<SK_ACH_Capital_Call_Line__c> lines = new List<SK_ACH_Capital_Call_Line__c>();
        Map<Id, List<SK_ACH_Commitment__c>> fundCommitments = new Map<Id, List<SK_ACH_Commitment__c>>();
        
        // Group commitments by fund
        for (SK_ACH_Commitment__c c : commitments) {
            if (!fundCommitments.containsKey(c.SK_ACH_Fund__c)) {
                fundCommitments.put(c.SK_ACH_Fund__c, new List<SK_ACH_Commitment__c>());
            }
            fundCommitments.get(c.SK_ACH_Fund__c).add(c);
        }
        
        for (SK_ACH_Capital_Call__c call : calls) {
            List<SK_ACH_Commitment__c> fundComms = fundCommitments.get(call.SK_ACH_Fund__c);
            if (fundComms != null) {
                for (SK_ACH_Commitment__c comm : fundComms) {
                    Decimal lineAmount = call.SK_ACH_Total_Amount__c / fundComms.size();
                    lines.add(new SK_ACH_Capital_Call_Line__c(
                        SK_ACH_Capital_Call__c = call.Id,
                        SK_ACH_Commitment__c = comm.Id,
                        SK_ACH_Line_Amount__c = lineAmount,
                        SK_ACH_Amount_Paid__c = call.SK_ACH_Capital_Call_Status__c == 'Fully Paid' ? 
                            lineAmount : lineAmount * 0.5,
                        SK_ACH_Line_Status__c = call.SK_ACH_Capital_Call_Status__c == 'Fully Paid' ? 
                            'Paid' : 'Partially Paid',
                        SK_ACH_Payment_Date__c = call.SK_ACH_Capital_Call_Status__c == 'Fully Paid' ? 
                            call.SK_ACH_Due_Date__c : null
                    ));
                }
            }
        }
        return lines;
    }
    
    private static List<SK_ACH_Investment__c> createInvestments(
        List<SK_ACH_Fund__c> funds, 
        Integer perFund
    ) {
        List<SK_ACH_Investment__c> investments = new List<SK_ACH_Investment__c>();
        List<String> types = new List<String>{'Growth Equity', 'Buyout', 'Venture Capital', 'Minority Stake'};
        List<String> statuses = new List<String>{'Active', 'Active', 'Active', 'Exited'};
        List<String> industries = new List<String>{'Technology', 'Healthcare', 'Financial Services', 'Consumer Products', 'Industrial'};
        
        for (SK_ACH_Fund__c fund : funds) {
            for (Integer i = 0; i < perFund; i++) {
                Boolean isExited = Math.mod(i, 4) == 3;
                investments.add(new SK_ACH_Investment__c(
                    Name = 'Portfolio Co ' + i,
                    SK_ACH_Investment_Fund__c = fund.Id,
                    SK_ACH_Investment_Type__c = types[Math.mod(i, types.size())],
                    SK_ACH_Investment_Status__c = statuses[Math.mod(i, statuses.size())],
                    SK_ACH_Industry__c = industries[Math.mod(i, industries.size())],
                    SK_ACH_Investment_Date__c = Date.today().addMonths(-12),
                    SK_ACH_Initial_Investment__c = 2000000 + (i * 500000),
                    SK_ACH_Total_Invested__c = 2500000 + (i * 500000),
                    SK_ACH_Entry_Valuation__c = 10000000 + (i * 5000000),
                    SK_ACH_Equity_Ownership_Percent__c = 15.0 + i,
                    SK_ACH_Exit_Date__c = isExited ? Date.today().addMonths(-1) : null,
                    SK_ACH_Exit_Valuation__c = isExited ? 15000000 + (i * 7000000) : null,
                    SK_ACH_Exit_Type__c = isExited ? 'Strategic Sale' : null,
                    SK_ACH_Board_Representation__c = true
                ));
            }
        }
        return investments;
    }
    
    private static List<SK_ACH_Valuation__c> createValuations(
        List<SK_ACH_Investment__c> investments, 
        Integer perInvestment
    ) {
        List<SK_ACH_Valuation__c> valuations = new List<SK_ACH_Valuation__c>();
        
        for (SK_ACH_Investment__c inv : investments) {
            for (Integer i = 0; i < perInvestment; i++) {
                valuations.add(new SK_ACH_Valuation__c(
                    SK_ACH_Valuation_Investment__c = inv.Id,
                    SK_ACH_Valuation_Date__c = Date.today().addMonths(-6 + (i * 3)),
                    SK_ACH_Fair_Value__c = inv.SK_ACH_Entry_Valuation__c * (1.0 + (i * 0.2)),
                    SK_ACH_Valuation_Method__c = 'Market Comparable',
                    SK_ACH_Valuation_Type__c = 'Quarterly',
                    SK_ACH_Valuation_Status__c = 'Approved'
                ));
            }
        }
        return valuations;
    }
    
    private static List<SK_ACH_Distribution__c> createDistributions(
        List<SK_ACH_Fund__c> funds,
        List<SK_ACH_Investment__c> investments,
        Integer perFund
    ) {
        List<SK_ACH_Distribution__c> distributions = new List<SK_ACH_Distribution__c>();
        Map<Id, List<SK_ACH_Investment__c>> fundInvestments = new Map<Id, List<SK_ACH_Investment__c>>();
        
        // Group investments by fund
        for (SK_ACH_Investment__c inv : investments) {
            if (!fundInvestments.containsKey(inv.SK_ACH_Investment_Fund__c)) {
                fundInvestments.put(inv.SK_ACH_Investment_Fund__c, new List<SK_ACH_Investment__c>());
            }
            fundInvestments.get(inv.SK_ACH_Investment_Fund__c).add(inv);
        }
        
        for (SK_ACH_Fund__c fund : funds) {
            List<SK_ACH_Investment__c> fundInvs = fundInvestments.get(fund.Id);
            for (Integer i = 0; i < perFund; i++) {
                distributions.add(new SK_ACH_Distribution__c(
                    SK_ACH_Fund__c = fund.Id,
                    SK_ACH_Source_Investment__c = (fundInvs != null && !fundInvs.isEmpty()) ? 
                        fundInvs[Math.mod(i, fundInvs.size())].Id : null,
                    SK_ACH_Distribution_Date__c = Date.today().addMonths(-2 + i),
                    SK_ACH_Distribution_Total_Amount__c = 1000000 + (i * 500000),
                    SK_ACH_Distribution_Type__c = 'Return of Capital',
                    SK_ACH_Distribution_Status__c = 'Paid'
                ));
            }
        }
        return distributions;
    }
    
    private static List<SK_ACH_Distribution_Line__c> createDistributionLines(
        List<SK_ACH_Distribution__c> distributions,
        List<SK_ACH_Commitment__c> commitments
    ) {
        List<SK_ACH_Distribution_Line__c> lines = new List<SK_ACH_Distribution_Line__c>();
        Map<Id, List<SK_ACH_Commitment__c>> fundCommitments = new Map<Id, List<SK_ACH_Commitment__c>>();
        
        // Group commitments by fund
        for (SK_ACH_Commitment__c c : commitments) {
            if (!fundCommitments.containsKey(c.SK_ACH_Fund__c)) {
                fundCommitments.put(c.SK_ACH_Fund__c, new List<SK_ACH_Commitment__c>());
            }
            fundCommitments.get(c.SK_ACH_Fund__c).add(c);
        }
        
        for (SK_ACH_Distribution__c dist : distributions) {
            List<SK_ACH_Commitment__c> fundComms = fundCommitments.get(dist.SK_ACH_Fund__c);
            if (fundComms != null) {
                for (SK_ACH_Commitment__c comm : fundComms) {
                    lines.add(new SK_ACH_Distribution_Line__c(
                        SK_ACH_Distribution__c = dist.Id,
                        SK_ACH_Commitment__c = comm.Id,
                        SK_ACH_Distribution_Line_Amount__c = dist.SK_ACH_Distribution_Total_Amount__c / fundComms.size(),
                        SK_ACH_Distribution_Line_Status__c = 'Paid',
                        SK_ACH_Line_Payment_Method__c = 'Wire Transfer',
                        SK_ACH_Recipient_Type__c = 'LP'
                    ));
                }
            }
        }
        return lines;
    }
}
