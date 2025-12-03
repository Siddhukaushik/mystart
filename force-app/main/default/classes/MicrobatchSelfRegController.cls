public with sharing class MicrobatchSelfRegController {
    public String firstName { get; set; }
    public String lastName { get; set; }
    public Integer batchSize { get; set; }

    public MicrobatchSelfRegController() {
        this.batchSize = 200;
    }

    public PageReference processBatch() {
        return null;
    }
}
