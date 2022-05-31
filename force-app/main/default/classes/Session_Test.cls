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
        Public_Event__c[] pList = TestDataFactory.createPublicEvents(2,vList);
        
        //Create Event Registration with all required fields
        List<Room__c> rList = new List<Room__c>();
        for(Integer i =0; i<5;i++){
            Room__c ro = new Room__c(   Name = 'Test Room ' + string.valueof(i),
                                        Venue__c = vList[1].Id,
                                        Room_Capacity__c = 50 +i*25  
        );
        rList.add(ro);
        }
        insert rList;
    }


    /* 
    @param:- None
    @description:- Create test Sessions 
    @returns:- None
    */
    @isTest
    static void testSessions() {
        List<Venue__c> vList =[SELECT Id FROM Venue__c];
        List<Room__c> rList = [SELECT Id FROM Room__c];
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