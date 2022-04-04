import { LightningElement , wire, track, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
export default class DisplayLWCMap extends LightningElement {

    @api recordId;
    @track publicEvent;
    @track error;   //this holds errors
    @track mapMarkers = [];
    @track zoomLevel = 10;

    @wire(getRecord, { recordId: '$recordId', fields: ['Public_Event__c.Street__c', 'Public_Event__c.City__c', 'Public_Event__c.Country__c', 'Public_Event__c.Postal_Code__c'] })
    getpublicEvent({data,error}) {
        console.log('publicEventRecord => ', data, error);
        if (data) {
            this.publicEvent = data;
            this.mapMarkers = [
                {
                    location: {
                        Street: this.publicEvent.fields.Street__c.value,
                        City: this.publicEvent.fields.City__c.value,
                        Country: this.publicEvent.fields.Country__c.value,
                        PostalCode: this.publicEvent.fields.Postal_Code__c.value
                    },
                    icon: 'custom:custom11',
                    title: this.publicEvent.fields.Name,
                }                                    
            ];
            this.processRelatedObjects();
        } else if (error) {
            console.error('ERROR => ', JSON.stringify(error)); // handle error properly
        }
    }

    processRelatedObjects() {
        console.log('processRelatedObjects for => ', JSON.stringify(this.publicEvent));
        refreshApex(this.publicEvent);
    }
}