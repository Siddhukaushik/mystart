/**
 * @description Base Service class for business operations
 * Implements the Service Layer pattern for orchestrating business logic
 */
public abstract class Service {
    
    /**
     * @description Default constructor
     */
    public Service() {
    }
    
    /**
     * @description Abstract method for service initialization
     */
    public virtual void initialize() {
    }
    
    /**
     * @description Abstract method for service validation
     * @return Boolean - True if service is valid, false otherwise
     */
    public virtual Boolean validate() {
        return true;
    }
    
    /**
     * @description Execute the main service logic
     */
    public abstract void execute();
    
    /**
     * @description Rollback any changes made by the service
     */
    public virtual void rollbackChanges() {
    }
    
    /**
     * @description Save changes made by the service
     */
    public virtual void saveChanges() {
    }
    
    /**
     * @description Get the service name
     * @return String - The name of the service
     */
    public virtual String getServiceName() {
        return this.getClass().getName();
    }
    
    /**
     * @description Log information message
     * @param message - The message to log
     */
    protected void logInfo(String message) {
        System.debug(LoggingLevel.INFO, getServiceName() + ': ' + message);
    }
    
    /**
     * @description Log warning message
     * @param message - The message to log
     */
    protected void logWarn(String message) {
        System.debug(LoggingLevel.WARN, getServiceName() + ': ' + message);
    }
    
    /**
     * @description Log error message
     * @param message - The message to log
     */
    protected void logError(String message) {
        System.debug(LoggingLevel.ERROR, getServiceName() + ': ' + message);
    }
}
