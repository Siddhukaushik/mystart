/**
 * @description Base Domain class for business logic
 * Implements the Domain pattern for encapsulating business rules
 */
public abstract class Domain {
    
    protected List<SObject> records = new List<SObject>();
    protected Map<Id, SObject> recordsMap = new Map<Id, SObject>();
    
    /**
     * @description Constructor that takes a list of SObjects
     * @param records - List of SObjects to manage
     */
    public Domain(List<SObject> records) {
        this.records = records == null ? new List<SObject>() : records;
        for (SObject record : this.records) {
            this.recordsMap.put(record.Id, record);
        }
    }
    
    /**
     * @description Get the list of records
     * @return List<SObject> - The records managed by this domain
     */
    public List<SObject> getRecords() {
        return records;
    }
    
    /**
     * @description Get the record map (keyed by Id)
     * @return Map<Id, SObject> - Map of records by Id
     */
    public Map<Id, SObject> getRecordsMap() {
        return recordsMap;
    }
    
    /**
     * @description Get a specific record by Id
     * @param recordId - The Id of the record
     * @return SObject - The record, or null if not found
     */
    public SObject getRecord(Id recordId) {
        return recordsMap.get(recordId);
    }
    
    /**
     * @description Get the number of records
     * @return Integer - The count of records
     */
    public Integer getSize() {
        return records.size();
    }
    
    /**
     * @description Check if there are any records
     * @return Boolean - True if records exist, false otherwise
     */
    public Boolean hasRecords() {
        return !records.isEmpty();
    }
    
    /**
     * @description Get all record Ids
     * @return Set<Id> - Set of all record Ids
     */
    public Set<Id> getRecordIds() {
        return recordsMap.keySet();
    }
    
    /**
     * @description Method to be overridden for on insert trigger logic
     */
    public virtual void onBeforeInsert() {
    }
    
    /**
     * @description Method to be overridden for on update trigger logic
     */
    public virtual void onBeforeUpdate(Map<Id, SObject> oldRecordMap) {
    }
    
    /**
     * @description Method to be overridden for on delete trigger logic
     */
    public virtual void onBeforeDelete() {
    }
    
    /**
     * @description Method to be overridden for after insert trigger logic
     */
    public virtual void onAfterInsert() {
    }
    
    /**
     * @description Method to be overridden for after update trigger logic
     */
    public virtual void onAfterUpdate(Map<Id, SObject> oldRecordMap) {
    }
    
    /**
     * @description Method to be overridden for after delete trigger logic
     */
    public virtual void onAfterDelete() {
    }
    
    /**
     * @description Method to be overridden for after undelete trigger logic
     */
    public virtual void onAfterUndelete() {
    }
}
