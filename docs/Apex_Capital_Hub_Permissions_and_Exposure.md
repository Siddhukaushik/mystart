# Apex Capital Hub - Exposure & Permission Model

**Version:** 1.0  
**Created:** December 21, 2025  
**Purpose:** Define and implement role-based access control (RBAC) for Private Equity fund administration

---

## 🎯 What is "Exposure" in PE Context?

**Exposure** = Who can see what data, and at what level (Fund / Investor / Transaction)

In Private Equity, exposure controls are critical because:
- **Investor data is highly confidential** (LP names, commitment amounts, financial positions)
- **Portfolio performance is sensitive** (valuations, returns, deal terms)
- **Regulatory compliance** requires strict data segregation between LPs

---

## 👥 User Roles & Responsibilities

### 1. **GP (General Partner)**
- **Role:** Fund managers who make investment decisions
- **Responsibilities:** 
  - Manage fund strategy and portfolio
  - Oversee all operations
  - Full visibility into all LPs and investments
- **Access Level:** Full CRUD on all objects

### 2. **IR (Investor Relations)**
- **Role:** Manages LP communications and capital flows
- **Responsibilities:**
  - Process capital calls and distributions
  - Maintain investor records
  - Handle LP queries and reporting
- **Access Level:** Full CRUD on all objects (similar to GP)

### 3. **Analyst**
- **Role:** Portfolio analysis and performance tracking
- **Responsibilities:**
  - Track investments and valuations
  - Prepare performance reports
  - Monitor portfolio metrics
- **Access Level:** 
  - Full access: Funds, Investments, Valuations
  - Read-only: Investor-related objects (Investors, Commitments, Capital Calls, Distributions)

### 4. **LP (Limited Partner) - Portal User**
- **Role:** External investors who commit capital to the fund
- **Responsibilities:**
  - View their own commitments and performance
  - Access capital call notices
  - Review distribution statements
- **Access Level:** 
  - Read-only access to high-level fund info
  - Can ONLY see their own records (never other LPs)

---

## 📊 Object-Level Exposure Matrix

| Object | GP | IR | Analyst | LP (Portal) |
|--------|----|----|---------|-------------|
| **Fund** | Full CRUD ✅ | Full CRUD ✅ | Full CRUD ✅ | Read Only (View All) 👁️ |
| **Investor** | Full CRUD ✅ | Full CRUD ✅ | Read Only 👁️ | Read Only (Own Only) 🔒 |
| **Commitment** | Full CRUD ✅ | Full CRUD ✅ | Read Only 👁️ | Read Only (Own Only) 🔒 |
| **Capital Call** | Full CRUD ✅ | Full CRUD ✅ | Read Only 👁️ | No Access ❌ |
| **Capital Call Line** | Full CRUD ✅ | Full CRUD ✅ | Read Only 👁️ | Read Only (Own Only) 🔒 |
| **Distribution** | Full CRUD ✅ | Full CRUD ✅ | Read Only 👁️ | No Access ❌ |
| **Distribution Line** | Full CRUD ✅ | Full CRUD ✅ | Read Only 👁️ | Read Only (Own Only) 🔒 |
| **Investment** | Full CRUD ✅ | Full CRUD ✅ | Full CRUD ✅ | No Access ❌ |
| **Valuation** | Full CRUD ✅ | Full CRUD ✅ | Full CRUD ✅ | No Access ❌ |

**Legend:**
- ✅ Full CRUD = Create, Read, Update, Delete + View/Modify All Records
- 👁️ Read Only = View All Records, no modifications
- 🔒 Own Only = Can only see records related to their Investor record
- ❌ No Access = Cannot see the object at all

---

## 🔐 Critical Security Rule

### **LPs MUST ONLY see their own records**

**Why?**
- **Privacy:** LP identities and investment amounts are confidential
- **Competition:** LPs don't want competitors knowing their allocations
- **Regulation:** GDPR, SEC rules require data segregation

**How we enforce this:**

1. **Permission Sets:** LP permission set has `viewAllRecords=false` on sensitive objects
2. **Sharing Rules:** Apex-managed sharing to grant access only to records where:
   - Investor matches the LP's User.ContactId.AccountId
   - Or Commitment → Investor matches
   - Or Capital Call Line → Commitment → Investor matches
   - Or Distribution Line → Commitment → Investor matches

3. **OWD (Org-Wide Defaults):** Set to Private for:
   - SK_ACH_Investor__c
   - SK_ACH_Commitment__c
   - SK_ACH_Capital_Call_Line__c
   - SK_ACH_Distribution_Line__c

---

## 📁 Permission Sets Created

### 1. `ACH_GP_General_Partner.permissionset-meta.xml`
- Full CRUD on all 9 objects
- View/Modify All Records enabled
- All tabs visible

### 2. `ACH_IR_Investor_Relations.permissionset-meta.xml`
- Full CRUD on all 9 objects
- View/Modify All Records enabled
- All tabs visible

### 3. `ACH_Analyst.permissionset-meta.xml`
- **Full CRUD:** Fund, Investment, Valuation
- **Read Only:** Investor, Commitment, Capital Call, Capital Call Line, Distribution, Distribution Line
- Tabs: Fund, Investment, Valuation (Visible), others (Available)

### 4. `ACH_LP_Limited_Partner.permissionset-meta.xml`
- **Read Only (View All):** Fund
- **Read Only (Own Records):** Investor, Commitment, Capital Call Line, Distribution Line
- **No Access:** Capital Call, Distribution, Investment, Valuation
- Tabs: Fund, Commitment, Capital Call Line, Distribution Line only

---

## 🛠️ Implementation Checklist

### Step 1: Set Org-Wide Defaults (Manual in Setup)
```
Setup → Sharing Settings → Org-Wide Defaults:
- SK_ACH_Investor__c: Private
- SK_ACH_Commitment__c: Private (Controlled by Parent)
- SK_ACH_Capital_Call_Line__c: Private (Controlled by Parent)
- SK_ACH_Distribution_Line__c: Private (Controlled by Parent)
- SK_ACH_Fund__c: Public Read Only
- SK_ACH_Capital_Call__c: Private
- SK_ACH_Distribution__c: Private
- SK_ACH_Investment__c: Private
- SK_ACH_Valuation__c: Private (Controlled by Parent)
```

### Step 2: Assign Permission Sets
```
GP Users → Assign: ACH_GP_General_Partner
IR Users → Assign: ACH_IR_Investor_Relations
Analyst Users → Assign: ACH_Analyst
LP Portal Users → Assign: ACH_LP_Limited_Partner
```

### Step 3: Create Apex Sharing Handler (Next Step)
- Create `ACH_InvestorSharingHandler.cls`
- Trigger on Investor creation/update
- Grant LP users read access to their Investor record
- Cascade sharing to child records (Commitments, Lines)

### Step 4: Link Portal Users to Investors
```
Setup → Users → Portal User → Edit
- Set Contact → Account relationship
- Link Account to SK_ACH_Investor__c record
- Use custom field: SK_ACH_Investor__c.SK_ACH_Related_User__c
```

### Step 5: Test Scenarios
1. **GP logs in** → Sees all funds, all investors, all records ✅
2. **IR logs in** → Sees all funds, all investors, all records ✅
3. **Analyst logs in** → Sees all funds/investments, read-only investors ✅
4. **LP-A logs in** → Sees only their records, not LP-B ✅
5. **LP-B logs in** → Sees only their records, not LP-A ✅

---

## 🔄 Sharing Rule Logic (Apex)

### Investor Object Sharing
```apex
// When Investor is created/updated, grant read access to portal user
if (investor.SK_ACH_Portal_User__c != null) {
    SK_ACH_Investor__Share investorShare = new SK_ACH_Investor__Share();
    investorShare.ParentId = investor.Id;
    investorShare.UserOrGroupId = investor.SK_ACH_Portal_User__c;
    investorShare.AccessLevel = 'Read';
    investorShare.RowCause = Schema.SK_ACH_Investor__Share.RowCause.Manual;
    insert investorShare;
}
```

### Commitment Sharing (via Parent Investor)
```apex
// When Commitment is created, inherit sharing from Investor
List<SK_ACH_Commitment__Share> commShares = new List<SK_ACH_Commitment__Share>();
for (SK_ACH_Commitment__c comm : newCommitments) {
    if (comm.SK_ACH_Investor__c != null) {
        // Query investor's portal user
        SK_ACH_Investor__c investor = [SELECT SK_ACH_Portal_User__c 
                                        FROM SK_ACH_Investor__c 
                                        WHERE Id = :comm.SK_ACH_Investor__c];
        if (investor.SK_ACH_Portal_User__c != null) {
            SK_ACH_Commitment__Share commShare = new SK_ACH_Commitment__Share();
            commShare.ParentId = comm.Id;
            commShare.UserOrGroupId = investor.SK_ACH_Portal_User__c;
            commShare.AccessLevel = 'Read';
            commShare.RowCause = Schema.SK_ACH_Commitment__Share.RowCause.Manual;
            commShares.add(commShare);
        }
    }
}
```

### Capital Call Line & Distribution Line Sharing
```apex
// Similar logic: traverse Commitment → Investor → Portal User
```

---

## 📝 Next Steps

1. ✅ Permission sets created
2. ⏳ Create Apex sharing handler classes
3. ⏳ Add `SK_ACH_Portal_User__c` lookup field to Investor object
4. ⏳ Configure OWD settings
5. ⏳ Create test classes for sharing rules
6. ⏳ Setup Experience Cloud portal for LPs
7. ⏳ Create LP-specific page layouts (hide sensitive fields)

---

## 🎯 Key Takeaways

✅ **GP & IR** → Full access to everything  
✅ **Analysts** → Full access to portfolio data, read-only on investors  
✅ **LPs** → Only see their own data, never other LPs  
✅ **Security enforced** via Permission Sets + Apex Sharing + OWD  
✅ **Compliance-ready** for SEC, GDPR, and industry standards  

---

**Questions?** Contact the Apex Capital Hub development team.
