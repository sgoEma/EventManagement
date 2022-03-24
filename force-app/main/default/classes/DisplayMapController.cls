public with sharing class DisplayMapController {
    @AuraEnabled (cacheable=true)
    public static List<Public_Event__c> getEventLocations(String eventIdInitial){
        
        //for home page
        //String str = eventNameInitial + '%';
        //return [SELECT Name, Street__c, City__c, Country__c, Postal_Code__c FROM Public_Event__c WHERE ID =: str];

        return [SELECT Name, Street__c, City__c, Country__c, Postal_Code__c FROM Public_Event__c WHERE ID =: eventIdInitial];
    }
}