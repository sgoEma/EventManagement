public class EventRegistrationDuplicate{
    
    public static void dupEventRegistrationError(List<Event_Registration__c>newTrigEventReg){
    
    List<Event_Registration__c> AllEventReg = [SELECT Public_Event__c, contact__c FROM Event_Registration__c];
    
    Set<Id> AllPublicEvents = new Set<Id>();
    Set<Id> AllConRegisterto = new Set<Id>();
    
    for(Event_Registration__c OneEventReg : AllEventReg){
        
        allPublicEvents.add(OneEventReg.Public_Event__c);
        allConRegisterto.add(OneEventReg.contact__c);
    
    }
    
    for(Event_Registration__c OneEventRegTrig : newTrigEventReg){
    
        if(allPublicEvents.contains(OneEventRegTrig.Public_Event__c)
           && allConRegisterto.contains(OneEventRegTrig.contact__c)){
           
           OneEventRegTrig.addError('This event already registered.');
           }
    }
    }
}