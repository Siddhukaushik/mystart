# LP Dashboard - Limited Partner Portal Component

## Overview

The **LP Dashboard** (`achLpDashboard`) is a Lightning Web Component that provides Limited Partners (LPs) with a secure, self-service portal to view their investment portfolio, financial summary, and commitment details across all funds.

## Purpose

### Business Value

**For Limited Partners:**
- **24/7 Self-Service Access** - View investment data anytime without contacting Investor Relations
- **Real-Time Financial Summary** - See outstanding capital calls, distributions, and net cash flow
- **Multi-Fund Visibility** - Track commitments across multiple funds in one place
- **Transparency** - Complete view of called, paid, distributed, and unfunded amounts

**For General Partners:**
- **Reduced IR Workload** - Decrease routine data requests by 60-80%
- **Enhanced LP Experience** - Professional, modern investor portal
- **Improved Communication** - LPs stay informed without manual reporting
- **Data Security** - Automated row-level security ensures data isolation

### Key Features

1. **Financial Summary Cards**
   - Outstanding Capital Calls (amount owed)
   - Total Distributions (amount received)
   - Net Cash Flow (distributions - calls)
   - Color-coded indicators (red/green)

2. **Investor Information**
   - Investor name
   - Investor type (Institutional, Individual, etc.)

3. **Commitment Table**
   - Fund name
   - Commitment amount
   - Total called to date
   - Total paid to date
   - Total distributed to date
   - Unfunded balance
   - Currency formatting ($USD)

4. **Interactive Features**
   - Refresh button to reload data
   - Loading spinner for better UX
   - Error handling with user-friendly messages

---

## Technical Architecture

### Component Structure

```
achLpDashboard/
├── achLpDashboard.js           # JavaScript controller
├── achLpDashboard.html         # Template (UI)
└── achLpDashboard.js-meta.xml  # Metadata configuration
```

### Data Flow

```
┌─────────────────────────────────────────────────────┐
│  LP Portal User Logs In                             │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│  achLpDashboard.js (@wire methods)                  │
│  ├── getFinancialSummary()                          │
│  └── getInvestorDetails()                           │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│  ACH_LPPortalController.cls (Apex)                  │
│  ├── Identifies current user (UserInfo.getUserId())│
│  └── Queries only LP's own data                     │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│  ACH_LPDataAccess.cls                               │
│  ├── Filters by SK_ACH_Portal_User__c               │
│  └── Enforces row-level security                    │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│  Salesforce Objects                                 │
│  ├── SK_ACH_Investor__c                             │
│  ├── SK_ACH_Commitment__c                           │
│  ├── SK_ACH_Capital_Call_Line__c                    │
│  └── SK_ACH_Distribution_Line__c                    │
└─────────────────────────────────────────────────────┘
```

### Security Model

**Row-Level Security via Apex Sharing:**
- Each LP is linked to their Investor record via `SK_ACH_Portal_User__c` field
- Apex triggers automatically create sharing records (`__Share` objects)
- LPs can only query records where they have explicit sharing access
- Data filtering happens at database level (not just UI)

**Sharing Rules Applied:**
1. Investor → Portal User (Manual share)
2. Commitment → Portal User (inherited from Investor)
3. Capital Call Lines → Filtered by Commitment
4. Distribution Lines → Filtered by Commitment

---

## Deployment Guide

### Prerequisites

✅ **Required Components:**
- ACH_LPPortalController.cls
- ACH_LPDataAccess.cls
- ACH_InvestorSharingHandler.cls
- ACH_LP_Limited_Partner.permissionset
- InvestorTrigger.trigger
- CommitmentTrigger.trigger

✅ **Required Custom Field:**
- `SK_ACH_Investor__c.SK_ACH_Portal_User__c` (Lookup to User)

✅ **Org-Wide Defaults:**
- SK_ACH_Investor__c: **Private**
- SK_ACH_Commitment__c: **Private**

### Step 1: Deploy Component

```bash
# Deploy the LWC component
sf project deploy start --source-dir force-app/main/default/lwc/achLpDashboard

# Deploy supporting Apex classes
sf project deploy start --source-dir force-app/main/default/classes/ACH_LPPortalController.cls
sf project deploy start --source-dir force-app/main/default/classes/ACH_LPDataAccess.cls
```

### Step 2: Create Experience Cloud Site

**A. Enable Digital Experiences:**
1. Setup → Digital Experiences → Settings
2. Enable Digital Experiences (if not already enabled)
3. Click "New" to create a site

**B. Configure Site:**
- **Template:** Customer Service (or similar)
- **Name:** LP Investor Portal
- **URL:** `yourcompany-lp-portal`

**C. Add Login & Registration:**
1. Administration → Login & Registration
2. Configure self-registration or manual user provisioning
3. Set default profile: Clone "Customer Community Plus" profile
4. Assign permission set: `ACH_LP_Limited_Partner`

### Step 3: Add Dashboard to Experience Site

**A. Open Experience Builder:**
1. Navigate to your LP Portal site
2. Click "Builder" (gear icon)

**B. Create Dashboard Page:**
1. Pages → New Page
2. Name: "My Portfolio" or "Dashboard"
3. Template: Standard or Custom layout

**C. Add Component:**
1. Components panel → Custom Components
2. Find "LP Dashboard"
3. Drag onto page
4. Configure properties:
   - **Card Title:** "My Portfolio" (or customize)
5. Save and Publish

**D. Set as Home Page (Optional):**
1. Settings → General
2. Home Page → Select your dashboard page
3. Save

---

## Configuration Options

### Component Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | String | "My Portfolio" | Card title displayed at top |

**How to Configure:**
- In Experience Builder, select the component
- Properties panel appears on the right
- Modify "Card Title" field
- Save and publish

### Styling Customization

**Via Experience Builder:**
- Theme → Branding
- Colors → Primary/Secondary colors
- Typography → Font families

**Via CSS (Advanced):**
- Create a static resource with custom CSS
- Apply to Experience Cloud site theme

---

## User Guide for LPs

### Accessing the Dashboard

1. **Login:**
   - Navigate to your LP portal URL (provided by GP)
   - Enter username and password
   - Click "Log In"

2. **Dashboard Overview:**
   - **Financial Summary Section:**
     - Red number = Money you owe (outstanding calls)
     - Green number = Money you received (distributions)
     - Net Cash Flow = Your overall position
   
   - **Commitment Table:**
     - Each row = One fund investment
     - View detailed breakdown per fund

3. **Refreshing Data:**
   - Click "Refresh" button in top-right corner
   - Data updates in real-time

### Understanding the Numbers

| Field | Meaning |
|-------|---------|
| **Outstanding Capital Calls** | Amount you need to pay to the fund |
| **Total Distributions** | Amount fund has paid you |
| **Net Cash Flow** | Net position (distributions - calls) |
| **Commitment Amount** | Total you committed to invest |
| **Total Called** | Cumulative amount called to date |
| **Total Paid** | Cumulative amount you've paid |
| **Total Distributed** | Cumulative distributions received |
| **Unfunded Balance** | Remaining commitment not yet called |

---

## Troubleshooting

### Common Issues

#### 1. "No data available"
**Cause:** User not linked to Investor record  
**Fix:**
1. Setup → Object Manager → SK_ACH_Investor__c
2. Find the LP's Investor record
3. Edit `Portal User` field
4. Select the community user
5. Save

#### 2. "Error loading data"
**Cause:** Missing sharing rules or permissions  
**Fix:**
1. Verify triggers are active:
   - InvestorTrigger
   - CommitmentTrigger
2. Check permission set assignment:
   - User must have `ACH_LP_Limited_Partner` permission set
3. Verify OWD settings (Private)

#### 3. Component doesn't appear in Experience Builder
**Cause:** Component not exposed or not deployed  
**Fix:**
1. Check `achLpDashboard.js-meta.xml`:
   - `<isExposed>true</isExposed>`
   - Target includes `lightningCommunity__Page`
2. Redeploy component
3. Refresh Experience Builder

#### 4. Wrong data showing (seeing other LPs' data)
**Cause:** Sharing rules not working  
**Fix:**
1. **CRITICAL:** Check Apex triggers are deployed
2. Verify `SK_ACH_Portal_User__c` field is populated
3. Test with: `SELECT Id, SK_ACH_Portal_User__c FROM SK_ACH_Investor__c`
4. Manually recalculate sharing if needed

---

## API Reference

### Apex Controller Methods

#### `getFinancialSummary()`
```apex
@AuraEnabled(cacheable=true)
public static Map<String, Decimal> getFinancialSummary()
```
**Returns:** Map with keys:
- `totalOutstanding` - Outstanding capital calls
- `totalDistributions` - Total distributions
- `netCashFlow` - Calculated net (distributions - outstanding)

**Security:** Filters by `UserInfo.getUserId()` via ACH_LPDataAccess

---

#### `getInvestorDetails()`
```apex
@AuraEnabled(cacheable=true)
public static InvestorWrapper getInvestorDetails()
```
**Returns:** InvestorWrapper containing:
- `investor` - SK_ACH_Investor__c record
- `commitments` - List of SK_ACH_Commitment__c records with:
  - Fund name
  - Commitment amount
  - Rollup fields (called, paid, distributed, unfunded)

**Security:** Queries only where `SK_ACH_Portal_User__c = :currentUserId`

---

### JavaScript Wire Methods

```javascript
@wire(getFinancialSummary)
wiredFinancialSummary(result)

@wire(getInvestorDetails)
wiredInvestorDetails(result)
```

**Caching:** Both methods use `cacheable=true` for performance

---

## Testing

### Test as LP User

1. **Create Test Portal User:**
   ```apex
   User lpUser = new User(
       ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus'].Id,
       Username = 'testlp@yourcompany.com.sandbox',
       Email = 'testlp@yourcompany.com',
       FirstName = 'Test',
       LastName = 'LP',
       Alias = 'tlp',
       TimeZoneSidKey = 'America/Los_Angeles',
       LocaleSidKey = 'en_US',
       EmailEncodingKey = 'UTF-8',
       LanguageLocaleKey = 'en_US'
   );
   insert lpUser;
   ```

2. **Link to Investor:**
   ```apex
   SK_ACH_Investor__c investor = new SK_ACH_Investor__c(
       Name = 'Test LP Fund',
       SK_ACH_Investor_Type__c = 'Institutional',
       SK_ACH_Portal_User__c = lpUser.Id
   );
   insert investor;
   ```

3. **Create Test Data:**
   - Create Fund
   - Create Commitment
   - Create Capital Call + Line
   - Create Distribution + Line

4. **Login as LP User:**
   - Setup → Users → Test LP user
   - Login button (if available)
   - Or use Experience Cloud preview mode

5. **Verify:**
   - ✅ Dashboard shows correct data
   - ✅ Only test LP's data visible
   - ✅ Financial summary calculates correctly
   - ✅ Refresh button works

---

## Maintenance

### Regular Tasks

**Monthly:**
- Review sharing rules audit log
- Verify portal user linkages are current
- Check for orphaned sharing records

**Quarterly:**
- Test with new LP accounts
- Review component performance (LWC analytics)
- Update documentation if business rules change

**Annually:**
- Salesforce release compatibility check
- Security review of sharing model
- Performance optimization if needed

---

## Related Documentation

- [Apex_Capital_Hub_Permissions_and_Exposure.md](./Apex_Capital_Hub_Permissions_and_Exposure.md)
- [PERMISSION_IMPLEMENTATION_SUMMARY.md](../PERMISSION_IMPLEMENTATION_SUMMARY.md)
- [SHARING_SETUP_GUIDE.md](../SHARING_SETUP_GUIDE.md)
- [Apex_Capital_Hub_Objects.md](./Apex_Capital_Hub_Objects.md)

---

## Support

**For Issues:**
1. Check troubleshooting section above
2. Review debug logs in Developer Console
3. Verify sharing rules via Object Manager
4. Test with different LP users

**Code Location:**
- LWC: `force-app/main/default/lwc/achLpDashboard/`
- Apex Controller: `force-app/main/default/classes/ACH_LPPortalController.cls`
- Data Access: `force-app/main/default/classes/ACH_LPDataAccess.cls`

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | Dec 21, 2025 | Initial release with financial summary and commitment table |

---

**Last Updated:** December 21, 2025  
**Author:** Apex Capital Hub Team  
**Component API Version:** 62.0
