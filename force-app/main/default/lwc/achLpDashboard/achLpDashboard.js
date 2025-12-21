import { LightningElement, wire, api } from 'lwc';
import getFinancialSummary from '@salesforce/apex/ACH_LPPortalController.getFinancialSummary';
import getInvestorDetails from '@salesforce/apex/ACH_LPPortalController.getInvestorDetails';
import { refreshApex } from '@salesforce/apex';

export default class AchLpDashboard extends LightningElement {
    @api title = 'My Portfolio';
    financialSummary = {};
    investorDetails = {};
    error;
    isLoading = true;
    wiredSummaryResult;
    wiredInvestorResult;

    // Wire financial summary
    @wire(getFinancialSummary)
    wiredFinancialSummary(result) {
        this.wiredSummaryResult = result;
        if (result.data) {
            this.financialSummary = result.data;
            this.checkLoadingComplete();
        } else if (result.error) {
            this.error = result.error;
            this.isLoading = false;
        }
    }

    // Wire investor details
    @wire(getInvestorDetails)
    wiredInvestorDetails(result) {
        this.wiredInvestorResult = result;
        if (result.data) {
            this.investorDetails = result.data;
            this.checkLoadingComplete();
        } else if (result.error) {
            this.error = result.error;
            this.isLoading = false;
        }
    }

    checkLoadingComplete() {
        if (this.financialSummary && this.investorDetails) {
            this.isLoading = false;
        }
    }

    // Getters for formatted values
    get totalOutstanding() {
        return this.formatCurrency(this.financialSummary.totalOutstanding || 0);
    }

    get totalDistributions() {
        return this.formatCurrency(this.financialSummary.totalDistributions || 0);
    }

    get netCashFlow() {
        return this.formatCurrency(this.financialSummary.netCashFlow || 0);
    }

    get netCashFlowClass() {
        const value = this.financialSummary.netCashFlow || 0;
        return value >= 0 ? 'slds-text-color_success' : 'slds-text-color_error';
    }

    get investorName() {
        return this.investorDetails.investor?.Name || 'N/A';
    }

    get investorType() {
        return this.investorDetails.investor?.SK_ACH_Investor_Type__c || 'N/A';
    }

    get commitments() {
        return this.investorDetails.commitments || [];
    }

    get hasCommitments() {
        return this.commitments.length > 0;
    }

    formatCurrency(value) {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD',
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(value);
    }

    handleRefresh() {
        this.isLoading = true;
        return Promise.all([
            refreshApex(this.wiredSummaryResult),
            refreshApex(this.wiredInvestorResult)
        ]).then(() => {
            this.isLoading = false;
        });
    }
}
