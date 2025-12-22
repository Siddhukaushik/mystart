# Permission Set Testing Guide

## Overview

This guide helps you test the ACH permission sets and verify that users can only access appropriate data based on their role.

---

## Permission Sets Summary

| Permission Set | Label | Purpose | Access Level |
|----------------|-------|---------|--------------|
| `ACH_GP_General_Partner` | GP - General Partner | Fund managers | Full access to all objects |
| `ACH_IR_Investor_Relations` | IR - Investor Relations | LP communication | Full access to all objects |
| `ACH_Analyst` | Analyst | Portfolio analysis | Edit: Funds/Investments; Read: Investors |
| `ACH_LP_Limited_Partner` | LP - Limited Partner | External investors | Own data only via sharing |

---

## Apex Class Permissions

### GP Permission Set
✅ ACH_LPPortalController  
✅ ACH_LPDataAccess  
✅ ACH_InvestorSharingHandler  
✅ LeadToInvestorController  
✅ ACHDataGenerator  
✅ ACHDataGeneratorBatch  

### IR Permission Set
✅ ACH_LPPortalController  
✅ ACH_LPDataAccess  
✅ ACH_InvestorSharingHandler  
✅ LeadToInvestorController  
✅ ACHDataGenerator  
✅ ACHDataGeneratorBatch  

### Analyst Permission Set
✅ ACH_LPDataAccess  
✅ ACHDataGenerator  

### LP Permission Set
✅ ACH_LPPortalController  
✅ ACH_LPDataAccess  

---

## Test User Creation

### Option 1: Run Apex Script (Recommended)

1. Open Developer Console
2. Debug → Open Execute Anonymous Window
3. Copy contents of `scripts/apex/createTestUsers.apex`
4. Paste and click "Execute"
5. Check debug log for usernames and test data

**Script creates:**
- 4 test users (GP, IR, Analyst, LP)
- 1 test fund
- 1 test investor (linked to LP user)
- 1 commitment ($5M)
- 1 capital call ($1M outstanding)
- 1 distribution ($500K received)

### Option 2: Manual Creation

#### Step 1: Create Users

**GP User:**
```
Profile: System Administrator
Username: testgp@yourcompany.com.sandbox
Email: testgp@test.com
First Name: Test
Last Name: GP
```

**IR User:**
```
Profile: System Administrator
Username: testir@yourcompany.com.sandbox
Email: testir@test.com
First Name: Test
Last Name: IR
```

**Analyst User:**
```
Profile: Standard User
Username: testanalyst@yourcompany.com.sandbox
Email: testanalyst@test.com
First Name: Test
Last Name: Analyst
```

**LP User (Community):**
```
Profile: Customer Community Plus (or your portal profile)
Username: testlp@yourcompany.com.sandbox
Email: testlp@test.com
First Name: Test
Last Name: LP
```

#### Step 2: Assign Permission Sets

1. Setup → Users → [Select User]
2. Permission Set Assignments → Edit Assignments
3. Add appropriate permission set:
   - GP User → `ACH_GP_General_Partner`
   - IR User → `ACH_IR_Investor_Relations`
   - Analyst User → `ACH_Analyst`
   - LP User → `ACH_LP_Limited_Partner`
4. Save

#### Step 3: Link LP User to Investor

1. Navigate to Investors tab
2. Create new Investor or select existing
3. Edit `Portal User` field
4. Select LP test user
5. Save

---

## Testing Scenarios

### Test 1: GP Full Access

**Login as:** GP User  
**Expected Results:**
- ✅ Can view all Funds
- ✅ Can create/edit Investors
- ✅ Can create/edit Commitments
- ✅ Can create Capital Calls
- ✅ Can create Distributions
- ✅ Can view all LP data
- ✅ Can execute data generator classes

**Test Steps:**
1. Login as GP user
2. Navigate to Funds tab → Should see all funds
3. Navigate to Investors tab → Should see all investors
4. Try creating a new Commitment → Should succeed
5. Open any Capital Call → Should have edit access

### Test 2: IR Full Access

**Login as:** IR User  
**Expected Results:**
- ✅ Can view all Funds
- ✅ Can create/edit Investors
- ✅ Can create/edit Commitments
- ✅ Can create Capital Calls
- ✅ Can create Distributions
- ✅ Can view all LP data
- ✅ Can use Lead to Investor converter

**Test Steps:**
1. Login as IR user
2. Navigate to Investors tab → Should see all investors
3. Try editing an Investor record → Should succeed
4. Create a new Capital Call → Should succeed
5. View LP dashboard data → Should see all LPs

### Test 3: Analyst Read-Only Access

**Login as:** Analyst User  
**Expected Results:**
- ✅ Can view all Funds
- ✅ Can edit Funds
- ✅ Can view Investments
- ✅ Can create/edit Valuations
- ✅ Can view Investors (read-only)
- ❌ Cannot edit Investors
- ❌ Cannot create Commitments
- ❌ Cannot create Capital Calls

**Test Steps:**
1. Login as Analyst user
2. Navigate to Funds tab → Should see all funds
3. Edit a Fund → Should succeed
4. Navigate to Investors tab → Should see investors
5. Try editing an Investor → Should get permission error
6. Try creating a Commitment → Should get permission error
7. Navigate to Investments → Should have edit access

### Test 4: LP Own Data Only (CRITICAL)

**Login as:** LP User  
**Expected Results:**
- ✅ Can view own Investor record only
- ✅ Can view own Commitments only
- ✅ Can view own Capital Call Lines only
- ✅ Can view own Distribution Lines only
- ✅ Dashboard shows correct financial summary
- ❌ Cannot see other LPs' data
- ❌ Cannot see fund-level Capital Calls/Distributions
- ❌ Cannot edit any records

**Test Steps:**

#### A. Test Dashboard Access
1. Login as LP user
2. Navigate to LP Portal (Experience Cloud site)
3. View dashboard component
4. **Verify Financial Summary:**
   - Outstanding: $1,000,000 (red)
   - Distributions: $500,000 (green)
   - Net Cash Flow: -$500,000 (red)
5. **Verify Commitment Table:**
   - Should show 1 row: Test Fund I, $5M commitment
   - Called: $1M, Paid: $0, Distributed: $500K, Unfunded: $4M

#### B. Test Data Isolation
1. Open Developer Console
2. Execute Anonymous:
```apex
System.runAs([SELECT Id FROM User WHERE Username LIKE 'testlp%' LIMIT 1]) {
    // Should return 1 investor (own record)
    List<SK_ACH_Investor__c> investors = [SELECT Id FROM SK_ACH_Investor__c];
    System.assertEquals(1, investors.size(), 'LP should only see 1 investor');
    
    // Should return 1 commitment (own record)
    List<SK_ACH_Commitment__c> commitments = [SELECT Id FROM SK_ACH_Commitment__c];
    System.assertEquals(1, commitments.size(), 'LP should only see 1 commitment');
    
    // Should return 0 capital calls (parent records are Private)
    List<SK_ACH_Capital_Call__c> calls = [SELECT Id FROM SK_ACH_Capital_Call__c];
    System.assertEquals(0, calls.size(), 'LP should not see Capital Call parent records');
    
    // Should return 1 capital call line (own record via sharing)
    List<SK_ACH_Capital_Call_Line__c> callLines = [SELECT Id FROM SK_ACH_Capital_Call_Line__c];
    System.assertEquals(1, callLines.size(), 'LP should see 1 capital call line');
    
    System.debug('✅ All data isolation tests passed');
}
```

#### C. Test ACH_LPDataAccess Class
```apex
System.runAs([SELECT Id FROM User WHERE Username LIKE 'testlp%' LIMIT 1]) {
    // Test getMyCapitalCallLines
    List<SK_ACH_Capital_Call_Line__c> lines = ACH_LPDataAccess.getMyCapitalCallLines();
    System.assertEquals(1, lines.size(), 'Should return 1 capital call line');
    System.assertEquals(1000000, lines[0].SK_ACH_Line_Amount__c, 'Amount should be $1M');
    
    // Test getMyTotalOutstanding
    Decimal outstanding = ACH_LPDataAccess.getMyTotalOutstanding();
    System.assertEquals(1000000, outstanding, 'Outstanding should be $1M');
    
    // Test getMyTotalDistributions
    Decimal distributions = ACH_LPDataAccess.getMyTotalDistributions();
    System.assertEquals(500000, distributions, 'Distributions should be $500K');
    
    System.debug('✅ ACH_LPDataAccess tests passed');
}
```

#### D. Test Cross-LP Data Isolation
1. Create a second LP user and investor
2. Create commitment and transactions for 2nd LP
3. Login as first LP user
4. Verify you cannot see 2nd LP's data:
   - Dashboard shows only your data
   - SOQL queries return only your records
   - No access to 2nd LP's investor/commitments

---

## Verification Checklist

### Pre-Deployment
- [ ] All permission sets deployed
- [ ] Apex classes deployed and compiled
- [ ] Triggers deployed and active
- [ ] `SK_ACH_Portal_User__c` field created on Investor object
- [ ] OWD set to Private for Investor and Commitment objects

### Post-Deployment
- [ ] Test users created successfully
- [ ] Permission sets assigned to test users
- [ ] LP user linked to Investor record via `Portal User` field
- [ ] Test data created (Fund, Investor, Commitment, Call, Distribution)
- [ ] Sharing records created automatically by triggers

### GP/IR Testing
- [ ] GP can view all records
- [ ] GP can create/edit all records
- [ ] IR can view all records
- [ ] IR can create/edit all records
- [ ] Both can access all Apex classes

### Analyst Testing
- [ ] Analyst can view all Funds
- [ ] Analyst can edit Funds/Investments
- [ ] Analyst can view Investors (read-only)
- [ ] Analyst cannot edit Investors
- [ ] Analyst cannot create Capital Calls

### LP Testing (CRITICAL)
- [ ] LP can login to portal
- [ ] Dashboard loads without errors
- [ ] Financial summary shows correct amounts
- [ ] Commitment table shows only LP's funds
- [ ] LP cannot see other LPs' data
- [ ] SOQL queries filtered by Portal User field
- [ ] Sharing rules applied automatically
- [ ] LP cannot edit any records
- [ ] LP can refresh dashboard

---

## Troubleshooting

### Issue: LP sees no data
**Cause:** Portal User field not set  
**Fix:**
1. Find Investor record for LP
2. Edit `SK_ACH_Portal_User__c` field
3. Select the community user
4. Save
5. Triggers will create sharing records automatically

### Issue: LP sees other LPs' data
**Cause:** Sharing rules not working or OWD not set to Private  
**Fix:**
1. Verify OWD: Setup → Sharing Settings
   - SK_ACH_Investor__c: Private
   - SK_ACH_Commitment__c: Private
2. Check triggers are active:
   - InvestorTrigger
   - CommitmentTrigger
3. Query sharing records:
```apex
List<SK_ACH_Investor__Share> shares = [SELECT Id, UserOrGroupId, AccessLevel 
                                        FROM SK_ACH_Investor__Share 
                                        WHERE RowCause = 'Manual'];
System.debug('Investor shares: ' + shares.size());
```

### Issue: "Insufficient Privileges" error
**Cause:** Missing permission set assignment or field permissions  
**Fix:**
1. Setup → Users → [User] → Permission Set Assignments
2. Verify correct permission set is assigned
3. Check object permissions in permission set
4. Redeploy permission set if needed

### Issue: Dashboard component not loading
**Cause:** Apex class permissions missing  
**Fix:**
1. Verify permission set has:
   - ACH_LPPortalController (enabled)
   - ACH_LPDataAccess (enabled)
2. Redeploy permission sets
3. Clear browser cache
4. Check debug logs for specific error

### Issue: Financial summary shows $0
**Cause:** No test data or sharing not working  
**Fix:**
1. Verify commitment exists for LP
2. Verify capital call line exists
3. Check `SK_ACH_Commitment__c` field is populated on lines
4. Run ACH_LPDataAccess methods manually to debug

---

## Debug Commands

### Check User's Permission Sets
```apex
User u = [SELECT Id, Name, Username FROM User WHERE Username LIKE 'testlp%' LIMIT 1];
List<PermissionSetAssignment> psa = [SELECT PermissionSet.Name 
                                      FROM PermissionSetAssignment 
                                      WHERE AssigneeId = :u.Id];
for(PermissionSetAssignment p : psa) {
    System.debug(p.PermissionSet.Name);
}
```

### Check LP's Accessible Records
```apex
User lpUser = [SELECT Id FROM User WHERE Username LIKE 'testlp%' LIMIT 1];
System.runAs(lpUser) {
    System.debug('Investors: ' + [SELECT COUNT() FROM SK_ACH_Investor__c]);
    System.debug('Commitments: ' + [SELECT COUNT() FROM SK_ACH_Commitment__c]);
    System.debug('Capital Call Lines: ' + [SELECT COUNT() FROM SK_ACH_Capital_Call_Line__c]);
    System.debug('Distribution Lines: ' + [SELECT COUNT() FROM SK_ACH_Distribution_Line__c]);
}
```

### Check Sharing Records
```apex
List<SK_ACH_Investor__Share> shares = [SELECT ParentId, UserOrGroupId, AccessLevel, RowCause 
                                        FROM SK_ACH_Investor__Share];
System.debug('Investor sharing records: ' + shares.size());
for(SK_ACH_Investor__Share s : shares) {
    System.debug('Investor: ' + s.ParentId + ' → User: ' + s.UserOrGroupId + ' (' + s.RowCause + ')');
}
```

---

## Deployment Commands

### Deploy Permission Sets
```bash
# Deploy all permission sets
sf project deploy start --source-dir force-app/main/default/permissionsets/

# Deploy specific permission set
sf project deploy start --source-dir force-app/main/default/permissionsets/ACH_LP_Limited_Partner.permissionset-meta.xml
```

### Assign Permission Set via CLI
```bash
# Get user ID first
sf data query --query "SELECT Id FROM User WHERE Username='testlp@yourorg.com'" --json

# Assign permission set
sf data create record --sobject PermissionSetAssignment --values "AssigneeId=<USER_ID> PermissionSetId=<PERMSET_ID>"
```

---

## Success Criteria

### All Tests Pass When:
✅ GP/IR users can access all records  
✅ Analyst can edit Funds but not Investors  
✅ LP user can only see their own data  
✅ LP dashboard shows correct financial summary  
✅ No cross-LP data leakage  
✅ Sharing records created automatically  
✅ All SOQL queries filtered correctly  
✅ No "Insufficient Privileges" errors for allowed operations  

---

## Related Documentation

- [LP_Dashboard_Documentation.md](./LP_Dashboard_Documentation.md)
- [Apex_Capital_Hub_Permissions_and_Exposure.md](./Apex_Capital_Hub_Permissions_and_Exposure.md)
- [PERMISSION_IMPLEMENTATION_SUMMARY.md](../PERMISSION_IMPLEMENTATION_SUMMARY.md)

---

**Last Updated:** December 21, 2025  
**Version:** 1.0
