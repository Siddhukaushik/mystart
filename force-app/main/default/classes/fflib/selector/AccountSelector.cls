/**
 * @description Account Selector for data access layer
 * Handles all Account queries and provides convenient accessor methods
 */
public class AccountSelector extends Selector {
    
    /**
     * @description Get the SObject type
     * @return SObjectType - Account SObject type
     */
    public override SObjectType getSObjectType() {
        return Account.SObjectType;
    }
    
    /**
     * @description Get default fields for Account queries
     * @return Set<String> - Set of default field names
     */
    public override Set<String> getDefaultFields() {
        return new Set<String>{
            'Id',
            'Name',
            'Phone',
            'Website',
            'Industry',
            'AnnualRevenue',
            'NumberOfEmployees',
            'Description',
            'BillingCity',
            'BillingCountry',
            'BillingPostalCode',
            'BillingState',
            'BillingStreet',
            'ShippingCity',
            'ShippingCountry',
            'ShippingPostalCode',
            'ShippingState',
            'ShippingStreet',
            'Type',
            'CreatedDate',
            'LastModifiedDate'
        };
    }
    
    /**
     * @description Select all accounts
     * @return List<Account> - All accounts
     */
    public List<Account> selectAll() {
        return (List<Account>) selectAll();
    }
    
    /**
     * @description Select accounts by Id
     * @param accountIds - Set of account Ids
     * @return List<Account> - Matching accounts
     */
    public List<Account> selectById(Set<Id> accountIds) {
        return (List<Account>) selectById(accountIds);
    }
    
    /**
     * @description Select accounts by name
     * @param names - Set of account names
     * @return List<Account> - Matching accounts
     */
    public List<Account> selectByName(Set<String> names) {
        if (names.isEmpty()) {
            return new List<Account>();
        }
        String whereClause = 'Name IN :names';
        return (List<Account>) selectByQuery(whereClause);
    }
    
    /**
     * @description Select accounts by industry
     * @param industries - Set of industries
     * @return List<Account> - Matching accounts
     */
    public List<Account> selectByIndustry(Set<String> industries) {
        if (industries.isEmpty()) {
            return new List<Account>();
        }
        String whereClause = 'Industry IN :industries';
        return (List<Account>) selectByQuery(whereClause);
    }
    
    /**
     * @description Select active accounts
     * @return List<Account> - Active accounts
     */
    public List<Account> selectActiveAccounts() {
        String whereClause = 'Active__c = true';
        return (List<Account>) selectByQuery(whereClause);
    }
    
    /**
     * @description Select accounts with contacts
     * @return List<Account> - Accounts with related contacts
     */
    public List<Account> selectAccountsWithContacts() {
        fields = getDefaultFields();
        fields.add('(SELECT Id, Name FROM Contacts)');
        String query = 'SELECT ' + String.join(new List<String>(fields), ', ') + 
                       ' FROM Account';
        return Database.query(query);
    }
}
