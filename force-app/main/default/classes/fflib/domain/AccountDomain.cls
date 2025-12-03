/**
 * @description Account Domain class for managing Account business logic
 * Extends the base Domain class to implement Account-specific rules
 */
public class AccountDomain extends Domain {
    
    /**
     * @description Constructor
     * @param records - List of Account records
     */
    public AccountDomain(List<Account> records) {
        super(records);
    }
    
    /**
     * @description Get all account Ids with Name containing specified text
     * @param searchText - Text to search for
     * @return Set<Id> - Set of matching Account Ids
     */
    public Set<Id> getAccountIdsByName(String searchText) {
        Set<Id> accountIds = new Set<Id>();
        if (String.isBlank(searchText)) {
            return accountIds;
        }
        
        for (SObject record : records) {
            Account account = (Account) record;
            if (account.Name != null && account.Name.contains(searchText)) {
                accountIds.add(account.Id);
            }
        }
        return accountIds;
    }
    
    /**
     * @description Get accounts by industry
     * @param industry - The industry value
     * @return List<Account> - List of matching accounts
     */
    public List<Account> getAccountsByIndustry(String industry) {
        List<Account> filteredAccounts = new List<Account>();
        if (String.isBlank(industry)) {
            return filteredAccounts;
        }
        
        for (SObject record : records) {
            Account account = (Account) record;
            if (account.Industry == industry) {
                filteredAccounts.add(account);
            }
        }
        return filteredAccounts;
    }
    
    /**
     * @description Set all accounts to active
     */
    public void activateAll() {
        for (SObject record : records) {
            Account account = (Account) record;
            account.Active__c = true;
        }
    }
    
    /**
     * @description Deactivate all accounts
     */
    public void deactivateAll() {
        for (SObject record : records) {
            Account account = (Account) record;
            account.Active__c = false;
        }
    }
    
    /**
     * @description Validate account names on insert
     */
    public override void onBeforeInsert() {
        validateAccountNames();
    }
    
    /**
     * @description Validate account names on update
     */
    public override void onBeforeUpdate(Map<Id, SObject> oldRecordMap) {
        validateAccountNames();
    }
    
    /**
     * @description Validate that all accounts have names
     */
    private void validateAccountNames() {
        for (SObject record : records) {
            Account account = (Account) record;
            if (String.isBlank(account.Name)) {
                account.addError('Account Name is required');
            }
        }
    }
    
    /**
     * @description Get accounts with null values for specified field
     * @param fieldName - The field name to check
     * @return List<Account> - Accounts with null values
     */
    public List<Account> getAccountsWithNullField(String fieldName) {
        List<Account> result = new List<Account>();
        for (SObject record : records) {
            if (record.get(fieldName) == null) {
                result.add((Account) record);
            }
        }
        return result;
    }
}
