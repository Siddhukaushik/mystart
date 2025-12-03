/**
 * @description Unit of Work class for managing database transactions
 * Implements the Unit of Work pattern for batching DML operations
 */
public class UnitOfWork {
    
    private List<SObject> toInsert = new List<SObject>();
    private List<SObject> toUpdate = new List<SObject>();
    private List<SObject> toDelete = new List<SObject>();
    private List<Database.SaveResult> insertResults = new List<Database.SaveResult>();
    private List<Database.SaveResult> updateResults = new List<Database.SaveResult>();
    private List<Database.DeleteResult> deleteResults = new List<Database.DeleteResult>();
    
    /**
     * @description Register a record for insertion
     * @param record - The SObject to insert
     */
    public void registerNew(SObject record) {
        if (record != null) {
            toInsert.add(record);
        }
    }
    
    /**
     * @description Register multiple records for insertion
     * @param records - List of SObjects to insert
     */
    public void registerNew(List<SObject> records) {
        if (records != null && !records.isEmpty()) {
            toInsert.addAll(records);
        }
    }
    
    /**
     * @description Register a record for update
     * @param record - The SObject to update
     */
    public void registerModified(SObject record) {
        if (record != null && record.Id != null) {
            toUpdate.add(record);
        }
    }
    
    /**
     * @description Register multiple records for update
     * @param records - List of SObjects to update
     */
    public void registerModified(List<SObject> records) {
        if (records != null && !records.isEmpty()) {
            toUpdate.addAll(records);
        }
    }
    
    /**
     * @description Register a record for deletion
     * @param record - The SObject to delete
     */
    public void registerDeleted(SObject record) {
        if (record != null && record.Id != null) {
            toDelete.add(record);
        }
    }
    
    /**
     * @description Register multiple records for deletion
     * @param records - List of SObjects to delete
     */
    public void registerDeleted(List<SObject> records) {
        if (records != null && !records.isEmpty()) {
            toDelete.addAll(records);
        }
    }
    
    /**
     * @description Commit all pending DML operations
     */
    public void commitWork() {
        try {
            if (!toInsert.isEmpty()) {
                insertResults = Database.insert(toInsert, false);
            }
            
            if (!toUpdate.isEmpty()) {
                updateResults = Database.update(toUpdate, false);
            }
            
            if (!toDelete.isEmpty()) {
                deleteResults = Database.delete(toDelete, false);
            }
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, 'Unit of Work commit failed: ' + ex.getMessage());
            throw ex;
        }
    }
    
    /**
     * @description Get insert results
     * @return List<Database.SaveResult> - Results from insert operations
     */
    public List<Database.SaveResult> getInsertResults() {
        return insertResults;
    }
    
    /**
     * @description Get update results
     * @return List<Database.SaveResult> - Results from update operations
     */
    public List<Database.SaveResult> getUpdateResults() {
        return updateResults;
    }
    
    /**
     * @description Get delete results
     * @return List<Database.DeleteResult> - Results from delete operations
     */
    public List<Database.DeleteResult> getDeleteResults() {
        return deleteResults;
    }
    
    /**
     * @description Get the count of records pending insert
     * @return Integer - Count of records to insert
     */
    public Integer getInsertCount() {
        return toInsert.size();
    }
    
    /**
     * @description Get the count of records pending update
     * @return Integer - Count of records to update
     */
    public Integer getUpdateCount() {
        return toUpdate.size();
    }
    
    /**
     * @description Get the count of records pending delete
     * @return Integer - Count of records to delete
     */
    public Integer getDeleteCount() {
        return toDelete.size();
    }
    
    /**
     * @description Clear all pending operations
     */
    public void clear() {
        toInsert.clear();
        toUpdate.clear();
        toDelete.clear();
        insertResults.clear();
        updateResults.clear();
        deleteResults.clear();
    }
    
    /**
     * @description Check if there are any pending operations
     * @return Boolean - True if there are pending operations
     */
    public Boolean hasPendingOperations() {
        return !toInsert.isEmpty() || !toUpdate.isEmpty() || !toDelete.isEmpty();
    }
}
