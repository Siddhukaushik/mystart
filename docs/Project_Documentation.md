# Project Documentation

## Overview
This document provides a comprehensive overview of the objects, relationships, Lightning Web Components (LWCs), Apex triggers, controllers, validation rules, and other components built as part of the project.

---

## 1. Objects and Relationships

### Key Objects:
1. **SK_ACH_Investor__c (Investor)**
   - Represents investors (e.g., individuals, institutions).
   - **Relationships:**
     - **Commitments**: Investors commit funds to specific funds via `SK_ACH_Commitment__c`.

2. **SK_ACH_Fund__c (Fund)**
   - Represents funds raised by the organization.
   - **Relationships:**
     - **Commitments**: Funds receive commitments from investors via `SK_ACH_Commitment__c`.
     - **Investments**: Funds invest in portfolio companies via `SK_ACH_Investment__c`.

3. **SK_ACH_Commitment__c (Commitment)**
   - Junction object connecting **Investors** and **Funds**.
   - Tracks the amount committed, status, and other details.
   - **Relationships:**
     - **Capital Calls**: Commitments are linked to capital calls via `SK_ACH_Capital_Call_Line__c`.
     - **Distributions**: Commitments are linked to distributions via `SK_ACH_Distribution_Line__c`.

4. **SK_ACH_Investment__c (Investment)**
   - Represents investments made by funds into portfolio companies.
   - **Relationships:**
     - **Portfolio Companies**: Investments are linked to portfolio companies via `SK_ACH_Portfolio_Company__c`.

5. **SK_ACH_Capital_Call__c (Capital Call)**
   - Represents a request for committed capital from investors.
   - **Relationships:**
     - **Capital Call Lines**: Links to commitments via `SK_ACH_Capital_Call_Line__c`.

6. **SK_ACH_Distribution__c (Distribution)**
   - Represents returns distributed to investors.
   - **Relationships:**
     - **Distribution Lines**: Links to commitments via `SK_ACH_Distribution_Line__c`.

---

## 2. Lightning Web Components (LWCs)

### Built LWCs:
1. **leadToInvestorConverter**
   - **Purpose**: Converts qualified Leads into Investors.
   - **Key Features**:
     - Displays a button on the Lead record page.
     - Converts Lead to Investor and updates Lead status to "Converted."
   - **Dependencies**:
     - Apex Controller: `LeadToInvestorController.cls`.

2. **raiseFunds**
   - **Purpose**: Quick action to create Commitments for Investors.
   - **Key Features**:
     - Allows users to select a Fund and enter a Commitment Amount.
     - Creates a Commitment record linking the Investor and Fund.
   - **Dependencies**:
     - Apex Controller: `RaiseFundsController.cls`.

---

## 3. Apex Controllers

### Built Controllers:
1. **LeadToInvestorController.cls**
   - **Purpose**: Backend logic for converting Leads to Investors.
   - **Key Methods**:
     - `convertLeadToInvestor`: Validates Lead status, creates an Investor, and updates the Lead.

2. **RaiseFundsController.cls**
   - **Purpose**: Backend logic for creating Commitments.
   - **Key Methods**:
     - `getActiveFunds`: Retrieves active funds for the `raiseFunds` LWC.

---

## 4. Apex Triggers

### Built Triggers:
1. **DistributionLineTrigger**
   - **Purpose**: Updates Commitment totals when Distribution Lines are inserted, updated, or deleted.
   - **Trigger Events**: `after insert`, `after update`, `after delete`, `after undelete`.
   - **Handler**: `DistributionLineTriggerHandler.cls`.

2. **CapitalCallLineTrigger**
   - **Purpose**: Updates Commitment totals when Capital Call Lines are inserted, updated, or deleted.
   - **Trigger Events**: `after insert`, `after update`, `after delete`, `after undelete`.
   - **Handler**: `CapitalCallLineTriggerHandler.cls`.

---

## 5. Data Management

### Scripts and Cleanup:
1. **Storage Cleanup:**
   - Deleted excess Valuations and Capital Call Lines to reduce storage usage.
   - Scripts:
     - `deleteStorageHogs.apex`: Deletes old Valuations and Capital Call Lines.

2. **Data Updates:**
   - Updated Fund and Investor names using CSV files:
     - `Fund_Names_Update.csv`
     - `Investor_Names_Update.csv`

---

## 6. FlexiPages and Quick Actions

### FlexiPages:
1. **Lead Record Page**:
   - Added the `leadToInvestorConverter` LWC to the Lead record page.

2. **Investor Record Page**:
   - Added the `raiseFunds` quick action to the Investor page layout.

### Quick Actions:
1. **Raise Funds**:
   - Quick action for creating Commitments from the Investor record.

---

## 7. Validation Rules

### Implemented Rules:
1. **Signature Date Validation**:
   - Ensures that the `Signature Date` on Commitments is not in the future.

---

## 8. Summary of Relationships

### Key Relationships:
- **Investor → Commitment → Fund**
- **Fund → Investment → Portfolio Company**
- **Commitment → Capital Call Line → Capital Call**
- **Commitment → Distribution Line → Distribution**

---

## 9. Phase 2 Automation: Capital Call Generation & Distribution Waterfall

### Capital Call Generation (Flow & Apex)
- **Flow:** `Generate_Capital_Call_Lines`
  - Screen flow to select Fund and enter Capital Call Amount
  - Calls Apex service to automate pro-rata allocations
- **Apex Service:** `CapitalCallService.cls`
  - Retrieves all Commitments for selected Fund
  - Calculates each investor's pro-rata share based on unfunded balance
  - Creates Capital Call record (with all required fields)
  - Creates Capital Call Lines for each Commitment
  - Updates Commitment totals
  - Handles errors (no commitments, zero unfunded, etc.)
- **Business Logic:**
  - Pro-rata = (Investor's Unfunded / Total Unfunded) × Capital Call Amount
  - Ensures fairness and accuracy in capital requests

### Distribution Waterfall Logic
- **Apex Service:** `WaterfallCalculatorService.cls`
  - Implements 4-tier waterfall: Return of Capital, Preferred Return (8%), Catch-Up (20%), Carried Interest (20%)
  - Allocates distributions to investors based on waterfall hierarchy
  - Creates Distribution Lines for each Commitment

### Raise Funds - Create Commitment Flow
- **Flow:** `Raise_Funds_Create_Commitment`
  - Screen flow to create new Commitment for a Fund
  - Collects Fund, Investor, Commitment Amount
  - Auto-populates required fields: Commitment Date (today), Type (Initial), Status (Pending)
  - Ensures all required data is captured for new commitments

### Key Terms
- **Commitment:** Investor's legal agreement to invest a set amount in a Fund
- **Capital Call:** Request for a portion of committed capital
- **Pro Rata:** Proportional allocation based on each investor's share
- **Vintage Year:** Year a fund makes its first investment (used for benchmarking)

---

### Future Updates:
All new components, triggers, controllers, and validations will be added to this documentation.