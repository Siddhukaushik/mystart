# Apex Capital Hub
## Private Equity Fund Administration Platform

**Tagline:** *"Unified Fund Operations, Elevated Returns"*

---

## Table of Contents
1. [Project Overview](#project-overview)
2. [Business Context](#business-context)
3. [Data Model](#data-model)
4. [Object Definitions](#object-definitions)
5. [Naming Conventions](#naming-conventions)
6. [Deployment Guide](#deployment-guide)
7. [Future Roadmap](#future-roadmap)

---

## Project Overview

**Apex Capital Hub** is an enterprise-grade Private Equity Fund Administration platform built on Salesforce. It empowers fund managers, CFOs, and investor relations teams to manage the complete fund lifecycle—from capital commitments and drawdowns to distributions and carried interest calculations.

### Key Capabilities
- **Fund & Investor Management** – Onboard funds, track Limited Partners (LPs), and manage capital commitments
- **Capital Calls & Drawdowns** – Issue capital calls, track payments, and calculate unfunded commitments
- **Portfolio Investments** – Track deals, valuations, and investment performance
- **Distributions & Waterfall Logic** – Automate profit distributions with hurdle rates, catch-up, and carried interest
- **NAV & Performance Metrics** – Calculate Net Asset Value, IRR, TVPI, DPI, and RVPI
- **Investor Reporting** – Generate capital account statements and K-1 summaries
- **Compliance & Audit Trail** – Full history of transactions and approvals

### Technical Stack
- **Platform:** Salesforce Lightning
- **Metadata API Version:** 59.0+
- **App Type:** Lightning App (Standard Navigation)

---

## Business Context

### What is Private Equity Fund Administration?

Private Equity (PE) funds pool capital from institutional and accredited investors (Limited Partners or LPs) to invest in private companies. Fund administration involves:

1. **Capital Commitments** – LPs pledge a certain amount to the fund
2. **Capital Calls (Drawdowns)** – Fund manager requests portions of committed capital when needed for investments
3. **Investments** – Fund deploys capital into portfolio companies
4. **Valuations** – Periodic assessment of portfolio company values
5. **Distributions** – Returns are distributed to LPs based on waterfall logic
6. **Reporting** – Quarterly/annual statements, K-1 tax documents

### Key Stakeholders
| Role | Description |
|------|-------------|
| **General Partner (GP)** | Fund manager who makes investment decisions |
| **Limited Partner (LP)** | Investors who provide capital |
| **Fund Administrator** | Manages operations, accounting, reporting |
| **CFO/Controller** | Oversees financial accuracy and compliance |
| **Investor Relations** | Communicates with LPs |

---

## Data Model

### Entity Relationship Diagram (ERD)

```
┌─────────────────┐
│   SK_ACH_Fund   │
│    (Fund)       │
└────────┬────────┘
         │
         │ 1:N
         ▼
┌─────────────────┐       ┌─────────────────────┐
│ SK_ACH_Commitment│◄─────│   SK_ACH_Investor   │
│  (Commitment)    │  N:1 │     (Investor)      │
└────────┬─────────┘      └─────────────────────┘
         │
         │ (via Fund)
         ▼
┌─────────────────────┐      ┌─────────────────────────┐
│ SK_ACH_Capital_Call │      │ SK_ACH_Capital_Call_Line│
│   (Capital Call)    │─────►│   (Capital Call Line)   │
└─────────┬───────────┘ 1:N  └─────────────────────────┘
          │
          │ (via Fund)
          ▼
┌─────────────────────┐      ┌─────────────────────────┐
│ SK_ACH_Distribution │      │ SK_ACH_Distribution_Line│
│   (Distribution)    │─────►│   (Distribution Line)   │
└─────────────────────┘ 1:N  └─────────────────────────┘

┌─────────────────────┐      ┌─────────────────────────┐
│ SK_ACH_Investment   │─────►│   SK_ACH_Valuation      │
│   (Investment)      │ 1:N  │     (Valuation)         │
└─────────────────────┘      └─────────────────────────┘
```

### Object Relationships Summary

| Parent Object | Child Object | Relationship Type |
|---------------|--------------|-------------------|
| Fund | Commitment | Lookup |
| Fund | Capital Call | Lookup |
| Fund | Distribution | Lookup |
| Fund | Investment | Lookup |
| Investor | Commitment | Lookup |
| Capital Call | Capital Call Line | Master-Detail |
| Distribution | Distribution Line | Master-Detail |
| Commitment | Capital Call Line | Lookup |
| Commitment | Distribution Line | Lookup |
| Investment | Valuation | Master-Detail |

---

## Object Definitions

### 1. SK_ACH_Fund__c (Fund)

**Purpose:** Represents a Private Equity fund entity.

| Field | API Name | Type | Description |
|-------|----------|------|-------------|
| Fund Name | Name | Text | Name of the fund (e.g., "Apex Growth Fund III") |
| *(Fields to be added)* | | | |

**Name Field:** Text (Fund Name)

---

### 2. SK_ACH_Investor__c (Investor)

**Purpose:** Represents Limited Partners (LPs) who invest in funds.

| Field | API Name | Type | Description |
|-------|----------|------|-------------|
| Investor Name | Name | Text | Name of the LP (e.g., "CalPERS", "Endowment Fund") |
| *(Fields to be added)* | | | |

**Name Field:** Text (Investor Name)

---

### 3. SK_ACH_Commitment__c (Commitment)

**Purpose:** Tracks an LP's capital commitment to a specific fund.

| Field | API Name | Type | Description |
|-------|----------|------|-------------|
| Commitment Number | Name | AutoNumber | CMT-{0000} |
| *(Fields to be added)* | | | |

**Name Field:** AutoNumber (CMT-0001, CMT-0002, ...)

---

### 4. SK_ACH_Capital_Call__c (Capital Call)

**Purpose:** Represents a drawdown request sent to investors.

| Field | API Name | Type | Description |
|-------|----------|------|-------------|
| Capital Call Number | Name | AutoNumber | CC-{0000} |
| *(Fields to be added)* | | | |

**Name Field:** AutoNumber (CC-0001, CC-0002, ...)

---

### 5. SK_ACH_Capital_Call_Line__c (Capital Call Line)

**Purpose:** Per-investor breakdown of a capital call.

| Field | API Name | Type | Description |
|-------|----------|------|-------------|
| Line Number | Name | AutoNumber | CCL-{0000} |
| *(Fields to be added)* | | | |

**Name Field:** AutoNumber (CCL-0001, CCL-0002, ...)
**Sharing Model:** Controlled by Parent (Master-Detail to Capital Call)

---

### 6. SK_ACH_Distribution__c (Distribution)

**Purpose:** Represents profit/principal distributions to investors.

| Field | API Name | Type | Description |
|-------|----------|------|-------------|
| Distribution Number | Name | AutoNumber | DST-{0000} |
| *(Fields to be added)* | | | |

**Name Field:** AutoNumber (DST-0001, DST-0002, ...)

---

### 7. SK_ACH_Distribution_Line__c (Distribution Line)

**Purpose:** Per-investor breakdown of a distribution.

| Field | API Name | Type | Description |
|-------|----------|------|-------------|
| Line Number | Name | AutoNumber | DL-{0000} |
| *(Fields to be added)* | | | |

**Name Field:** AutoNumber (DL-0001, DL-0002, ...)
**Sharing Model:** Controlled by Parent (Master-Detail to Distribution)

---

### 8. SK_ACH_Investment__c (Investment)

**Purpose:** Tracks portfolio company investments made by the fund.

| Field | API Name | Type | Description |
|-------|----------|------|-------------|
| Investment Name | Name | Text | Name of portfolio company |
| *(Fields to be added)* | | | |

**Name Field:** Text (Investment Name)

---

### 9. SK_ACH_Valuation__c (Valuation)

**Purpose:** Periodic valuation of portfolio investments.

| Field | API Name | Type | Description |
|-------|----------|------|-------------|
| Valuation Number | Name | AutoNumber | VAL-{0000} |
| *(Fields to be added)* | | | |

**Name Field:** AutoNumber (VAL-0001, VAL-0002, ...)

---

## Naming Conventions

### General Rules
- **App API Name:** `SK_Apex_Capital_Hub`
- **Object Prefix:** `SK_ACH_` (SK = Siddhu Kaushik, ACH = Apex Capital Hub)
- **Field Prefix:** `SK_ACH_` for custom fields
- **Labels:** Human-readable without prefix (e.g., "Fund", not "SK ACH Fund")

### Naming Pattern Summary

| Component | Pattern | Example |
|-----------|---------|---------|
| Custom App | `SK_{AppName}` | `SK_Apex_Capital_Hub` |
| Custom Object | `SK_ACH_{Object}__c` | `SK_ACH_Fund__c` |
| Custom Field | `SK_ACH_{Field}__c` | `SK_ACH_Commitment_Amount__c` |
| Custom Tab | `SK_ACH_{Object}__c` | `SK_ACH_Fund__c` |
| List View | `{Descriptive_Name}` | `All_Active_Funds` |
| Permission Set | `SK_ACH_{Role}` | `SK_ACH_Fund_Manager` |
| Flow | `SK_ACH_{Process}` | `SK_ACH_Capital_Call_Generation` |
| Apex Class | `SK_ACH_{Purpose}` | `SK_ACH_WaterfallCalculator` |

---

## Deployment Guide

### Prerequisites
- Salesforce CLI installed (`sf` or `sfdx`)
- Authenticated to target org
- System Administrator profile or equivalent permissions

### Deploy Commands

**Deploy entire project:**
```bash
sf project deploy start --source-dir force-app
```

**Deploy specific object:**
```bash
sf project deploy start --source-dir force-app/main/default/objects/SK_ACH_Fund__c
```

**Deploy app and tabs:**
```bash
sf project deploy start --source-dir force-app/main/default/applications --source-dir force-app/main/default/tabs
```

### Post-Deployment Steps

1. **Assign Permission Set** to users who need access
2. **Configure Tab Visibility** in profiles if needed
3. **Add App to App Launcher** for users
4. **Create Sample Data** for testing

---

## Future Roadmap

### Phase 2: Custom Fields
- [ ] Add lookup relationships between objects
- [ ] Add currency fields (amounts, totals)
- [ ] Add picklist fields (status, type)
- [ ] Add formula fields (calculations)
- [ ] Add date fields (due dates, effective dates)

### Phase 3: Automation
- [ ] Flow: Auto-generate Capital Call Lines from Commitments
- [ ] Flow: Auto-generate Distribution Lines based on ownership %
- [ ] Apex: Waterfall distribution calculator
- [ ] Apex: IRR/TVPI/DPI calculation engine

### Phase 4: Reporting
- [ ] Fund Performance Dashboard
- [ ] Investor Capital Account Report
- [ ] Portfolio Valuation Summary
- [ ] Capital Call Aging Report

### Phase 5: Experience Cloud
- [ ] Investor Portal for LPs
- [ ] Document sharing (K-1s, statements)
- [ ] Self-service capital call acknowledgment

### Phase 6: Integrations
- [ ] Bank feed integration for payment tracking
- [ ] Document generation (PDF statements)
- [ ] E-signature for subscription agreements

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | December 20, 2025 | Siddhu Kaushik | Initial project setup - App, 9 objects, tabs |

---

## Contact

**Project Owner:** Siddhu Kaushik  
**Repository:** [github.com/Siddhukaushik/mystart](https://github.com/Siddhukaushik/mystart)  
**Branch:** `fix/apply-pr-feedback`

---

*This document is auto-generated and maintained as part of the Apex Capital Hub project.*
