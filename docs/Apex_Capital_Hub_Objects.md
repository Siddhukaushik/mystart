# Apex Capital Hub - Object & Field Documentation

**Version:** 1.0  
**Last Updated:** December 20, 2025  
**Project:** Private Equity Fund Administration Platform

---

## Table of Contents

1. [SK_ACH_Fund__c - Fund](#1-sk_ach_fund__c---fund)
2. [SK_ACH_Investor__c - Investor](#2-sk_ach_investor__c---investor)
3. [SK_ACH_Commitment__c - Commitment](#3-sk_ach_commitment__c---commitment)
4. [SK_ACH_Capital_Call__c - Capital Call](#4-sk_ach_capital_call__c---capital-call)
5. [SK_ACH_Capital_Call_Line__c - Capital Call Line](#5-sk_ach_capital_call_line__c---capital-call-line)
6. [SK_ACH_Distribution__c - Distribution](#6-sk_ach_distribution__c---distribution)
7. [SK_ACH_Distribution_Line__c - Distribution Line](#7-sk_ach_distribution_line__c---distribution-line)
8. [SK_ACH_Investment__c - Investment](#8-sk_ach_investment__c---investment)
9. [SK_ACH_Valuation__c - Valuation](#9-sk_ach_valuation__c---valuation)

---

## 1. SK_ACH_Fund__c - Fund

### Object Purpose
Represents a Private Equity fund entity that pools capital from multiple investors (Limited Partners) to make investments in portfolio companies.

### Standard Fields
| Field Label | API Name | Type | Required | Description |
|-------------|----------|------|----------|-------------|
| Fund Name | Name | Text(80) | Yes | Name of the fund (e.g., "Apex Growth Fund") |
| Owner | OwnerId | Lookup(User) | Yes | Fund manager or team member responsible |
| Created By | CreatedById | Lookup(User) | Auto | User who created the record |
| Created Date | CreatedDate | DateTime | Auto | Date/time record was created |
| Last Modified By | LastModifiedById | Lookup(User) | Auto | User who last modified the record |
| Last Modified Date | LastModifiedDate | DateTime | Auto | Date/time record was last modified |

### Custom Fields

#### Core Fund Information

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Vintage Year | SK_ACH_Vintage_Year__c | Number | 4,0 | Yes | Year the fund was established | - |
| Fund Type | SK_ACH_Fund_Type__c | Picklist | - | Yes | Type of fund | Values: Buyout, Growth Equity, Venture Capital, Real Estate, Infrastructure, Fund of Funds |
| Status | SK_ACH_Status__c | Picklist | - | Yes | Current fund status | Values: Fundraising, Active, Harvesting, Closed; Default: Fundraising |
| Legal Entity Name | SK_ACH_Legal_Entity_Name__c | Text | 255 | No | Full legal name of fund entity | - |
| Fund Domicile | SK_ACH_Fund_Domicile__c | Picklist | - | No | Legal jurisdiction | Values: Delaware, Cayman Islands, Luxembourg, Ireland, Other |

#### Financial Metrics

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Target Fund Size | SK_ACH_Target_Fund_Size__c | Currency | 16,2 | Yes | Target capital to raise | - |
| Total Commitments | SK_ACH_Total_Commitments__c | Currency | 16,2 | No | Sum of all investor commitments | Rollup Summary (SUM Commitment.Amount) |
| Total Called Capital | SK_ACH_Total_Called_Capital__c | Currency | 16,2 | No | Total capital drawn from investors | Rollup Summary (SUM Capital Call Line.Amount WHERE Status = 'Paid') |
| Total Unfunded | SK_ACH_Total_Unfunded__c | Currency | 16,2 | No | Remaining callable capital | Formula: Total_Commitments__c - Total_Called_Capital__c |
| Management Fee (%) | SK_ACH_Management_Fee_Percent__c | Percent | 5,2 | Yes | Annual management fee rate | Default: 2.00% |
| Carried Interest (%) | SK_ACH_Carried_Interest_Percent__c | Percent | 5,2 | Yes | GP profit share after hurdle | Default: 20.00% |
| Hurdle Rate (%) | SK_ACH_Hurdle_Rate_Percent__c | Percent | 5,2 | Yes | Preferred return threshold | Default: 8.00% |

#### Investment Period

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Investment Period Start | SK_ACH_Investment_Period_Start__c | Date | - | No | When fund can start investing | - |
| Investment Period End | SK_ACH_Investment_Period_End__c | Date | - | No | Last date for new investments | - |
| Fund Term (Years) | SK_ACH_Fund_Term_Years__c | Number | 2,0 | Yes | Total fund life in years | Default: 10 |
| Final Liquidation Date | SK_ACH_Final_Liquidation_Date__c | Date | - | No | Expected fund closure date | - |

#### Performance Metrics (Formulas)

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Deployment Rate (%) | SK_ACH_Deployment_Rate__c | Percent | 5,2 | No | Percentage of commitments called | Formula: (Total_Called_Capital__c / Total_Commitments__c) * 100 |
| Commitment Fill Rate (%) | SK_ACH_Commitment_Fill_Rate__c | Percent | 5,2 | No | Percentage of target achieved | Formula: (Total_Commitments__c / Target_Fund_Size__c) * 100 |

#### Administrative

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| General Partner | SK_ACH_General_Partner__c | Text | 255 | No | Name of GP entity | - |
| Fund Administrator | SK_ACH_Fund_Administrator__c | Text | 255 | No | Third-party administrator name | - |
| Auditor | SK_ACH_Auditor__c | Text | 255 | No | Audit firm | - |
| Description | SK_ACH_Description__c | Long Text Area | 32768 | No | Fund strategy and notes | - |

### Page Layouts

#### Fund Manager Layout
- **Header:** Fund Name, Status, Vintage Year
- **Section 1 - Fund Overview:** Fund Type, Legal Entity Name, Fund Domicile, General Partner
- **Section 2 - Financial Structure:** Target Fund Size, Management Fee (%), Carried Interest (%), Hurdle Rate (%)
- **Section 3 - Commitment Summary:** Total Commitments, Total Called Capital, Total Unfunded, Deployment Rate (%), Commitment Fill Rate (%)
- **Section 4 - Investment Period:** Investment Period Start, Investment Period End, Fund Term (Years), Final Liquidation Date
- **Section 5 - Administration:** Fund Administrator, Auditor, Description
- **Related Lists:** Commitments, Investments, Capital Calls, Distributions

### List Views

| View Name | Filter Criteria | Columns |
|-----------|-----------------|---------|
| All Funds | None | Fund Name, Vintage Year, Fund Type, Status, Total Commitments, Deployment Rate (%) |
| Active Funds | Status = Active | Fund Name, Vintage Year, Total Commitments, Total Called Capital, Total Unfunded |
| Fundraising | Status = Fundraising | Fund Name, Vintage Year, Target Fund Size, Total Commitments, Commitment Fill Rate (%) |
| My Funds | Owner = Current User | Fund Name, Status, Total Commitments, Total Called Capital |

### Validation Rules

| Rule Name | Formula | Error Message | Error Location |
|-----------|---------|---------------|----------------|
| Investment_Period_End_After_Start | Investment_Period_End__c < Investment_Period_Start__c | Investment Period End must be after Investment Period Start | SK_ACH_Investment_Period_End__c |
| Management_Fee_Range | Management_Fee_Percent__c < 0 \|\| Management_Fee_Percent__c > 5 | Management Fee must be between 0% and 5% | SK_ACH_Management_Fee_Percent__c |
| Carried_Interest_Range | Carried_Interest_Percent__c < 0 \|\| Carried_Interest_Percent__c > 30 | Carried Interest must be between 0% and 30% | SK_ACH_Carried_Interest_Percent__c |

### Record Types
- **Standard Fund** (Default)

### Deployment Steps

1. Create custom fields in metadata
2. Create rollup summary fields (requires child object fields first)
3. Create page layout
4. Create list views
5. Create validation rules
6. Deploy to org
7. Test with sample data

---

## 2. SK_ACH_Investor__c - Investor

### Object Purpose
Represents Limited Partners (LPs) who invest capital in private equity funds. Tracks investor information, contact details, and regulatory compliance.

### Standard Fields
| Field Label | API Name | Type | Required | Description |
|-------------|----------|------|----------|-------------|
| Investor Name | Name | Text(80) | Yes | Name of the LP (e.g., "CalPERS", "Yale Endowment") |
| Owner | OwnerId | Lookup(User) | Yes | Investor Relations team member responsible |
| Created By | CreatedById | Lookup(User) | Auto | User who created the record |
| Created Date | CreatedDate | DateTime | Auto | Date/time record was created |
| Last Modified By | LastModifiedById | Lookup(User) | Auto | User who last modified the record |
| Last Modified Date | LastModifiedDate | DateTime | Auto | Date/time record was last modified |

### Custom Fields

#### Core Investor Information

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Investor Type | SK_ACH_Investor_Type__c | Picklist | - | Yes | Category of investor | Values: Pension Fund, Endowment, Foundation, Family Office, Insurance Company, Sovereign Wealth Fund, Fund of Funds, Corporate, Individual, Other |
| Legal Entity Type | SK_ACH_Legal_Entity_Type__c | Picklist | - | No | Legal structure | Values: Corporation, LLC, Partnership, Trust, Individual, Other |
| Country | SK_ACH_Country__c | Picklist | - | Yes | Country of domicile | Values: United States, United Kingdom, Canada, Germany, France, Switzerland, Singapore, Australia, Other |
| Status | SK_ACH_Investor_Status__c | Picklist | - | Yes | Current investor status | Values: Prospect, Active, Inactive, Restricted; Default: Prospect |

#### Contact Information

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Primary Contact Name | SK_ACH_Primary_Contact_Name__c | Text | 255 | No | Main point of contact | - |
| Email | SK_ACH_Email__c | Email | - | No | Primary email address | - |
| Phone | SK_ACH_Phone__c | Phone | - | No | Primary phone number | - |
| Mailing Address | SK_ACH_Mailing_Address__c | Text Area | - | No | Full mailing address | - |

#### Tax & Compliance

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Tax ID Number | SK_ACH_Tax_ID_Number__c | Text | 50 | No | Tax identification number (EIN/SSN) | - |
| Tax Status | SK_ACH_Tax_Status__c | Picklist | - | No | Tax classification | Values: Tax-Exempt, Taxable Domestic, Taxable Foreign, UBTI Subject, Other |
| Accreditation Status | SK_ACH_Accreditation_Status__c | Picklist | - | Yes | Investor accreditation | Values: Accredited, Qualified Purchaser, Institutional, Not Accredited; Default: Accredited |
| Accreditation Date | SK_ACH_Accreditation_Date__c | Date | - | No | Date accreditation verified | - |
| KYC Completed Date | SK_ACH_KYC_Completed_Date__c | Date | - | No | Know Your Customer completion date | - |
| AML Verified Date | SK_ACH_AML_Verified_Date__c | Date | - | No | Anti-Money Laundering verification date | - |

#### Financial Summary (Rollup/Formula)

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Total Commitments | SK_ACH_Total_Commitments__c | Currency | 16,2 | No | Sum of all commitments across funds | Rollup Summary (SUM Commitment.Commitment_Amount__c) |
| Total Capital Called | SK_ACH_Total_Capital_Called__c | Currency | 16,2 | No | Total capital drawn from investor | Rollup Summary (SUM Capital Call Line.Amount WHERE Status = 'Paid') |
| Total Distributions | SK_ACH_Total_Distributions__c | Currency | 16,2 | No | Total distributions received | Rollup Summary (SUM Distribution Line.Amount WHERE Status = 'Paid') |
| Net Cash Flow | SK_ACH_Net_Cash_Flow__c | Currency | 16,2 | No | Distributions minus capital called | Formula: Total_Distributions__c - Total_Capital_Called__c |

#### Administrative

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Notes | SK_ACH_Notes__c | Long Text Area | 32768 | No | General notes and preferences | - |

### Page Layouts

#### Investor Relations Layout
- **Header:** Investor Name, Investor Type, Status, Country
- **Section 1 - Investor Details:** Legal Entity Type, Accreditation Status, Accreditation Date
- **Section 2 - Contact Information:** Primary Contact Name, Email, Phone, Mailing Address
- **Section 3 - Tax & Compliance:** Tax ID Number, Tax Status, KYC Completed Date, AML Verified Date
- **Section 4 - Financial Summary:** Total Commitments, Total Capital Called, Total Distributions, Net Cash Flow
- **Section 5 - Notes:** Notes
- **Related Lists:** Commitments, Capital Call Lines, Distribution Lines

### List Views

| View Name | Filter Criteria | Columns |
|-----------|-----------------|---------|
| All Investors | None | Investor Name, Investor Type, Status, Country, Total Commitments |
| Active Investors | Status = Active | Investor Name, Investor Type, Total Commitments, Total Capital Called, Total Distributions |
| Prospects | Status = Prospect | Investor Name, Investor Type, Country, Primary Contact Name, Email |
| My Investors | Owner = Current User | Investor Name, Status, Total Commitments, Primary Contact Name |

### Validation Rules

| Rule Name | Formula | Error Message | Error Location |
|-----------|---------|---------------|----------------|
| Tax_ID_Required_For_Active | ISPICKVAL(SK_ACH_Investor_Status__c, "Active") && ISBLANK(SK_ACH_Tax_ID_Number__c) | Tax ID Number is required for Active investors | SK_ACH_Tax_ID_Number__c |
| Email_Required_For_Active | ISPICKVAL(SK_ACH_Investor_Status__c, "Active") && ISBLANK(SK_ACH_Email__c) | Email is required for Active investors | SK_ACH_Email__c |

---

## 3. SK_ACH_Commitment__c - Commitment

### Object Purpose
Tracks an LP's capital commitment to a specific fund. Represents the amount an investor pledges to contribute over the fund's life.

### Standard Fields
| Field Label | API Name | Type | Required | Description |
|-------------|----------|------|----------|-------------|
| Commitment Number | Name | AutoNumber | Yes | CMT-{0000} format |
| Owner | OwnerId | Lookup(User) | Yes | Fund manager responsible |
| Created By | CreatedById | Lookup(User) | Auto | User who created the record |
| Created Date | CreatedDate | DateTime | Auto | Date/time record was created |
| Last Modified By | LastModifiedById | Lookup(User) | Auto | User who last modified the record |
| Last Modified Date | LastModifiedDate | DateTime | Auto | Date/time record was last modified |

### Custom Fields

#### Relationships

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Fund | SK_ACH_Fund__c | Lookup(SK_ACH_Fund__c) | - | Yes | Fund this commitment is for | - |
| Investor | SK_ACH_Investor__c | Lookup(SK_ACH_Investor__c) | - | Yes | Investor making the commitment | - |

#### Commitment Details

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Commitment Amount | SK_ACH_Commitment_Amount__c | Currency | 16,2 | Yes | Total amount committed | - |
| Commitment Date | SK_ACH_Commitment_Date__c | Date | - | Yes | Date commitment was made | - |
| Commitment Type | SK_ACH_Commitment_Type__c | Picklist | - | Yes | Type of commitment | Values: Initial, Additional, Transfer, Reduction; Default: Initial |
| Status | SK_ACH_Commitment_Status__c | Picklist | - | Yes | Current status | Values: Pending, Executed, Cancelled; Default: Pending |

#### Financial Tracking (Rollup/Formula)

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Total Called | SK_ACH_Total_Called__c | Currency | 16,2 | No | Total capital called from this commitment | Rollup Summary (SUM Capital Call Line.Amount WHERE Commitment = THIS) |
| Total Paid | SK_ACH_Total_Paid__c | Currency | 16,2 | No | Total capital paid | Rollup Summary (SUM Capital Call Line.Amount WHERE Commitment = THIS AND Status = 'Paid') |
| Total Distributed | SK_ACH_Total_Distributed__c | Currency | 16,2 | No | Total distributions received | Rollup Summary (SUM Distribution Line.Amount WHERE Commitment = THIS AND Status = 'Paid') |
| Unfunded Balance | SK_ACH_Unfunded_Balance__c | Currency | 16,2 | No | Remaining callable capital | Formula: Commitment_Amount__c - Total_Called__c |
| Ownership Percentage | SK_ACH_Ownership_Percentage__c | Percent | 5,4 | No | % of fund owned | Formula: (Commitment_Amount__c / Fund__r.Total_Commitments__c) * 100 |

#### Administrative

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Subscription Agreement Signed | SK_ACH_Subscription_Agreement_Signed__c | Checkbox | - | No | Whether subscription docs signed | Default: False |
| Signature Date | SK_ACH_Signature_Date__c | Date | - | No | Date subscription was signed | - |
| Notes | SK_ACH_Commitment_Notes__c | Long Text Area | 32768 | No | Special terms or notes | - |

### Page Layouts

#### Commitment Layout
- **Header:** Commitment Number, Status, Commitment Amount, Unfunded Balance
- **Section 1 - Related Records:** Fund, Investor
- **Section 2 - Commitment Details:** Commitment Date, Commitment Type, Ownership Percentage
- **Section 3 - Financial Summary:** Total Called, Total Paid, Total Distributed
- **Section 4 - Documentation:** Subscription Agreement Signed, Signature Date, Notes
- **Related Lists:** Capital Call Lines, Distribution Lines

### List Views

| View Name | Filter Criteria | Columns |
|-----------|-----------------|---------|
| All Commitments | None | Commitment Number, Fund, Investor, Commitment Amount, Unfunded Balance, Status |
| Executed Commitments | Status = Executed | Commitment Number, Fund, Investor, Commitment Amount, Total Called, Unfunded Balance |
| Pending Signature | Subscription Agreement Signed = False AND Status = Pending | Commitment Number, Fund, Investor, Commitment Amount, Commitment Date |
| My Commitments | Owner = Current User | Commitment Number, Fund, Investor, Status, Commitment Amount |

### Validation Rules

| Rule Name | Formula | Error Message | Error Location |
|-----------|---------|---------------|----------------|
| Commitment_Amount_Positive | SK_ACH_Commitment_Amount__c <= 0 | Commitment Amount must be greater than zero | SK_ACH_Commitment_Amount__c |
| Signature_Date_With_Agreement | SK_ACH_Subscription_Agreement_Signed__c = true && ISBLANK(SK_ACH_Signature_Date__c) | Signature Date is required when Subscription Agreement is signed | SK_ACH_Signature_Date__c |

---

## 4. SK_ACH_Capital_Call__c - Capital Call

### Object Purpose
Represents a drawdown request sent to investors to fund investments or pay expenses. A capital call contains multiple lines (one per investor commitment).

### Standard Fields
| Field Label | API Name | Type | Required | Description |
|-------------|----------|------|----------|-------------|
| Capital Call Number | Name | AutoNumber | Yes | CC-{0000} format |
| Owner | OwnerId | Lookup(User) | Yes | Fund manager responsible |
| Created By | CreatedById | Lookup(User) | Auto | User who created the record |
| Created Date | CreatedDate | DateTime | Auto | Date/time record was created |
| Last Modified By | LastModifiedById | Lookup(User) | Auto | User who last modified the record |
| Last Modified Date | LastModifiedDate | DateTime | Auto | Date/time record was last modified |

### Custom Fields

#### Relationships

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Fund | SK_ACH_Fund__c | Lookup(SK_ACH_Fund__c) | - | Yes | Fund issuing the capital call | - |

#### Capital Call Details

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Call Date | SK_ACH_Call_Date__c | Date | - | Yes | Date capital call is issued | Default: TODAY() |
| Due Date | SK_ACH_Due_Date__c | Date | - | Yes | Date payment is due | - |
| Total Amount | SK_ACH_Total_Amount__c | Currency | 16,2 | Yes | Total capital being called | - |
| Purpose | SK_ACH_Purpose__c | Picklist | - | Yes | Reason for capital call | Values: Investment, Management Fees, Operating Expenses, Follow-on Investment, Other |
| Status | SK_ACH_Capital_Call_Status__c | Picklist | - | Yes | Current status | Values: Draft, Issued, Partially Paid, Fully Paid, Overdue; Default: Draft |

#### Financial Summary (Rollup)

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Total Paid | SK_ACH_Total_Paid__c | Currency | 16,2 | No | Amount received from investors | Rollup Summary (SUM Capital Call Line.Amount WHERE Status = 'Paid') |
| Total Outstanding | SK_ACH_Total_Outstanding__c | Currency | 16,2 | No | Amount still unpaid | Formula: Total_Amount__c - Total_Paid__c |
| Payment Completion (%) | SK_ACH_Payment_Completion__c | Percent | 5,2 | No | Percentage of payments received | Formula: (Total_Paid__c / Total_Amount__c) * 100 |

#### Administrative

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Notice Sent Date | SK_ACH_Notice_Sent_Date__c | Date | - | No | When notice was sent to investors | - |
| Wire Instructions | SK_ACH_Wire_Instructions__c | Long Text Area | 32768 | No | Bank details for payment | - |
| Notes | SK_ACH_Capital_Call_Notes__c | Long Text Area | 32768 | No | Additional details | - |

### Page Layouts

#### Capital Call Layout
- **Header:** Capital Call Number, Status, Total Amount, Total Paid, Total Outstanding
- **Section 1 - Capital Call Details:** Fund, Call Date, Due Date, Purpose
- **Section 2 - Payment Progress:** Payment Completion (%), Notice Sent Date
- **Section 3 - Payment Instructions:** Wire Instructions
- **Section 4 - Notes:** Notes
- **Related Lists:** Capital Call Lines

### List Views

| View Name | Filter Criteria | Columns |
|-----------|-----------------|---------|
| All Capital Calls | None | Capital Call Number, Fund, Call Date, Due Date, Total Amount, Status |
| Issued Capital Calls | Status IN (Issued, Partially Paid) | Capital Call Number, Fund, Due Date, Total Amount, Total Paid, Total Outstanding |
| Overdue Capital Calls | Status = Overdue | Capital Call Number, Fund, Due Date, Total Amount, Total Outstanding |
| Recent Capital Calls | Created Date = LAST_90_DAYS | Capital Call Number, Fund, Call Date, Total Amount, Status |

### Validation Rules

| Rule Name | Formula | Error Message | Error Location |
|-----------|---------|---------------|----------------|
| Due_Date_After_Call_Date | SK_ACH_Due_Date__c < SK_ACH_Call_Date__c | Due Date must be after Call Date | SK_ACH_Due_Date__c |
| Total_Amount_Positive | SK_ACH_Total_Amount__c <= 0 | Total Amount must be greater than zero | SK_ACH_Total_Amount__c |
| Cannot_Edit_Issued_Call | ISCHANGED(SK_ACH_Total_Amount__c) && ISPICKVAL(PRIORVALUE(SK_ACH_Capital_Call_Status__c), "Issued") | Cannot change Total Amount after capital call is issued | SK_ACH_Total_Amount__c |

---

## 5. SK_ACH_Capital_Call_Line__c - Capital Call Line

### Object Purpose
Per-investor breakdown of a capital call. Each line represents one investor's portion of the total capital call, calculated pro-rata based on ownership percentage.

### Standard Fields
| Field Label | API Name | Type | Required | Description |
|-------------|----------|------|----------|-------------|
| Line Number | Name | AutoNumber | Yes | CCL-{0000} format |
| Owner | OwnerId | Lookup(User) | Yes | Inherited from parent Capital Call |
| Created By | CreatedById | Lookup(User) | Auto | User who created the record |
| Created Date | CreatedDate | DateTime | Auto | Date/time record was created |
| Last Modified By | LastModifiedById | Lookup(User) | Auto | User who last modified the record |
| Last Modified Date | LastModifiedDate | DateTime | Auto | Date/time record was last modified |

### Custom Fields

#### Relationships

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Capital Call | SK_ACH_Capital_Call__c | Master-Detail(SK_ACH_Capital_Call__c) | - | Yes | Parent capital call | - |
| Commitment | SK_ACH_Commitment__c | Lookup(SK_ACH_Commitment__c) | - | Yes | Investor commitment being drawn | - |
| Investor | SK_ACH_Investor__c | Formula(Lookup) | - | No | Investor for this line | Formula: Commitment__r.Investor__r.Name |

#### Line Details

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Amount | SK_ACH_Line_Amount__c | Currency | 16,2 | Yes | Amount called from this investor | - |
| Status | SK_ACH_Line_Status__c | Picklist | - | Yes | Payment status | Values: Pending, Paid, Partially Paid, Defaulted; Default: Pending |
| Due Date | SK_ACH_Line_Due_Date__c | Formula(Date) | - | No | Due date from parent capital call | Formula: Capital_Call__r.Due_Date__c |

#### Payment Tracking

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Payment Date | SK_ACH_Payment_Date__c | Date | - | No | Date payment was received | - |
| Payment Method | SK_ACH_Payment_Method__c | Picklist | - | No | How payment was received | Values: Wire Transfer, ACH, Check, Other |
| Payment Reference | SK_ACH_Payment_Reference__c | Text | 255 | No | Transaction ID or check number | - |
| Amount Paid | SK_ACH_Amount_Paid__c | Currency | 16,2 | No | Actual amount received | - |
| Amount Outstanding | SK_ACH_Amount_Outstanding__c | Currency | 16,2 | No | Remaining unpaid amount | Formula: Line_Amount__c - Amount_Paid__c |

#### Administrative

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Notes | SK_ACH_Line_Notes__c | Long Text Area | 32768 | No | Payment notes or issues | - |

### Page Layouts

#### Capital Call Line Layout
- **Header:** Line Number, Status, Amount, Amount Paid, Amount Outstanding
- **Section 1 - Related Records:** Capital Call, Commitment, Investor (formula)
- **Section 2 - Payment Details:** Due Date (formula), Payment Date, Payment Method, Payment Reference
- **Section 3 - Notes:** Notes

### List Views

| View Name | Filter Criteria | Columns |
|-----------|-----------------|---------|
| All Lines | None | Line Number, Capital Call, Investor (formula), Amount, Status |
| Pending Payments | Status = Pending | Line Number, Capital Call, Investor (formula), Amount, Due Date (formula) |
| Paid Lines | Status = Paid | Line Number, Capital Call, Investor (formula), Amount, Payment Date |
| Overdue Lines | Status = Pending AND Due Date (formula) < TODAY | Line Number, Capital Call, Investor (formula), Amount, Due Date (formula) |

### Validation Rules

| Rule Name | Formula | Error Message | Error Location |
|-----------|---------|---------------|----------------|
| Amount_Positive | SK_ACH_Line_Amount__c <= 0 | Amount must be greater than zero | SK_ACH_Line_Amount__c |
| Payment_Date_Required_When_Paid | ISPICKVAL(SK_ACH_Line_Status__c, "Paid") && ISBLANK(SK_ACH_Payment_Date__c) | Payment Date is required when Status is Paid | SK_ACH_Payment_Date__c |
| Amount_Paid_Cannot_Exceed_Amount | SK_ACH_Amount_Paid__c > SK_ACH_Line_Amount__c | Amount Paid cannot exceed Line Amount | SK_ACH_Amount_Paid__c |

### Notes
- **Sharing Model:** Controlled by Parent (Master-Detail to Capital Call)
- **Rollup Impact:** This object's Amount field rolls up to Capital Call's Total Paid field

---

## 6. SK_ACH_Distribution__c - Distribution

### Object Purpose
Represents profit or principal distributions paid to investors. Contains multiple lines (one per investor commitment) following waterfall logic.

### Standard Fields
| Field Label | API Name | Type | Required | Description |
|-------------|----------|------|----------|-------------|
| Distribution Number | Name | AutoNumber | Yes | DST-{0000} format |
| Owner | OwnerId | Lookup(User) | Yes | Fund manager responsible |
| Created By | CreatedById | Lookup(User) | Auto | User who created the record |
| Created Date | CreatedDate | DateTime | Auto | Date/time record was created |
| Last Modified By | LastModifiedById | Lookup(User) | Auto | User who last modified the record |
| Last Modified Date | LastModifiedDate | DateTime | Auto | Date/time record was last modified |

### Custom Fields

#### Relationships

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Fund | SK_ACH_Fund__c | Lookup(SK_ACH_Fund__c) | - | Yes | Fund making the distribution | - |

#### Distribution Details

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Distribution Date | SK_ACH_Distribution_Date__c | Date | - | Yes | Date distribution is paid | Default: TODAY() |
| Distribution Type | SK_ACH_Distribution_Type__c | Picklist | - | Yes | Type of distribution | Values: Return of Capital, Preferred Return, Profit Distribution, Special Distribution, Liquidating Distribution |
| Total Amount | SK_ACH_Distribution_Total_Amount__c | Currency | 16,2 | Yes | Total amount being distributed | - |
| Source Investment | SK_ACH_Source_Investment__c | Lookup(SK_ACH_Investment__c) | - | No | Investment that generated proceeds | - |
| Status | SK_ACH_Distribution_Status__c | Picklist | - | Yes | Current status | Values: Draft, Approved, Paid, Cancelled; Default: Draft |

#### Financial Summary (Rollup)

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Total Paid to LPs | SK_ACH_Total_Paid_to_LPs__c | Currency | 16,2 | No | Amount paid to Limited Partners | Rollup Summary (SUM Distribution Line.Amount WHERE Status = 'Paid' AND Recipient Type = 'LP') |
| Total Paid to GP | SK_ACH_Total_Paid_to_GP__c | Currency | 16,2 | No | Carried interest paid to GP | Rollup Summary (SUM Distribution Line.Amount WHERE Status = 'Paid' AND Recipient Type = 'GP') |
| Payment Completion (%) | SK_ACH_Distribution_Payment_Completion__c | Percent | 5,2 | No | Percentage of payments completed | Formula: ((Total_Paid_to_LPs__c + Total_Paid_to_GP__c) / Distribution_Total_Amount__c) * 100 |

#### Waterfall Calculation

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Return of Capital Amount | SK_ACH_Return_of_Capital_Amount__c | Currency | 16,2 | No | Portion allocated to return of capital | - |
| Preferred Return Amount | SK_ACH_Preferred_Return_Amount__c | Currency | 16,2 | No | Portion allocated to preferred return | - |
| GP Catch-Up Amount | SK_ACH_GP_Catch_Up_Amount__c | Currency | 16,2 | No | GP catch-up amount | - |
| Carried Interest Amount | SK_ACH_Carried_Interest_Amount__c | Currency | 16,2 | No | Carried interest to GP | - |

#### Administrative

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Approved By | SK_ACH_Approved_By__c | Lookup(User) | - | No | User who approved distribution | - |
| Approval Date | SK_ACH_Approval_Date__c | Date | - | No | Date distribution was approved | - |
| Notes | SK_ACH_Distribution_Notes__c | Long Text Area | 32768 | No | Distribution details and notes | - |

### Page Layouts

#### Distribution Layout
- **Header:** Distribution Number, Status, Total Amount, Distribution Date
- **Section 1 - Distribution Details:** Fund, Distribution Type, Source Investment
- **Section 2 - Waterfall Breakdown:** Return of Capital Amount, Preferred Return Amount, GP Catch-Up Amount, Carried Interest Amount
- **Section 3 - Payment Summary:** Total Paid to LPs, Total Paid to GP, Payment Completion (%)
- **Section 4 - Approval:** Approved By, Approval Date
- **Section 5 - Notes:** Notes
- **Related Lists:** Distribution Lines

### List Views

| View Name | Filter Criteria | Columns |
|-----------|-----------------|---------|
| All Distributions | None | Distribution Number, Fund, Distribution Date, Distribution Type, Total Amount, Status |
| Paid Distributions | Status = Paid | Distribution Number, Fund, Distribution Date, Total Amount, Total Paid to LPs, Total Paid to GP |
| Pending Approval | Status = Draft | Distribution Number, Fund, Distribution Date, Total Amount, Distribution Type |
| Recent Distributions | Distribution Date = LAST_90_DAYS | Distribution Number, Fund, Distribution Date, Total Amount, Status |

### Validation Rules

| Rule Name | Formula | Error Message | Error Location |
|-----------|---------|---------------|----------------|
| Total_Amount_Positive | SK_ACH_Distribution_Total_Amount__c <= 0 | Total Amount must be greater than zero | SK_ACH_Distribution_Total_Amount__c |
| Approval_Required_For_Paid | ISPICKVAL(SK_ACH_Distribution_Status__c, "Paid") && ISBLANK(SK_ACH_Approved_By__c) | Distribution must be approved before Status can be set to Paid | SK_ACH_Distribution_Status__c |
| Waterfall_Sum_Matches_Total | (SK_ACH_Return_of_Capital_Amount__c + SK_ACH_Preferred_Return_Amount__c + SK_ACH_GP_Catch_Up_Amount__c + SK_ACH_Carried_Interest_Amount__c) <> SK_ACH_Distribution_Total_Amount__c | Waterfall amounts must sum to Total Amount | SK_ACH_Distribution_Total_Amount__c |

---

## 7. SK_ACH_Distribution_Line__c - Distribution Line

### Object Purpose
Per-investor breakdown of a distribution. Each line represents one investor's portion of the distribution, calculated based on ownership percentage and waterfall logic.

### Standard Fields
| Field Label | API Name | Type | Required | Description |
|-------------|----------|------|----------|-------------|
| Line Number | Name | AutoNumber | Yes | DL-{0000} format |
| Owner | OwnerId | Lookup(User) | Yes | Inherited from parent Distribution |
| Created By | CreatedById | Lookup(User) | Auto | User who created the record |
| Created Date | CreatedDate | DateTime | Auto | Date/time record was created |
| Last Modified By | LastModifiedById | Lookup(User) | Auto | User who last modified the record |
| Last Modified Date | LastModifiedDate | DateTime | Auto | Date/time record was last modified |

### Custom Fields

#### Relationships

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Distribution | SK_ACH_Distribution__c | Master-Detail(SK_ACH_Distribution__c) | - | Yes | Parent distribution | - |
| Commitment | SK_ACH_Commitment__c | Lookup(SK_ACH_Commitment__c) | - | No | Investor commitment (for LP distributions) | - |
| Investor | SK_ACH_Line_Investor__c | Formula(Lookup) | - | No | Investor for this line | Formula: Commitment__r.Investor__r.Name |
| Recipient Type | SK_ACH_Recipient_Type__c | Picklist | - | Yes | Who receives this distribution | Values: LP, GP; Default: LP |

#### Line Details

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Amount | SK_ACH_Distribution_Line_Amount__c | Currency | 16,2 | Yes | Amount distributed to this recipient | - |
| Distribution Date | SK_ACH_Line_Distribution_Date__c | Formula(Date) | - | No | Date from parent distribution | Formula: Distribution__r.Distribution_Date__c |
| Status | SK_ACH_Distribution_Line_Status__c | Picklist | - | Yes | Payment status | Values: Pending, Paid, Cancelled; Default: Pending |

#### Payment Tracking

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Payment Date | SK_ACH_Line_Payment_Date__c | Date | - | No | Date payment was sent | - |
| Payment Method | SK_ACH_Line_Payment_Method__c | Picklist | - | No | How payment was sent | Values: Wire Transfer, ACH, Check, Other |
| Payment Reference | SK_ACH_Line_Payment_Reference__c | Text | 255 | No | Transaction ID or check number | - |

#### Waterfall Breakdown (for LP lines)

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Return of Capital | SK_ACH_Line_Return_of_Capital__c | Currency | 16,2 | No | Portion that is return of capital | - |
| Preferred Return | SK_ACH_Line_Preferred_Return__c | Currency | 16,2 | No | Portion that is preferred return | - |
| Profit Distribution | SK_ACH_Line_Profit_Distribution__c | Currency | 16,2 | No | Portion that is profit distribution | - |

#### Tax Reporting

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Tax Year | SK_ACH_Tax_Year__c | Number | 4,0 | No | Tax year for reporting | Formula: YEAR(Line_Distribution_Date__c) |
| 1099 Issued | SK_ACH_1099_Issued__c | Checkbox | - | No | Whether 1099 has been issued | Default: False |

#### Administrative

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Notes | SK_ACH_Distribution_Line_Notes__c | Long Text Area | 32768 | No | Payment notes | - |

### Page Layouts

#### Distribution Line Layout
- **Header:** Line Number, Status, Amount, Recipient Type
- **Section 1 - Related Records:** Distribution, Commitment, Investor (formula)
- **Section 2 - Payment Details:** Distribution Date (formula), Payment Date, Payment Method, Payment Reference
- **Section 3 - Waterfall Breakdown:** Return of Capital, Preferred Return, Profit Distribution
- **Section 4 - Tax Information:** Tax Year, 1099 Issued
- **Section 5 - Notes:** Notes

### List Views

| View Name | Filter Criteria | Columns |
|-----------|-----------------|---------|
| All Distribution Lines | None | Line Number, Distribution, Investor (formula), Recipient Type, Amount, Status |
| LP Distributions | Recipient Type = LP | Line Number, Distribution, Investor (formula), Amount, Payment Date |
| GP Distributions (Carry) | Recipient Type = GP | Line Number, Distribution, Amount, Payment Date, Status |
| Pending Payments | Status = Pending | Line Number, Distribution, Investor (formula), Amount, Distribution Date (formula) |
| Tax Reporting | 1099 Issued = False AND Status = Paid | Line Number, Investor (formula), Amount, Tax Year, Payment Date |

### Validation Rules

| Rule Name | Formula | Error Message | Error Location |
|-----------|---------|---------------|----------------|
| Amount_Positive | SK_ACH_Distribution_Line_Amount__c <= 0 | Amount must be greater than zero | SK_ACH_Distribution_Line_Amount__c |
| Commitment_Required_For_LP | ISPICKVAL(SK_ACH_Recipient_Type__c, "LP") && ISBLANK(SK_ACH_Commitment__c) | Commitment is required for LP distributions | SK_ACH_Commitment__c |
| Waterfall_Sum_Matches_Amount | ISPICKVAL(SK_ACH_Recipient_Type__c, "LP") && (SK_ACH_Line_Return_of_Capital__c + SK_ACH_Line_Preferred_Return__c + SK_ACH_Line_Profit_Distribution__c) <> SK_ACH_Distribution_Line_Amount__c | Waterfall breakdown must sum to Line Amount | SK_ACH_Distribution_Line_Amount__c |

### Notes
- **Sharing Model:** Controlled by Parent (Master-Detail to Distribution)
- **Rollup Impact:** This object's Amount field rolls up to Distribution's Total Paid to LPs and Total Paid to GP fields

---

## 8. SK_ACH_Investment__c - Investment

### Object Purpose
Tracks portfolio company investments made by the fund. Records investment details, performance metrics, and exit information.

### Standard Fields
| Field Label | API Name | Type | Required | Description |
|-------------|----------|------|----------|-------------|
| Investment Name | Name | Text(80) | Yes | Name of portfolio company (e.g., "Acme Corp") |
| Owner | OwnerId | Lookup(User) | Yes | Deal team member responsible |
| Created By | CreatedById | Lookup(User) | Auto | User who created the record |
| Created Date | CreatedDate | DateTime | Auto | Date/time record was created |
| Last Modified By | LastModifiedById | Lookup(User) | Auto | User who last modified the record |
| Last Modified Date | LastModifiedDate | DateTime | Auto | Date/time record was last modified |

### Custom Fields

#### Relationships

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Fund | SK_ACH_Investment_Fund__c | Lookup(SK_ACH_Fund__c) | - | Yes | Fund that made the investment | - |

#### Investment Details

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Company Legal Name | SK_ACH_Company_Legal_Name__c | Text | 255 | No | Full legal name of portfolio company | - |
| Industry | SK_ACH_Industry__c | Picklist | - | Yes | Industry sector | Values: Technology, Healthcare, Financial Services, Consumer Products, Industrial, Energy, Real Estate, Other |
| Investment Type | SK_ACH_Investment_Type__c | Picklist | - | Yes | Type of investment | Values: Growth Equity, Buyout, Venture Capital, Minority Stake, Majority Control, Recapitalization |
| Investment Date | SK_ACH_Investment_Date__c | Date | - | Yes | Date investment was made | - |
| Status | SK_ACH_Investment_Status__c | Picklist | - | Yes | Current status | Values: Active, Exited, Written Off, Under LOI; Default: Active |

#### Financial Metrics

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Initial Investment | SK_ACH_Initial_Investment__c | Currency | 16,2 | Yes | Initial capital deployed | - |
| Total Invested | SK_ACH_Total_Invested__c | Currency | 16,2 | No | Total capital including follow-ons | - |
| Equity Ownership (%) | SK_ACH_Equity_Ownership_Percent__c | Percent | 5,2 | No | Percentage of company owned | - |
| Entry Valuation | SK_ACH_Entry_Valuation__c | Currency | 16,2 | No | Company valuation at investment | - |

#### Performance Metrics (Rollup/Formula)

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Current Fair Value | SK_ACH_Current_Fair_Value__c | Currency | 16,2 | No | Latest valuation amount | Rollup Summary (MAX Valuation.Fair_Value__c) |
| Unrealized Gain/Loss | SK_ACH_Unrealized_Gain_Loss__c | Currency | 16,2 | No | Current value minus cost | Formula: Current_Fair_Value__c - Total_Invested__c |
| Total Distributions Received | SK_ACH_Total_Distributions_Received__c | Currency | 16,2 | No | Distributions from this investment | Rollup Summary (SUM Distribution.Total_Amount__c WHERE Source_Investment = THIS) |
| Total Value | SK_ACH_Total_Value__c | Currency | 16,2 | No | Current value plus distributions | Formula: Current_Fair_Value__c + Total_Distributions_Received__c |
| MOIC (Multiple) | SK_ACH_MOIC__c | Number | 5,2 | No | Multiple on Invested Capital | Formula: Total_Value__c / Total_Invested__c |

#### Exit Information

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Exit Date | SK_ACH_Exit_Date__c | Date | - | No | Date of exit/sale | - |
| Exit Type | SK_ACH_Exit_Type__c | Picklist | - | No | Type of exit | Values: IPO, Strategic Sale, Secondary Sale, Buyback, Write-Off, Other |
| Exit Valuation | SK_ACH_Exit_Valuation__c | Currency | 16,2 | No | Final exit proceeds | - |
| Realized Gain/Loss | SK_ACH_Realized_Gain_Loss__c | Currency | 16,2 | No | Exit proceeds minus cost | Formula: Exit_Valuation__c - Total_Invested__c |

#### Administrative

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Board Representation | SK_ACH_Board_Representation__c | Checkbox | - | No | Whether fund has board seat | Default: False |
| Investment Thesis | SK_ACH_Investment_Thesis__c | Long Text Area | 32768 | No | Rationale for investment | - |
| Website | SK_ACH_Website__c | URL | - | No | Company website | - |
| Notes | SK_ACH_Investment_Notes__c | Long Text Area | 32768 | No | Additional notes | - |

### Page Layouts

#### Investment Layout
- **Header:** Investment Name, Status, Industry, Investment Date
- **Section 1 - Investment Details:** Fund, Company Legal Name, Investment Type, Equity Ownership (%)
- **Section 2 - Financial Metrics:** Initial Investment, Total Invested, Entry Valuation
- **Section 3 - Performance:** Current Fair Value, Unrealized Gain/Loss, Total Distributions Received, Total Value, MOIC
- **Section 4 - Exit Information:** Exit Date, Exit Type, Exit Valuation, Realized Gain/Loss
- **Section 5 - Administrative:** Board Representation, Investment Thesis, Website, Notes
- **Related Lists:** Valuations, Distributions

### List Views

| View Name | Filter Criteria | Columns |
|-----------|-----------------|---------|
| All Investments | None | Investment Name, Fund, Industry, Investment Date, Total Invested, Current Fair Value, Status |
| Active Investments | Status = Active | Investment Name, Fund, Industry, Total Invested, Current Fair Value, MOIC |
| Exited Investments | Status = Exited | Investment Name, Fund, Exit Date, Exit Type, Total Invested, Exit Valuation, Realized Gain/Loss |
| Top Performers | Status = Active AND MOIC > 2.0 | Investment Name, Fund, Total Invested, Total Value, MOIC, Unrealized Gain/Loss |
| Recent Investments | Investment Date = LAST_180_DAYS | Investment Name, Fund, Investment Date, Total Invested, Industry |

### Validation Rules

| Rule Name | Formula | Error Message | Error Location |
|-----------|---------|---------------|----------------|
| Initial_Investment_Positive | SK_ACH_Initial_Investment__c <= 0 | Initial Investment must be greater than zero | SK_ACH_Initial_Investment__c |
| Exit_Date_Required_For_Exited | ISPICKVAL(SK_ACH_Investment_Status__c, "Exited") && ISBLANK(SK_ACH_Exit_Date__c) | Exit Date is required when Status is Exited | SK_ACH_Exit_Date__c |
| Exit_Date_After_Investment_Date | SK_ACH_Exit_Date__c < SK_ACH_Investment_Date__c | Exit Date must be after Investment Date | SK_ACH_Exit_Date__c |

---

## 9. SK_ACH_Valuation__c - Valuation

### Object Purpose
Periodic valuation of portfolio investments. Tracks fair value assessments over time for NAV calculations and investor reporting.

### Standard Fields
| Field Label | API Name | Type | Required | Description |
|-------------|----------|------|----------|-------------|
| Valuation Number | Name | AutoNumber | Yes | VAL-{0000} format |
| Owner | OwnerId | Lookup(User) | Yes | Valuation analyst responsible |
| Created By | CreatedById | Lookup(User) | Auto | User who created the record |
| Created Date | CreatedDate | DateTime | Auto | Date/time record was created |
| Last Modified By | LastModifiedById | Lookup(User) | Auto | User who last modified the record |
| Last Modified Date | LastModifiedDate | DateTime | Auto | Date/time record was last modified |

### Custom Fields

#### Relationships

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Investment | SK_ACH_Valuation_Investment__c | Master-Detail(SK_ACH_Investment__c) | - | Yes | Investment being valued | - |
| Fund | SK_ACH_Valuation_Fund__c | Formula(Lookup) | - | No | Fund that owns the investment | Formula: Valuation_Investment__r.Investment_Fund__r.Name |

#### Valuation Details

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Valuation Date | SK_ACH_Valuation_Date__c | Date | - | Yes | As-of date for valuation | Default: TODAY() |
| Fair Value | SK_ACH_Fair_Value__c | Currency | 16,2 | Yes | Assessed fair value | - |
| Valuation Method | SK_ACH_Valuation_Method__c | Picklist | - | Yes | Methodology used | Values: Market Comparable, Discounted Cash Flow, Recent Transaction, Cost Basis, Liquidation Value, Other |
| Valuation Type | SK_ACH_Valuation_Type__c | Picklist | - | Yes | Type of valuation | Values: Quarterly, Annual, Event-Driven, Audit, Other; Default: Quarterly |

#### Performance Metrics (Formula)

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Cost Basis | SK_ACH_Cost_Basis__c | Formula(Currency) | 16,2 | No | Total invested in this investment | Formula: Valuation_Investment__r.Total_Invested__c |
| Unrealized Gain/Loss | SK_ACH_Valuation_Unrealized_Gain_Loss__c | Currency | 16,2 | No | Fair value minus cost basis | Formula: Fair_Value__c - Cost_Basis__c |
| Unrealized Gain/Loss (%) | SK_ACH_Unrealized_Gain_Loss_Percent__c | Percent | 5,2 | No | Percentage return on cost | Formula: ((Fair_Value__c - Cost_Basis__c) / Cost_Basis__c) * 100 |

#### Valuation Assumptions

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Revenue (LTM) | SK_ACH_Revenue_LTM__c | Currency | 16,2 | No | Last Twelve Months revenue | - |
| EBITDA (LTM) | SK_ACH_EBITDA_LTM__c | Currency | 16,2 | No | Last Twelve Months EBITDA | - |
| Enterprise Value | SK_ACH_Enterprise_Value__c | Currency | 16,2 | No | Total enterprise value | - |
| EV/Revenue Multiple | SK_ACH_EV_Revenue_Multiple__c | Number | 5,2 | No | Valuation multiple | Formula: IF(Revenue_LTM__c > 0, Enterprise_Value__c / Revenue_LTM__c, null) |
| EV/EBITDA Multiple | SK_ACH_EV_EBITDA_Multiple__c | Number | 5,2 | No | Valuation multiple | Formula: IF(EBITDA_LTM__c > 0, Enterprise_Value__c / EBITDA_LTM__c, null) |
| Discount Rate (%) | SK_ACH_Discount_Rate__c | Percent | 5,2 | No | Discount rate used (for DCF) | - |

#### Review & Approval

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Status | SK_ACH_Valuation_Status__c | Picklist | - | Yes | Current status | Values: Draft, Under Review, Approved, Rejected; Default: Draft |
| Reviewed By | SK_ACH_Reviewed_By__c | Lookup(User) | - | No | User who reviewed valuation | - |
| Review Date | SK_ACH_Review_Date__c | Date | - | No | Date valuation was reviewed | - |
| Approved By | SK_ACH_Approved_By__c | Lookup(User) | - | No | User who approved valuation | - |
| Approval Date | SK_ACH_Approval_Date__c | Date | - | No | Date valuation was approved | - |

#### Administrative

| Field Label | API Name | Type | Length/Precision | Required | Description | Formula/Default |
|-------------|----------|------|------------------|----------|-------------|-----------------|
| Third-Party Valuation | SK_ACH_Third_Party_Valuation__c | Checkbox | - | No | Whether valued by 3rd party firm | Default: False |
| Valuation Firm | SK_ACH_Valuation_Firm__c | Text | 255 | No | Name of valuation firm (if applicable) | - |
| Valuation Notes | SK_ACH_Valuation_Notes__c | Long Text Area | 32768 | No | Key assumptions and notes | - |
| Supporting Documents | SK_ACH_Supporting_Documents__c | URL | - | No | Link to valuation documentation | - |

### Page Layouts

#### Valuation Layout
- **Header:** Valuation Number, Status, Valuation Date, Fair Value
- **Section 1 - Valuation Details:** Investment, Fund (formula), Valuation Method, Valuation Type
- **Section 2 - Performance:** Cost Basis (formula), Unrealized Gain/Loss, Unrealized Gain/Loss (%)
- **Section 3 - Financial Metrics:** Revenue (LTM), EBITDA (LTM), Enterprise Value, EV/Revenue Multiple, EV/EBITDA Multiple, Discount Rate (%)
- **Section 4 - Review & Approval:** Reviewed By, Review Date, Approved By, Approval Date
- **Section 5 - Additional Information:** Third-Party Valuation, Valuation Firm, Valuation Notes, Supporting Documents

### List Views

| View Name | Filter Criteria | Columns |
|-----------|-----------------|---------|
| All Valuations | None | Valuation Number, Investment, Valuation Date, Fair Value, Status |
| Approved Valuations | Status = Approved | Valuation Number, Investment, Valuation Date, Fair Value, Approved By, Approval Date |
| Pending Review | Status IN (Draft, Under Review) | Valuation Number, Investment, Valuation Date, Fair Value, Valuation Method |
| Quarterly Valuations | Valuation Type = Quarterly | Valuation Number, Investment, Valuation Date, Fair Value, Unrealized Gain/Loss (%) |
| Recent Valuations | Valuation Date = LAST_90_DAYS | Valuation Number, Investment, Valuation Date, Fair Value, Status |

### Validation Rules

| Rule Name | Formula | Error Message | Error Location |
|-----------|---------|---------------|----------------|
| Fair_Value_Positive | SK_ACH_Fair_Value__c < 0 | Fair Value cannot be negative | SK_ACH_Fair_Value__c |
| Approval_Required_For_Approved_Status | ISPICKVAL(SK_ACH_Valuation_Status__c, "Approved") && ISBLANK(SK_ACH_Approved_By__c) | Valuation must have an Approver when Status is Approved | SK_ACH_Valuation_Status__c |
| Review_Before_Approval | ISPICKVAL(SK_ACH_Valuation_Status__c, "Approved") && ISBLANK(SK_ACH_Reviewed_By__c) | Valuation must be reviewed before approval | SK_ACH_Valuation_Status__c |

### Notes
- **Sharing Model:** Controlled by Parent (Master-Detail to Investment)
- **Rollup Impact:** Fair Value field rolls up to Investment's Current Fair Value field (MAX)
- **NAV Calculation:** Approved valuations are used for Net Asset Value (NAV) calculations

---

## Appendix

### Field Naming Convention
- **Prefix:** `SK_ACH_`
- **Format:** `SK_ACH_{Field_Name}__c`
- **Labels:** Human-readable without prefix

### Picklist Value Standards
- Use Title Case for picklist values
- Keep values concise (< 40 characters)
- Order alphabetically unless logical sequence needed

### Formula Field Best Practices
- Always handle null values with `ISBLANK()` or `ISNULL()`
- Use `IF()` for conditional logic
- Keep formulas readable with proper spacing

---

**Next Object to Document:** SK_ACH_Investor__c

**Status:** Fund object complete ✓ | 8 objects remaining
