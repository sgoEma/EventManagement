/*
@Author:-Tuğrul GÜL
@Description:- This code is created for Public Event Tests
@Created:- 27/05/2022
@Last Updated:- 27/05/2022
*/
@isTest
public class PublicEvent_Test{

    /* 
    @param:- None
    @description:- Inserts Public Events and Venues
    @returns:- None
    */
    @isTest
    static void testPublicEventwithVenues() {
        Venue__c[] vList = TestDataFactory.createVenues(1);
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
}    