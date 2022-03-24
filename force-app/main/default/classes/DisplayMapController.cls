/*
Author:-Tuğrul GÜL
Description:- This code is called from displayLWCMap LWC which is used for show location map at Public Event record Page
Created:- 24/03/2022
Last Updated:- 24/03/2022
*/

public with sharing class DisplayMapController {
    @AuraEnabled (cacheable=true)

/*
param:- String eventIdInitial 
description:- get record's name and address informations which recordId is sent to EventIdInitial
returns:- List<Public_Event__c>
*/
    public static List<Public_Event__c> getEventLocations(String eventIdInitial){
        List<Public_Event__c> events;
            events = [SELECT Name, Street__c, City__c, Country__c, Postal_Code__c FROM Public_Event__c WHERE ID =: eventIdInitial WITH SECURITY_ENFORCED];
        return events;
    }
    

}