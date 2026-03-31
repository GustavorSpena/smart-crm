import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getLeads from '@salesforce/apex/LeadListController.getLeads';

export default class LeadList extends NavigationMixin(LightningElement) {

    @wire(getLeads)
    leads;

    handleNew() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Lead',
                actionName: 'new'
            }
        });
    }
}