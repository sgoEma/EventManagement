/*
@Author:-Tuğrul GÜL
@Description:- This code is created for Rooms Tests
@Created:- 01/06/2022
@Last Updated:- 01/06/2022
*/
@isTest
public class Room_Test{

    /* 
    @param:- None
    @description:- Create test data
    @returns:- None
    */
    @TestSetup
    static void makeData() {
        Venue__c[] vList = TestDataFactory.createVenues(2);
    }

    /* 
    @param:- None
    @description:- Create test Rooms 
    @returns:- None
    */
    @isTest
    static void testRooms() {
        List<Venue__c> vList =[SELECT Id FROM Venue__c];
        Room__c[] rList = TestDataFactory.createRooms(2, vList);

        List<Room__c> roList = [SELECT Id FROM Room__c];
        System.assertEquals(true, roList.size()>0);
    }      
}