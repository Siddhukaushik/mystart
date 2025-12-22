# Quick Setup Guide - Enable Sharing

## ✅ Completed
- ✅ Portal User field created and deployed
- ✅ Sharing handler code ready (with Share objects temporarily commented out)
- ✅ Test class updated with correct field names

## 🔧 Current Architecture: Master-Detail Relationships

**Important:** Capital Call Line and Distribution Line use **Master-Detail** relationships, which means:
- ✅ They are "Controlled by Parent" (cannot be set to Private independently)
- ❌ No `__Share` objects exist for Master-Detail children
- ✅ **Solution:** LPs filter data via SOQL using the `Commitment` relationship

### How LP Data Access Works

**Instead of Share objects**, LPs query their own lines like this:
```apex
// Get my capital call lines
SELECT Id, SK_ACH_Line_Amount__c 
FROM SK_ACH_Capital_Call_Line__c 
WHERE SK_ACH_Commitment__c IN :myCommitmentIds

// Get my distribution lines
SELECT Id, SK_ACH_Distribution_Line_Amount__c
FROM SK_ACH_Distribution_Line__c
WHERE SK_ACH_Commitment__c IN :myCommitmentIds
```

**Security enforced by:**
1. ✅ Commitment sharing (LPs only see their own commitments)
2. ✅ SOQL filters (queries filtered by Commitment)
3. ✅ List view filters (show only related records)
4. ✅ `ACH_LPDataAccess` helper class (pre-filtered queries)

---

## 🔧 Configuration Steps

### Step 1: Navigate to Sharing Settings
1. Click **Setup** (gear icon)
2. Search for "Sharing Settings"
3. Click **Sharing Settings**

### Step 2: Edit OWD for Each Object

Click **Edit** next to Org-Wide Defaults and set:

| Object | Set OWD To | Status |
|--------|-----------|---------|
| **SK_ACH_Fund__c** | **Public Read Only** | All users can view fund info |
| **SK_ACH_Investor__c** | **Private** | Creates `__Share` object ✅ |
| **SK_ACH_Commitment__c** | **Private** | Creates `__Share` object ✅ |
| **SK_ACH_Capital_Call__c** | **Private** | GP/IR only access |
| **SK_ACH_Capital_Call_Line__c** | **Controlled by Parent** | ⚠️ Master-Detail (no Share object) |
| **SK_ACH_Distribution__c** | **Private** | GP/IR only access |
| **SK_ACH_Distribution_Line__c** | **Controlled by Parent** | ⚠️ Master-Detail (no Share object) |
| **SK_ACH_Investment__c** | **Private** | GP/IR/Analyst only |
| **SK_ACH_Valuation__c** | **Controlled by Parent** | Child of Investment |

### Step 3: Recalculate Sharing (if prompted)
After saving OWD changes for Investor and Commitment, Salesforce may ask to recalculate sharing. Click **Yes**.

This takes 5-10 minutes depending on data volume.

### Step 4: Verify Share Objects Created

Run in Developer Console → Execute Anonymous:
```apex
Schema.DescribeSObjectResult investorShare = SK_ACH_Investor__Share.sObjectType.getDescribe();
Schema.DescribeSObjectResult commitmentShare = SK_ACH_Commitment__Share.sObjectType.getDescribe();
System.debug('Investor Share: ' + investorShare.getName());
System.debug('Commitment Share: ' + commitmentShare.getName());
```

✅ Should show both Share objects exist!

**Note:** Line items (Capital Call Line, Distribution Line) do NOT have Share objects because they use Master-Detail relationships.

### Step 5: Deploy Updated Code
```bash
sf project deploy start --metadata ApexClass
```

Deploys:
- `ACH_InvestorSharingHandler` (updated for Master-Detail)
- `ACH_InvestorSharingHandlerTest` (updated tests)
- `ACH_LPDataAccess` (helper class for LP queries)

---

## 🎯 Why This Order Matters

1. **Field must exist first** → Otherwise code won't compile
2. **OWD must be Private** → Otherwise Share objects don't exist
3. **Share objects must exist** → Otherwise code referencing them fails
4. **Then uncomment code** → Only after prerequisites are met

---

## 🚨 Current Status

**Code will compile NOW** because:
- ✅ Portal User field deployed
- ✅ Share object references commented out (temporary)

**Code will be FULLY FUNCTIONAL after**:
- ⏳ OWD configured to Private
- ⏳ Share code uncommented

---

## 📞 Troubleshooting

**Error: "Variable does not exist: SK_ACH_Portal_User__c"**
→ Field not deployed. Run deployment command above.

**Error: "Invalid type: SK_ACH_Capital_Call_Line__Share"**
→ OWD not set to Private. Follow Step 2 above.

**No sharing records created**
→ Check that:
1. Investor has `SK_ACH_Portal_User__c` populated
2. OWD is Private
3. Sharing code is uncommented

---

**Status:** Ready for OWD configuration
