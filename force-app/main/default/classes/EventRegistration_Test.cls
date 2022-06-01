/*
@Author:-Tuğrul GÜL
@Description:- This code is created for Event Registrations Tests
@Created:- 30/06/2022
@Last Updated:- 01/06/2022
*/
@isTest
public class EventRegistration_Test {

    /* 
    @param:- None
    @description:- Create test data
    @returns:- None
    */
    @TestSetup
    static void makeData() {
        
        Contact[] cList = TestDataFactory.createContacts(2);
        Venue__c[] vList = TestDataFactory.createVenues(5);
        Room__c[] rList = TestDataFactory.createRooms(2,vList);
        Public_Event__c[] pList = TestDataFactory.createPublicEvents(5,vList);
        Session__c[] snList = TestDataFactory.createNormalSessions(2,pList, rList);
        Session__c[] smList = TestDataFactory.createMandatorySessions(2,pList, rList);
    }

    /* 
    @param:- None
    @description:- Create test Event Registrations
    @returns:- None
    */
    @isTest
    static void testSessions() {
        //Get Contacts and Public Events
        List<Contact> cList = [SELECT Id FROM Contact];
        List<Public_Event__c> pList = [SELECT Id FROM Public_Event__c];  

        //Create Event Registrations with all required fields 
        Event_Registration__c[] evList = TestDataFactory.createEventRegistrations(5, cList, pList);

        List<Event_Registration__c> evRList = [SELECT Id FROM Event_Registration__c];
        System.assertEquals(true, evRList.size()>0);
        }

    /* 
    @param:- None
    @description:- Test After Insert Event Registrations at "After Insert Update Event Registration" Flow without Contact's Email Information 
    @returns:- None
    */
    @isTest
    static void testWithoutEmail() {

        //Get Contacts and Public Events
        List<Contact> cList = [SELECT Id FROM Contact];
        List<Public_Event__c> pList = [SELECT Id FROM Public_Event__c];  

        //Create Event Registrations with all required fields 
        Event_Registration__c[] evList = TestDataFactory.createEventRegistrations(5, cList, pList);
    }

    /* 
    @param:- None
    @description:- Test After Insert Event Registrations at "After Insert Update Event Registration" Flow with Contact's Email Information 
    @returns:- None
    */
    @isTest
    static void testWithEmail() {
    
        //Get Public Events
        List<Public_Event__c> pList = [SELECT Id FROM Public_Event__c]; 
        
        //Create a Contacts with all required fields    
        Contact cont = new Contact(     FirstName = 'Test',
                                        LastName = 'Attendee',
                                        Contact_Type__c = 'Customer',
                                        Email = 'tgrgl@hotmail.com'   
                                    );
        insert cont;
        List<Contact> cList = [SELECT Id FROM Contact WHERE Email = 'tgrgl@hotmail.com'];
        
        //Create Event Registrations with all required fields
        Event_Registration__c[] evList = TestDataFactory.createEventRegistrations(5, cList, pList);
    
        system.debug('Event Registrations' + evList);

        //Get Session Registrations
        List<Session_Registration__c> sReg =[SELECT Id, Name, Attendee__c FROM Session_Registration__c];
        system.debug('sReg ==>> ' + sReg);
        
        for (Session_Registration__c ss : sReg){
            system.assertEquals(ss.Attendee__c, cList[0].Id, 'Events reg and Session regs Contacts are different');
        }
    }

    /* 
    @param:- None
    @description:- Test After Update Event Registrations at "After Insert Update Event Registration" Flow without Contact's Email Information
    @returns:- None
    */
    @isTest
    static void testUpdate() {
    
        //Get Contacts and Public Events
        List<Contact> cList = [SELECT Id FROM Contact];
        List<Public_Event__c> pList = [SELECT Id FROM Public_Event__c];

        //Create Event Registrations with all required fields
        Event_Registration__c[] evList = TestDataFactory.createEventRegistrations(5, cList, pList);

        List<Session_Registration__c> sReg1 =[SELECT Id, Name, Attendee__c, Cancelled__c  FROM Session_Registration__c];
        system.debug('sReg1 ==>> ' + sReg1);

        evList[0].Cancelled__c = true;
        update evList[0];

        List<Session_Registration__c> sReg2 =[SELECT Id, Name, Attendee__c, Cancelled__c  FROM Session_Registration__c];
        system.debug('sReg2 ==>> ' + sReg2);

        system.assertEquals(    string.valueOf(sReg1[0].Id) + string.valueOf(sReg1[0].Attendee__c) + string.valueOf(sReg1[0].Cancelled__c),
                                string.valueOf(sReg2[0].Id) + string.valueOf(sReg2[0].Attendee__c) + string.valueOf(!sReg2[0].Cancelled__c),
                                'After Update Event Registrations at "After Insert Update Event Registration" Flow has a problem');
    }
}