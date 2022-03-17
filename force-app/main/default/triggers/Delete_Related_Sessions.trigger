trigger Delete_Related_Sessions on Public_Event__c (before delete) {
    List<Id> idsToQuery = new List<Id>{};
    for(Public_Event__c event: Trigger.old){
        idsToQuery.add(event.id);
     }
    Session__c[] objsToDelete = [select id from Session__c where Public_Event__c IN :idsToQuery];
    
    delete objsToDelete;
}