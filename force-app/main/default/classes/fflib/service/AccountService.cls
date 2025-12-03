/**
 * @description Account Service for business operations
 * Handles Account-related business logic and orchestrates between domain and selector
 */
public class AccountService extends Service {
    
    private List<Account> accounts;
    private AccountDomain accountDomain;
    private AccountSelector accountSelector;
    private UnitOfWork unitOfWork;
    
    /**
     * @description Constructor with dependency injection
     * @param accounts - List of accounts to work with
     */
    public AccountService(List<Account> accounts) {
        this.accounts = accounts == null ? new List<Account>() : accounts;
        this.accountSelector = new AccountSelector();
        this.unitOfWork = new UnitOfWork();
    }
    
    /**
     * @description Initialize the service
     */
    public override void initialize() {
        this.accountDomain = new AccountDomain(accounts);
        logInfo('AccountService initialized with ' + accounts.size() + ' accounts');
    }
    
    /**
     * @description Validate the service data
     * @return Boolean - True if valid
     */
    public override Boolean validate() {
        if (accounts.isEmpty()) {
            logWarn('No accounts provided to service');
            return false;
        }
        logInfo('Validation passed for ' + accounts.size() + ' accounts');
        return true;
    }
    
    /**
     * @description Execute the main service logic
     */
    public override void execute() {
        initialize();
        if (!validate()) {
            throw new ServiceException('Account Service validation failed');
        }
        logInfo('AccountService execution started');
    }
    
    /**
     * @description Save changes made to accounts
     */
    public override void saveChanges() {
        if (!accounts.isEmpty()) {
            unitOfWork.registerModified(accounts);
            unitOfWork.commitWork();
            logInfo('Accounts saved successfully');
        }
    }
    
    /**
     * @description Activate all accounts
     */
    public void activateAccounts() {
        initialize();
        accountDomain.activateAll();
        logInfo('All accounts activated');
    }
    
    /**
     * @description Deactivate all accounts
     */
    public void deactivateAccounts() {
        initialize();
        accountDomain.deactivateAll();
        logInfo('All accounts deactivated');
    }
    
    /**
     * @description Get accounts by industry
     * @param industry - The industry to filter by
     * @return List<Account> - Filtered accounts
     */
    public List<Account> getAccountsByIndustry(String industry) {
        initialize();
        return accountDomain.getAccountsByIndustry(industry);
    }
    
    /**
     * @description Get accounts by name search
     * @param searchText - Text to search for in account names
     * @return List<Account> - Matching accounts
     */
    public List<Account> searchAccountsByName(String searchText) {
        initialize();
        Set<Id> matchingIds = accountDomain.getAccountIdsByName(searchText);
        if (matchingIds.isEmpty()) {
            return new List<Account>();
        }
        return accountSelector.selectById(matchingIds);
    }
    
    /**
     * @description Load accounts from database by Ids
     * @param accountIds - Set of account Ids to load
     * @return List<Account> - Loaded accounts
     */
    public List<Account> loadAccountsById(Set<Id> accountIds) {
        return accountSelector.selectById(accountIds);
    }
    
    /**
     * @description Get all active accounts from database
     * @return List<Account> - Active accounts
     */
    public List<Account> getAllActiveAccounts() {
        return accountSelector.selectActiveAccounts();
    }
    
    /**
     * @description Custom exception for Account Service
     */
    public class ServiceException extends Exception {
    }
}
