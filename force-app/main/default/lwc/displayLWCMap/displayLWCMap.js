import { LightningElement , wire, track, api } from 'lwc';
import { getRecord} from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
export default class DisplayLWCMap extends LightningElement {

    @api recordId;
    @api objectApiName;
    @track record;
    @track fields;
    @track error;   //this holds errors
    @track mapMarkers = [];
    @track zoomLevel = 10;
    
    connectedCallback() {
        this.fields =   [   this.objectApiName + '.Street__c',
                            this.objectApiName + '.City__c',
                            this.objectApiName + '.Country__c',
                            this.objectApiName + '.Postal_Code__c'
                        ];
    }

    @wire(getRecord,    { recordId: '$recordId', fields: '$fields'
                        }
    )
    getmaprecords({data,error}) {
        if (data) {
            this.record = data;
            this.mapMarkers = [
                {
                    location: {
                        Street: this.record.fields.Street__c.value,
                        City: this.record.fields.City__c.value,
                        Country: this.record.fields.Country__c.value,
                        PostalCode: this.record.fields.Postal_Code__c.value
                    },
                    icon: 'custom:custom11',
                    title: this.record.fields.Name,
                }                                    
            ];
            this.processRelatedObjects();
        } else if (error) {
            console.error('ERROR => ', JSON.stringify(error)); // handle error properly
        }
    }

    processRelatedObjects() {
        refreshApex(this.record);
    }
}