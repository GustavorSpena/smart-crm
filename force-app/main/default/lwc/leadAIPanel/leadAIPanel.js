import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import SCORE_FIELD        from '@salesforce/schema/Lead.Score__c';
import SUGGESTION_FIELD   from '@salesforce/schema/Lead.AI_Suggestion__c';
import EMAIL_DRAFT_FIELD  from '@salesforce/schema/Lead.AI_Email_Draft__c';
import EMAIL_FIELD        from '@salesforce/schema/Lead.Email';
import NAME_FIELD         from '@salesforce/schema/Lead.Name';

const FIELDS = [SCORE_FIELD, SUGGESTION_FIELD, EMAIL_DRAFT_FIELD, EMAIL_FIELD, NAME_FIELD];

export default class LeadAIPanel extends LightningElement {

    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    lead;

    get score() {
        return getFieldValue(this.lead.data, SCORE_FIELD) || 0;
    }

    get suggestion() {
        return getFieldValue(this.lead.data, SUGGESTION_FIELD);
    }

    get emailDraft() {
        return getFieldValue(this.lead.data, EMAIL_DRAFT_FIELD);
    }

    get leadEmail() {
        return getFieldValue(this.lead.data, EMAIL_FIELD);
    }

    get leadName() {
        return getFieldValue(this.lead.data, NAME_FIELD);
    }

    handleCopyEmail() {
        navigator.clipboard.writeText(this.emailDraft).then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Copiado!',
                message: 'Email copiado para a área de transferência.',
                variant: 'success'
            }));
        });
    }

    handleOpenEmail() {
        const subject = encodeURIComponent('Olá, ' + this.leadName);
        const body = encodeURIComponent(this.emailDraft);
        window.open(`mailto:${this.leadEmail}?subject=${subject}&body=${body}`);
    }
}