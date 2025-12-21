/**
 * Batch Job to generate large volumes of test data
 * Execute: Database.executeBatch(new ACHDataGeneratorBatch(100), 1);
 */
public class ACHDataGeneratorBatch implements Database.Batchable<Integer> {
    
    private Integer totalFunds;
    
    public ACHDataGeneratorBatch(Integer numFunds) {
        this.totalFunds = numFunds;
    }
    
    public Iterable<Integer> start(Database.BatchableContext bc) {
        // Return list of batch numbers (1 fund per batch to avoid limits)
        List<Integer> batches = new List<Integer>();
        for (Integer i = 0; i < totalFunds; i++) {
            batches.add(i);
        }
        return batches;
    }
    
    public void execute(Database.BatchableContext bc, List<Integer> scope) {
        // Generate data for 1 fund per batch execution
        ACHDataGenerator.generateTestData(scope.size());
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('Batch data generation complete!');
    }
}
