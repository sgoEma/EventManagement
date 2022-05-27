// After_Insert_Update_Event_Registration flow test class
@isTest

public class Venue_and_Room_Test_Class {

    //Test Create Venues
    @isTest
        static void testVenue() {

        //Create Venues with all required fields
        List<Venue__c> vList = new List<Venue__c>();
        for(Integer i = 0; i<5; i++){
            Venue__c ve = new Venue__c( Name = 'Venue Test'+ String.valueOf(i),
                                        Street__c = 'Alsancak',
                                        City__c = 'İzmir',
                                        Country__c = 'Turkey'
        );
        vList.add(ve);
        }
        insert vList;

        List<Venue__c> veList = [SELECT Name, ID FROM Venue__c];
        System.debug('Venues ==>>' + veList);
    }

    //Test Create Rooms for Venue
    @isTest
        static void testRoom() {

        //Create Venues with all required fields
        List<Venue__c> vList = new List<Venue__c>();
        for(Integer i = 0; i<5; i++){
            Venue__c ve = new Venue__c( Name = 'Venue Test'+ String.valueOf(i),
                                        Street__c = 'Alsancak',
                                        City__c = 'İzmir',
                                        Country__c = 'Turkey'
        );
        vList.add(ve);
        }
        insert vList;
        
        //Create Rooms with all required fields
        List<Room__c> rList = new List<Room__c>();
        for(Integer i = 0; i<3; i++){
            Room__c ro = new Room__c(   Name = 'Room Test' + String.valueOf(i),
                                        Room_Capacity__c = 25 + i*25,
                                        Venue__c = vList[0].Id
        );
        rList.add(ro);
        }
        
        for(Integer i = 0; i<2; i++){
            Room__c ro = new Room__c(   Name = 'Room Test' + String.valueOf(i),
                                        Room_Capacity__c = 25 + i*25,
                                        Venue__c = vList[1].Id
        );
        rList.add(ro);
        }
        insert rList;
        
        List<Room__c> reList = [SELECT Name, Id, Venue__c FROM Room__c];
        System.debug('Rooms with Venue information ==>>' + reList);
    }

    //Test Create Sessions with Room Record
    @isTest
        static void testSessionwithRoom() {
        
        //Create Venues with all required fields
        List<Venue__c> vList = new List<Venue__c>();
        for(Integer i = 0; i<5; i++){
            Venue__c ve = new Venue__c( Name = 'Venue Test'+ String.valueOf(i),
                                        Street__c = 'Alsancak',
                                        City__c = 'İzmir',
                                        Country__c = 'Turkey'
            );
        vList.add(ve);
        }
        insert vList;
        
        //Create Rooms with all required fields
        List<Room__c> rList = new List<Room__c>();
        for(Integer i = 0; i<3; i++){
            Room__c ro = new Room__c(   Name = 'Room Test' + String.valueOf(i),
                                        Room_Capacity__c = 25 + i*25,
                                        Venue__c = vList[0].Id
        );
        rList.add(ro);
        }
        insert rList;
        
        //Create Public Event with all required fields
        List<Public_Event__c> pList = new List<Public_Event__c>();
        for(Integer i =0; i<5;i++){
            Public_Event__c pe = new Public_Event__c( Name = 'Public Event Test' + String.valueOf(i),
                                                    Type__c = 'Dreamforce',
                                                    Start_Date__c = Datetime.now(),
                                                    End_Date__c = (Datetime.now()).addMonths(1),
                                                    City__c = 'İzmir',
                                                    Country__c = 'Turkey',
                                                    Main_Venue__c = vList[0].Id
        );
        pList.add(pe);
        }
        insert pList;

        //Create Sessions with all required fields
        List<Session__c> sList = new List<Session__c>();
        for(Integer i = 0; i<3; i++){
            Session__c  s = new Session__c( Name = 'Session Test' + String.valueOf(i),
                                            Public_Event__c = pList[0].Id,
                                            Start_Date_Time__c = (Datetime.now()).addDays(i),
                                            End_Date_Time__c = (Datetime.now()).addDays(i+2),
                                            Room__c = rList[i].Id
            );
            if(math.mod(i, 2) == 0){
                s.Is_Mandatory__c = true;
            }else{
                s.Is_Mandatory__c = false;
            }
            sList.add(s);
        }
        insert sList;

        List<Session__c> seList = [SELECT Name, Id, Room__c FROM Session__c];
        System.debug('Sessions with room information' + seList);
    }
}