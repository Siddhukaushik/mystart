/**
 * @description Base Selector class for data access layer
 * Implements the Selector pattern for database queries
 */
public abstract class Selector {
    
    protected Set<String> fields = new Set<String>();
    protected String orderByClause;
    protected Integer limitClause;
    protected Integer offsetClause;
    
    /**
     * @description Get the SObject type managed by this selector
     * @return SObjectType - The SObject type
     */
    abstract SObjectType getSObjectType();
    
    /**
     * @description Get the default list of fields to query
     * @return Set<String> - Set of field names
     */
    abstract Set<String> getDefaultFields();
    
    /**
     * @description Build the SOQL query
     * @param whereClause - Optional WHERE clause
     * @return String - The complete SOQL query
     */
    public String buildQuery(String whereClause) {
        fields = getDefaultFields();
        String query = 'SELECT ' + String.join(new List<String>(fields), ', ') + 
                       ' FROM ' + getSObjectType().getDescribe().getName();
        
        if (String.isNotBlank(whereClause)) {
            query += ' WHERE ' + whereClause;
        }
        
        if (String.isNotBlank(orderByClause)) {
            query += ' ' + orderByClause;
        }
        
        if (limitClause != null) {
            query += ' LIMIT ' + limitClause;
        }
        
        if (offsetClause != null) {
            query += ' OFFSET ' + offsetClause;
        }
        
        return query;
    }
    
    /**
     * @description Select all records of the SObject type
     * @return List<SObject> - List of all records
     */
    public List<SObject> selectAll() {
        return Database.query(buildQuery(''));
    }
    
    /**
     * @description Select records by Id
     * @param ids - Set of record Ids
     * @return List<SObject> - List of records matching the Ids
     */
    public List<SObject> selectById(Set<Id> ids) {
        if (ids.isEmpty()) {
            return new List<SObject>();
        }
        String query = buildQuery('Id IN :ids');
        return Database.query(query);
    }
    
    /**
     * @description Execute a custom query
     * @param whereClause - The WHERE clause for the query
     * @return List<SObject> - Query results
     */
    public List<SObject> selectByQuery(String whereClause) {
        return Database.query(buildQuery(whereClause));
    }
    
    /**
     * @description Set the ORDER BY clause
     * @param orderBy - The ORDER BY clause
     * @return Selector - Returns this for method chaining
     */
    public Selector orderBy(String orderBy) {
        this.orderByClause = orderBy;
        return this;
    }
    
    /**
     * @description Set the LIMIT clause
     * @param limitValue - The limit value
     * @return Selector - Returns this for method chaining
     */
    public Selector setLimit(Integer limitValue) {
        this.limitClause = limitValue;
        return this;
    }
    
    /**
     * @description Set the OFFSET clause
     * @param offsetValue - The offset value
     * @return Selector - Returns this for method chaining
     */
    public Selector setOffset(Integer offsetValue) {
        this.offsetClause = offsetValue;
        return this;
    }
}
