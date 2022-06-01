/*
@Author:-Tuğrul GÜL
@Description:- This code is created for Venues Tests
@Created:- 01/06/2022
@Last Updated:- 01/06/2022
*/
@isTest
public class Venue_Test {

    /* 
    @param:- None
    @description:- Create test Venues 
    @returns:- None
    */
    @isTest
    static void testVenue() {
        Venue__c[] vList = TestDataFactory.createVenues(2);

        List<Venue__c> veList = [SELECT Name, ID FROM Venue__c];
        System.assertEquals(true, veList.size()>0);
    }
}