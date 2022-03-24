import { LightningElement , wire, track, api} from 'lwc';

import getEventLocations from '@salesforce/apex/DisplayMapController.getEventLocations';

export default class DisplayLWCMap extends LightningElement {

    @api recordId;
 
    @track error;   //this holds errors

    @track mapMarkers = [];
    @track zoomLevel = 10;

    /* Load address information based on recordId from Controller */
    @wire(getEventLocations, { eventIdInitial: '$recordId'})
    wiredEventLocations({ error, data }) {
        if (data) {            
            data.forEach(dataItem => {
                this.mapMarkers = [...this.mapMarkers ,
                    {
                        location: {
                            Street: dataItem.Street__c,
                            City: dataItem.City__c,
                            Country: dataItem.Country__c,
                            PostalCode: dataItem.PostalCode__c,

                        },
        
                        icon: 'custom:custom11',
                        title: dataItem.Name,
                    }                                    
                ];
              });            
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }

}