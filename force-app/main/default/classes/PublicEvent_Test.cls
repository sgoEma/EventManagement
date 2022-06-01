/*
@Author:-Tuğrul GÜL
@Description:- This code is created Public Event Tests
@Created:- 27/05/2022
@Last Updated:- 01/06/2022
*/
@isTest
public class PublicEvent_Test{

    /* 
    @param:- None
    @description:- Create test data
    @returns:- None
    */
    @TestSetup
    static void makeData() {
        Venue__c[] vList = TestDataFactory.createVenues(5);  
    }

    /* 
    @param:- None
    @description:- Test create Public Events
    @returns:- None
    */
    @isTest
    static void testPublicEvents() {
        List<Venue__c> vList = [SELECT Id FROM Venue__c];
        Public_Event__c[] pList = TestDataFactory.createPublicEvents(5,vList);

        List<Public_Event__c> peList = [SELECT Id FROM Public_Event__c];
        System.assertEquals(true, peList.size()>0, 'Public Events can not be created' );
    }

    /* 
    @param:- None
    @description:- Test before insert Public Events for "Before Insert Update Public Event" flow
    @returns:- None
    */
    @isTest
    static void testPublicEventsFlow1_1() {
        List<Venue__c> vList = [SELECT Id FROM Venue__c];
        Public_Event__c[] pList = TestDataFactory.createPublicEvents(5,vList);

        List<Public_Event__c> peList = [SELECT Id, City__c, Country__c, Main_Venue__r.City__c, Main_Venue__r.Country__c FROM Public_Event__c];
        for(Integer i = 0; i<5; i++ ){
            if(math.mod(i, 2) == 0){
                System.assertEquals(peList[i].Main_Venue__r.City__c, peList[i].City__c, 'City field was not updated from Main Venue' );
                System.assertEquals(peList[i].Main_Venue__r.Country__c, peList[i].Country__c, 'Country field was not updated fromm Main Venue' );
            }else{
                System.assertEquals(peList[i].Main_Venue__r.City__c, peList[i].City__c, 'City field was not set for Public Event' );
                System.assertEquals(peList[i].Main_Venue__r.Country__c, peList[i].Country__c, 'Country field was not set for Public Event' );
            }
        }
    }

    /* 
    @param:- None
    @description:- Test before update Public Events for "Before Insert Update Public Event" flow
    @returns:- None
    */
    @isTest
    static void testPublicEventsFlow1_2() {
        List<Venue__c> vList = [SELECT Id FROM Venue__c];
        Public_Event__c[] pList = TestDataFactory.createPublicEvents(5,vList);

        List<Public_Event__c> peList = [SELECT Id, City__c, Country__c, Main_Venue__r.City__c, Main_Venue__r.Country__c FROM Public_Event__c];
        for (Public_Event__c pe : peList){
            pe.City__c = null;
            pe.Country__c = null;
            pe.Street__c = null;
            pe.Postal_Code__c = null;
        }
        update peList;
        
        List<Public_Event__c> pevList = [SELECT Id, City__c, Country__c, Main_Venue__r.City__c, Main_Venue__r.Country__c FROM Public_Event__c];
        for(Integer i = 0; i<5; i++ ){
            System.assertEquals(pevList[i].Main_Venue__r.City__c, pevList[i].City__c, 'City field was not updated from Main Venue' );
            System.assertEquals(pevList[i].Main_Venue__r.Country__c, pevList[i].Country__c, 'Country field was not updated fromm Main Venue' );
        }
    }
}