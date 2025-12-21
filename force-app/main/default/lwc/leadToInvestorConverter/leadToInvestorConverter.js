import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import convertLeadToInvestor from '@salesforce/apex/LeadToInvestorController.convertLeadToInvestor';

import LEAD_NAME from '@salesforce/schema/Lead.Name';
import LEAD_COMPANY from '@salesforce/schema/Lead.Company';
import LEAD_EMAIL from '@salesforce/schema/Lead.Email';
import LEAD_PHONE from '@salesforce/schema/Lead.Phone';
import LEAD_STATUS from '@salesforce/schema/Lead.Status';

const FIELDS = [LEAD_NAME, LEAD_COMPANY, LEAD_EMAIL, LEAD_PHONE, LEAD_STATUS];

export default class LeadToInvestorConverter extends LightningElement {
    @api recordId;
    @track isLoading = false;
    @track showConfirmation = false;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    lead;

    get leadName() {
        return getFieldValue(this.lead.data, LEAD_NAME);
    }

    get leadCompany() {
        return getFieldValue(this.lead.data, LEAD_COMPANY);
    }

    get leadEmail() {
        return getFieldValue(this.lead.data, LEAD_EMAIL);
    }

    get leadPhone() {
        return getFieldValue(this.lead.data, LEAD_PHONE);
    }

    get leadStatus() {
        return getFieldValue(this.lead.data, LEAD_STATUS);
    }

    get isQualified() {
        return this.leadStatus === 'Working - Contacted';
    }

    handleConvertClick() {
        this.showConfirmation = true;
    }

    handleCancelConversion() {
        this.showConfirmation = false;
    }

    handleConfirmConversion() {
        this.isLoading = true;
        this.showConfirmation = false;

        convertLeadToInvestor({ leadId: this.recordId })
            .then(result => {
                this.showToast('Success', `Lead converted to Investor: ${result.investorName}`, 'success');
                
                // Navigate to the new Investor record
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: result.investorId,
                        objectApiName: 'SK_ACH_Investor__c',
                        actionName: 'view'
                    }
                });
            })
            .catch(error => {
                this.showToast('Error', error.body.message || 'Error converting lead', 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}