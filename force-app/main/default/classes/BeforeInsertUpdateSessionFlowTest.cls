@isTest
public class BeforeInsertUpdateSessionFlowTest {

    //Insert Test Data
    @testSetup
    private static void insertTestData(){
        //Create and insert a Public Event record
        Public_Event__c event = new Public_Event__c( Name = 'Test Event',
                                                     Type__c = 'Connections',
                                                   	 Start_Date__c = Datetime.newInstance(2022, 5, 1, 12, 00, 0),
                                                   	 End_Date__c = Datetime.newInstance(2022, 5, 30, 12, 00, 0),
                                                   	 City__C = 'Edirne',
                                                   	 Country__c = 'Turkey');
        insert event;

        //Create and insert a Venue record
        Venue__c venue = new Venue__c( Name = 'Test Venue', 
                                        City__c = 'Edirne', 
                                        Country__c = 'Turkey'
                                        );
        insert venue;

        //Create and insert a Room record
        Room__c room = new Room__c( Name = 'Test Room', 
                                    Venue__c = venue.Id, 
                                    Room_Capacity__c = 5
                                    );
        insert room;

        //Create and insert sessions which do not overlaps with each other
        Session__c  s1 = new Session__c( Name = 'Session1',
                                         Public_Event__c = event.Id,
                                         Room__c = room.Id,
                                         Start_Date_Time__c = Datetime.newInstance(2022, 5, 10, 12, 00, 0),
                                         End_Date_Time__c = Datetime.newInstance(2022, 5, 15, 12, 00, 0)
                                        );
        
        Session__c s2 = new Session__c( Name = 'Session2',
                                         Public_Event__c = event.Id,
                                         Room__c = room.Id,
                                         Start_Date_Time__c = Datetime.newInstance(2022, 5, 2, 12, 00, 0),
                                         End_Date_Time__c = Datetime.newInstance(2022, 5, 3, 12, 00, 0)
                                        );
        insert new List<Session__c>{s1, s2};
    }
    
    // Test method for overlap check
    @isTest
    private static void testOverlappingSessionInsert(){
        //Get the related event
        Public_Event__c event = [SELECT Id FROM Public_Event__c WHERE Name = 'Test Event'];
        Room__c room = [SELECT Id FROM Room__c WHERE Name = 'Test Room'];
        //Create session records which overlaps with s1 record
        Session__c session3 = new Session__c( Name = 'Session3',
                                         Public_Event__c = event.Id,
                            			 Room__c = room.Id,
                                         Start_Date_Time__c = Datetime.newInstance(2022, 5, 5, 12, 00, 0),
                                         End_Date_Time__c = Datetime.newInstance(2022, 5, 12, 12, 00, 0)
                                        );
        Session__c session4 = new Session__c( Name = 'Session4',
                                         Public_Event__c = event.Id,
                            			 Room__c = room.Id,
                                         Start_Date_Time__c = Datetime.newInstance(2022, 5, 13, 12, 00, 0),
                                         End_Date_Time__c = Datetime.newInstance(2022, 5, 16, 12, 00, 0)
                                        );
        Session__c session5 = new Session__c( Name = 'Session5',
                                         Public_Event__c = event.Id,
                            			 Room__c = room.Id,
                                         Start_Date_Time__c = Datetime.newInstance(2022, 5, 12, 12, 00, 0),
                                         End_Date_Time__c = Datetime.newInstance(2022, 5, 13, 12, 00, 0)
                                        );
        //Add created sessions to a list
        List<Session__c> inList = new List<Session__c>{session3, session4, session5};
        
        test.startTest();
        //Try inserting overlapping session records and get SaveResults
        Database.SaveResult[] srList = Database.insert(inList, false);
        //Loop through SaveResults
        for(Database.SaveResult sr : srList) {
            if(sr.isSuccess()){ //If insertion was successful test failed
                system.debug('overlapping session record got saved');
                system.assert(false, 'overlapping session record got saved');
            }else{
                //Check if the error messages are equal to the expected Validation Rule message.
                for(Database.Error err : sr.getErrors()) {
                    system.debug(err.getMessage());
					system.assertEquals(true, err.getMessage().contains('Room is not available for given time frame.'));
                }
            }
        }
        
        test.stopTest();
    }
    
    //Test method for checking insertion of session records which does not overlaps with setup test data
    @isTest
    private static void testNotOverlappingSessionInsert () {
        
        //Get related Public Event
		Public_Event__c event = [SELECT Id FROM Public_Event__c WHERE Name = 'Test Event'];
        Room__c room = [SELECT Id FROM Room__c WHERE Name = 'Test Room'];
        //Create Sessions which do not overlaps with setup test data
        Session__c session6 = new Session__c( Name = 'Session6',
                                              Public_Event__c = event.Id,
                                              Room__c = room.Id,
                                              Start_Date_Time__c = Datetime.newInstance(2022, 5, 9, 12, 00, 0),
                                              End_Date_Time__c = Datetime.newInstance(2022, 5, 10, 11, 59, 0)
                                            );
        Session__c session7 = new Session__c( Name = 'Session7',
                                              Public_Event__c = event.Id,
                                              Room__c = room.Id,
                                              Start_Date_Time__c = Datetime.newInstance(2022, 5, 15, 12, 01, 0),
                                              End_Date_Time__c = Datetime.newInstance(2022, 5, 16, 12, 00, 0)
                                            );
        
        //Add created sessions to a list
        List<Session__c> inList = new List<Session__c>{session6, session7};
            
        test.startTest();
        //Try to insert created sessions and got the SaveResults
        Database.SaveResult[] srList = Database.insert(inList, false);
        //Loop through SaveResults
        for(Database.SaveResult sr : srList) {
            if(sr.isSuccess()){ //If insertion was successfull, then test is successfull
                system.debug(sr.getId() + ' is saved successfully');
                system.assert(true);
            }else{ //If insertion was not successful, then test is failed
                
                //Loop through errors and debug them
                for(Database.Error err : sr.getErrors()) {
                    system.debug(err.getMessage());
					system.assertEquals(1, 0, err.getMessage());
                }
            }
        }
        
        test.stopTest();

    }
    
    //Test method overlap check on update operation
    @isTest
    private static void testOverlappingSessionUpdate() {
        //Get a session to update
        Session__c session2 = [SELECT Start_Date_Time__c, End_Date_Time__c FROM Session__c WHERE Name = 'Session2'];
        //Set session's End_Date_Time__c field to a new date/time value which overlaps with test setup data
        session2.End_Date_Time__c = Datetime.newInstance(2022, 5, 11, 12, 00, 0);
        test.startTest();
        try{
            //Try update operation
            update session2;
            //If session got saved without throwing an Exception then test is failed
            system.debug('overlapping session record got saved');
            system.assert(false, 'overlapping session record got saved');
        }catch(Exception e){
            //If the Exception message has the expected Validation Rule message, then test is successful
            system.debug(e.getMessage());
            system.assertEquals(true, e.getMessage().contains('Room is not available for given time frame.'));
        }
        test.stopTest();
    }
    
    
}