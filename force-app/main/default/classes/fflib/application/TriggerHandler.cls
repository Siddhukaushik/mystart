/**
 * @description Generic Trigger Handler for managing trigger logic
 * Implements the Trigger Handler pattern for clean separation of concerns
 */
public abstract class TriggerHandler {
    
    protected List<SObject> newRecords;
    protected List<SObject> oldRecords;
    protected Map<Id, SObject> newRecordMap;
    protected Map<Id, SObject> oldRecordMap;
    
    private Boolean isExecuting;
    private TriggerContext context;
    
    /**
     * @description Constructor that receives trigger context
     * @param isExecuting - Whether trigger is executing
     * @param size - Number of records
     */
    public TriggerHandler(Boolean isExecuting, Integer size) {
        this.isExecuting = isExecuting;
        this.context = new TriggerContext(
            Trigger.isBefore,
            Trigger.isAfter,
            Trigger.isInsert,
            Trigger.isUpdate,
            Trigger.isDelete,
            Trigger.isUndelete,
            Trigger.new,
            Trigger.newMap,
            Trigger.old,
            Trigger.oldMap
        );
        this.newRecords = context.newRecords;
        this.oldRecords = context.oldRecords;
        this.newRecordMap = context.newRecordMap;
        this.oldRecordMap = context.oldRecordMap;
    }
    
    /**
     * @description Execute the appropriate trigger handler method
     */
    public void execute() {
        if (!isExecuting) {
            return;
        }
        
        try {
            if (context.isBefore) {
                if (context.isInsert) {
                    handleBeforeInsert();
                } else if (context.isUpdate) {
                    handleBeforeUpdate();
                } else if (context.isDelete) {
                    handleBeforeDelete();
                }
            } else if (context.isAfter) {
                if (context.isInsert) {
                    handleAfterInsert();
                } else if (context.isUpdate) {
                    handleAfterUpdate();
                } else if (context.isDelete) {
                    handleAfterDelete();
                } else if (context.isUndelete) {
                    handleAfterUndelete();
                }
            }
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, 'TriggerHandler error: ' + ex.getMessage());
            throw ex;
        }
    }
    
    // Abstract methods to be implemented by subclasses
    protected virtual void handleBeforeInsert() {
    }
    
    protected virtual void handleBeforeUpdate() {
    }
    
    protected virtual void handleBeforeDelete() {
    }
    
    protected virtual void handleAfterInsert() {
    }
    
    protected virtual void handleAfterUpdate() {
    }
    
    protected virtual void handleAfterDelete() {
    }
    
    protected virtual void handleAfterUndelete() {
    }
    
    /**
     * @description Trigger context wrapper class
     */
    public class TriggerContext {
        public Boolean isBefore;
        public Boolean isAfter;
        public Boolean isInsert;
        public Boolean isUpdate;
        public Boolean isDelete;
        public Boolean isUndelete;
        public List<SObject> newRecords;
        public Map<Id, SObject> newRecordMap;
        public List<SObject> oldRecords;
        public Map<Id, SObject> oldRecordMap;
        
        public TriggerContext(
            Boolean isBefore,
            Boolean isAfter,
            Boolean isInsert,
            Boolean isUpdate,
            Boolean isDelete,
            Boolean isUndelete,
            List<SObject> newRecords,
            Map<Id, SObject> newRecordMap,
            List<SObject> oldRecords,
            Map<Id, SObject> oldRecordMap
        ) {
            this.isBefore = isBefore;
            this.isAfter = isAfter;
            this.isInsert = isInsert;
            this.isUpdate = isUpdate;
            this.isDelete = isDelete;
            this.isUndelete = isUndelete;
            this.newRecords = newRecords;
            this.newRecordMap = newRecordMap;
            this.oldRecords = oldRecords;
            this.oldRecordMap = oldRecordMap;
        }
    }
}
