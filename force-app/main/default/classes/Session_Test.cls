/*
@Author:-Tuğrul GÜL
@Description:- This code is created for Sessions Tests
@Created:- 30/05/2022
@Last Updated:- 30/05/2022
*/
@isTest
public class Session_Test{

    /* 
    @param:- None
    @description:- Create test data
    @returns:- None
    */
    @TestSetup
    static void makeData() {
        Venue__c[] vList = TestDataFactory.createVenues(2);
        Room__c[] rList = TestDataFactory.createRooms(2,vList);
        Public_Event__c[] pList = TestDataFactory.createPublicEvents(2,vList);
    }

    /* 
    @param:- None
    @description:- Create test Sessions
    @returns:- None
    */
    @isTest
    static void testSessions() {
        List<Room__c> rList = [SELECT Id FROM Room__c];
        List<Public_Event__c> pList =[SELECT Id, Main_Venue__c FROM Public_Event__c];
        Session__c[] sList = TestDataFactory.createNormalSessions(2,pList, rList);

        List<Session__c> seList = [SELECT Id FROM Session__c];
        System.assertEquals(true, seList.size()>0);
        }

    /* 
    @param:- None
    @description:- Create test Sessions for "Mandatory_Session_Validation" validation
    @returns:- None
    */
    @isTest
    static void testSessionsforValidaiton1() {
        List<Venue__c> vList =[SELECT Id FROM Venue__c];
        List<Room__c> rList = new List<Room__c>();
        for(Integer i =0; i<5;i++){
            Room__c ro = new Room__c(   Name = 'Test Room ' + string.valueof(i),
                                        Venue__c = vList[1].Id,
                                        Number_of_Column_Seats__c = 10,
                                        Number_of_Row_Seats__c = 10  
        );
        rList.add(ro);
        }
        insert rList;
        List<Public_Event__c> pList =[SELECT Id, Main_Venue__c FROM Public_Event__c];
        for(Public_Event__c pe : pList){
            pe.Main_Venue__c = vList[0].Id;
        }
        update pList;
        try {
            System.debug('Room Lists ' + rList);
            Session__c[] sList = TestDataFactory.createMandatorySessions(2,pList, rList);
        }catch (Exception e) {
            system.debug(e.getStackTraceString());
            system.debug('Error' + e.getMessage());
            System.assertEquals(true,e.getMessage().contains('Mandatory sessions can be served only in main venue rooms'));
        }
    }      
}