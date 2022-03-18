trigger EventRegistrationTrigger on Event_Registration__c (before insert, before update) {
    
    if (Trigger.isBefore) {
        
        if (Trigger.isInsert) {
    		EventRegistrationDuplicate.dupEventRegistrationError(Trigger.new);
    	}
		
        if (Trigger.isUpdate) {
            list<Event_Registration__c> dupList = new list<Event_Registration__c>();
            
            for(Event_Registration__c pev: Trigger.new){
                Event_Registration__c oldEventReg = Trigger.oldMap.get(pev.Id);
                
                if(pev.Contact__c != oldEventReg.Contact__c || pev.Public_Event__c != oldEventReg.Public_Event__c){
                    dupList.add(pev);                          
       			}
      		}
            if(dupList.size() > 0){
                for(Event_Registration__c dup: dupList){
                    EventRegistrationDuplicate.dupEventRegistrationError(Trigger.new);
                }
            }
    	}
        
    }
}