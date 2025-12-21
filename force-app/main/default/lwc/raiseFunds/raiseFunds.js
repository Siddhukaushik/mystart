import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { getRecord } from 'lightning/uiRecordApi';
import { createRecord } from 'lightning/uiRecordApi';
import getFunds from '@salesforce/apex/RaiseFundsController.getActiveFunds';

const INVESTOR_FIELDS = ['SK_ACH_Investor__c.Name', 'SK_ACH_Investor__c.SK_ACH_Investor_Type__c'];

export default class RaiseFunds extends LightningElement {
    @api recordId; // Investor Id
    funds = [];
    selectedFundId;
    commitmentAmount;
    isLoading = false;

    @wire(getRecord, { recordId: '$recordId', fields: INVESTOR_FIELDS })
    investor;

    @wire(getFunds)
    wiredFunds({ error, data }) {
        if (data) {
            this.funds = data.map(fund => ({
                label: fund.Name,
                value: fund.Id
            }));
        } else if (error) {
            this.showToast('Error', 'Error loading funds', 'error');
        }
    }

    handleFundChange(event) {
        this.selectedFundId = event.detail.value;
    }

    handleAmountChange(event) {
        this.commitmentAmount = event.detail.value;
    }

    handleSave() {
        if (!this.selectedFundId || !this.commitmentAmount) {
            this.showToast('Error', 'Please select a fund and enter commitment amount', 'error');
            return;
        }

        this.isLoading = true;

        // Create Commitment record
        const commitment = {
            SK_ACH_Investor__c: this.recordId,
            SK_ACH_Fund__c: this.selectedFundId,
            SK_ACH_Commitment_Amount__c: this.commitmentAmount,
            SK_ACH_Commitment_Date__c: new Date().toISOString()
        };

        this.createCommitment(commitment);
    }

    createCommitment(commitment) {
        // Use uiRecordApi to create the commitment
        const fields = {};
        Object.keys(commitment).forEach(key => {
            fields[key] = commitment[key];
        });

        const recordInput = { apiName: 'SK_ACH_Commitment__c', fields };
        
        createRecord(recordInput)
            .then(() => {
                this.showToast('Success', 'Commitment created successfully', 'success');
                this.dispatchEvent(new CloseActionScreenEvent());
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}