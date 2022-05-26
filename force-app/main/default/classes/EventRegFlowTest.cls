// After_Insert_Update_Event_Registration flow test class
@isTest
public class EventRegFlowTest {

    //Create test data
    @TestSetup
    static void makeData() {

        //Create a Contact with all required fields    
        Contact cont = new Contact( FirstName = 'Test',
                                    LastName = 'Attendee',
                                    Contact_Type__c = 'Customer' 
                                );
        insert cont;

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
    }

    //Test Flow without Contact Email Information
    @isTest
        static void testWithoutEmail() {
    
        //Get Contact and Public Event
        Contact cont = [SELECT Id FROM Contact WHERE FirstName = 'Test' ];
        List<Public_Event__c> pList = [SELECT Id FROM Public_Event__c];  

        //Create Event Registration with all required fields
        List<Event_Registration__c> evList = new List<Event_Registration__c>();
        for(Integer i =0; i<5;i++){
            Event_Registration__c er = new Event_Registration__c(   Contact__c = cont.Id,
                                                                    Public_Event__c = pList[i].Id
        );
        evList.add(er);
        }
        insert evList;
    }

    //Test Flow with Contact Email Information
    @isTest
        static void testWithEmail() {
    
        //Get Public Event
        List<Public_Event__c> pList = [SELECT Id FROM Public_Event__c]; 
        
        //Create a Contact with all required fields    
        Contact cont = new Contact( FirstName = 'Test',
                                    LastName = 'Attendee',
                                    Contact_Type__c = 'Customer',
                                    Email = 'tgrgl@hotmail.com'   
                                );
        insert cont;
        
        //Create Event Registration with all required fields
        List<Event_Registration__c> evList = new List<Event_Registration__c>();
        for(Integer i =0; i<5;i++){
            Event_Registration__c er = new Event_Registration__c(   Contact__c = cont.Id,
                                                                    Public_Event__c = pList[i].Id
        );
        evList.add(er);
        }
        insert evList;
    
        system.debug('Event Registrations' + evList);

        //Get Session Registrations
        List<Session_Registration__c> sReg =[SELECT Id, Name, Attendee__c FROM Session_Registration__c];
        system.debug('sReg ==>> ' + sReg);
        
        for (Session_Registration__c ss : sReg){
            system.assertEquals(ss.Attendee__c, cont.Id, 'Events reg and Session regs Contacts are different');
        }
    }

    //Test Flow Update without Contact Email Information
    @isTest
        static void testUpdate() {
    
        //Get Contact and Public Event
        Contact cont = [SELECT Id FROM Contact WHERE FirstName = 'Test'];
        List<Public_Event__c> pList = [SELECT Id FROM Public_Event__c];

        //Create Event Registration with all required fields
        List<Event_Registration__c> evList = new List<Event_Registration__c>();
        for(Integer i =0; i<5;i++){
            Event_Registration__c er = new Event_Registration__c(   Contact__c = cont.Id,
                                                                    Public_Event__c = pList[i].Id
        );
        evList.add(er);
        }
        insert evList;

        List<Session_Registration__c> sReg1 =[SELECT Id, Name, Attendee__c, Cancelled__c  FROM Session_Registration__c];
        system.debug('sReg1 ==>> ' + sReg1);

        evList[0].Cancelled__c = true;
        update evList[0];

        List<Session_Registration__c> sReg2 =[SELECT Id, Name, Attendee__c, Cancelled__c  FROM Session_Registration__c];
        system.debug('sReg2 ==>> ' + sReg2);
    }
}