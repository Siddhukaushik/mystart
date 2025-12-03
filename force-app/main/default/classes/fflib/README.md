# fflib Framework - Apex Enterprise Patterns

A comprehensive implementation of the fflib (Apex Enterprise Patterns) framework for Salesforce Apex development. This framework provides a structured architecture for building scalable and maintainable Salesforce applications.

## Framework Architecture

The fflib framework follows the enterprise patterns approach with distinct layers:

### 1. **Selector Layer** (`fflib/selector/`)
Handles all data access operations using the Selector pattern.

- **Selector.cls** - Abstract base class for all selectors
- **AccountSelector.cls** - Example Account selector implementation

**Key Features:**
- Centralized query logic
- Reusable SOQL queries
- Method chaining for query building
- Consistent error handling

**Example Usage:**
```apex
AccountSelector selector = new AccountSelector();
List<Account> accounts = selector.selectById(accountIds);
List<Account> activeAccounts = selector.selectActiveAccounts();
```

### 2. **Domain Layer** (`fflib/domain/`)
Encapsulates business logic using the Domain pattern.

- **Domain.cls** - Abstract base class for all domains
- **AccountDomain.cls** - Example Account domain implementation

**Key Features:**
- Business rule validation
- Domain-specific methods
- Trigger event handlers (before/after insert, update, delete)
- Record filtering and manipulation

**Example Usage:**
```apex
AccountDomain domain = new AccountDomain(accounts);
domain.activateAll();
List<Account> industryAccounts = domain.getAccountsByIndustry('Technology');
```

### 3. **Service Layer** (`fflib/service/`)
Orchestrates business operations using the Service pattern.

- **Service.cls** - Abstract base class for all services
- **AccountService.cls** - Example Account service implementation

**Key Features:**
- Service orchestration
- Integration of selectors and domains
- Transaction management
- Validation and error handling

**Example Usage:**
```apex
AccountService service = new AccountService(accounts);
service.initialize();
service.activateAccounts();
service.saveChanges();
```

### 4. **Unit of Work** (`fflib/unit-of-work/`)
Manages database transactions and batches DML operations.

- **UnitOfWork.cls** - Manages insert, update, and delete operations

**Key Features:**
- Batch DML operations
- Transaction atomicity
- Result tracking
- Efficient database access

**Example Usage:**
```apex
UnitOfWork unitOfWork = new UnitOfWork();
unitOfWork.registerNew(newAccounts);
unitOfWork.registerModified(modifiedAccounts);
unitOfWork.registerDeleted(deletedAccounts);
unitOfWork.commitWork();
```

### 5. **Application Layer** (`fflib/application/`)
Provides core framework utilities and patterns.

- **Application.cls** - Service locator for dependency injection
- **TriggerHandler.cls** - Base class for trigger management
- **Logger.cls** - Centralized logging utility
- **ValidationUtil.cls** - Common validation methods

## Directory Structure

```
force-app/main/default/classes/fflib/
├── application/
│   ├── Application.cls
│   ├── TriggerHandler.cls
│   ├── Logger.cls
│   └── ValidationUtil.cls
├── domain/
│   ├── Domain.cls
│   └── AccountDomain.cls
├── selector/
│   ├── Selector.cls
│   └── AccountSelector.cls
├── service/
│   ├── Service.cls
│   └── AccountService.cls
└── unit-of-work/
    └── UnitOfWork.cls
```

## Key Patterns Implemented

### 1. Service Locator Pattern
The `Application` class implements the Service Locator pattern for dependency injection:

```apex
Application app = Application.getInstance();
app.registerService(AccountService.class, accountService);
Object service = app.getService(AccountService.class);
```

### 2. Selector Pattern
Encapsulates all database queries in dedicated selector classes:

```apex
AccountSelector selector = new AccountSelector();
List<Account> accounts = selector.selectById(accountIds);
```

### 3. Domain Pattern
Groups related business logic together:

```apex
AccountDomain domain = new AccountDomain(accounts);
domain.activateAll();
```

### 4. Service Pattern
Orchestrates complex business operations:

```apex
AccountService service = new AccountService(accounts);
service.initialize();
if (service.validate()) {
    service.execute();
    service.saveChanges();
}
```

### 5. Unit of Work Pattern
Batches database operations for efficiency:

```apex
UnitOfWork unitOfWork = new UnitOfWork();
unitOfWork.registerNew(newRecords);
unitOfWork.commitWork();
List<Database.SaveResult> results = unitOfWork.getInsertResults();
```

### 6. Trigger Handler Pattern
Manages trigger logic cleanly:

```apex
public class AccountTriggerHandler extends TriggerHandler {
    public override void handleBeforeInsert() {
        // Before insert logic
    }
    
    public override void handleAfterInsert() {
        // After insert logic
    }
}
```

## Best Practices

1. **Always use Selectors** - Never write queries directly in business logic
2. **Encapsulate Business Logic** - Keep domain logic in Domain classes
3. **Use Services** - Orchestrate complex operations in Service classes
4. **Batch DML** - Use Unit of Work to batch database operations
5. **Logging** - Use Logger utility for consistent logging
6. **Validation** - Use ValidationUtil for common validations
7. **Error Handling** - Always handle exceptions and provide meaningful error messages
8. **Testing** - Write tests for each layer independently

## Example Implementation

### Creating a New Domain

```apex
public class ContactDomain extends Domain {
    public ContactDomain(List<Contact> records) {
        super(records);
    }
    
    public List<Contact> getContactsByAccountId(Id accountId) {
        List<Contact> result = new List<Contact>();
        for (SObject record : records) {
            Contact contact = (Contact) record;
            if (contact.AccountId == accountId) {
                result.add(contact);
            }
        }
        return result;
    }
}
```

### Creating a New Selector

```apex
public class ContactSelector extends Selector {
    public override SObjectType getSObjectType() {
        return Contact.SObjectType;
    }
    
    public override Set<String> getDefaultFields() {
        return new Set<String>{'Id', 'FirstName', 'LastName', 'Email', 'AccountId'};
    }
    
    public List<Contact> selectByAccountId(Set<Id> accountIds) {
        if (accountIds.isEmpty()) {
            return new List<Contact>();
        }
        String whereClause = 'AccountId IN :accountIds';
        return (List<Contact>) selectByQuery(whereClause);
    }
}
```

### Creating a New Service

```apex
public class ContactService extends Service {
    private List<Contact> contacts;
    private ContactDomain contactDomain;
    
    public ContactService(List<Contact> contacts) {
        this.contacts = contacts == null ? new List<Contact>() : contacts;
    }
    
    public override void execute() {
        initialize();
        this.contactDomain = new ContactDomain(contacts);
        logInfo('ContactService executed');
    }
}
```

## Logging

Use the Logger utility for consistent logging:

```apex
Logger.debug('Debug message');
Logger.info('Info message');
Logger.warn('Warning message');
Logger.error('Error message');
Logger.error('Error with exception', ex);
```

## Validation

Use the ValidationUtil for common validations:

```apex
if (ValidationUtil.isNotBlank(accountName)) {
    // Process account
}

if (ValidationUtil.isValidEmail(email)) {
    // Email is valid
}

if (ValidationUtil.isNotEmpty(records)) {
    // Process records
}
```

## Testing

The framework is designed to be testable:

```apex
@isTest
private class AccountServiceTest {
    @isTest
    static void testActivateAccounts() {
        // Setup
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'Test Account'));
        
        // Test
        AccountService service = new AccountService(accounts);
        service.activateAccounts();
        
        // Verify
        System.assertEquals(1, accounts.size());
    }
}
```

## Getting Started

1. Copy the fflib framework files to your `force-app/main/default/classes/fflib/` directory
2. Extend the base classes (Domain, Selector, Service) for your SObjects
3. Use Services to orchestrate business logic
4. Reference selectors from Services for data access
5. Use the Application class for dependency injection

## Contributing

When extending the framework:
1. Follow the naming conventions (e.g., `{SObjectName}Domain`, `{SObjectName}Selector`)
2. Write comprehensive JSDoc comments
3. Include unit tests
4. Handle errors gracefully
5. Use the Logger utility for debugging

## References

- [Apex Enterprise Patterns - fflib](https://github.com/financialforce-com/apex-enterprise-patterns)
- [Salesforce Apex Documentation](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)
- [Enterprise Patterns in Apex](https://www.salesforceben.com/understanding-the-apex-enterprise-patterns/)

---

**Version:** 1.0.0  
**Last Updated:** December 2, 2025  
**Framework:** fflib - Apex Enterprise Patterns
