
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

        //Create a Public Event with all required fields
        Public_Event__c pe1 = new Public_Event__c( Name = 'Public Event Test 1',
                                                  Type__c = 'Dreamforce',
                                                  Start_Date__c = Datetime.newInstance(2022, 5, 1, 12, 00, 0),
                                                  End_Date__c = Datetime.newInstance(2022, 5, 30, 12, 00, 0),
                                                  City__c = 'Aydın',
                                                  Country__c = 'Turkey'
                                                );

        Public_Event__c pe2 = new Public_Event__c( Name = 'Public Event Test 2',
                                                   Type__c = 'Dreamforce',
                                                   Start_Date__c = Datetime.newInstance(2022, 6, 1, 12, 00, 0),
                                                   End_Date__c = Datetime.newInstance(2022, 6, 30, 12, 00, 0),
                                                   City__c = 'IZMIR',
                                                   Country__c = 'Turkey'
                                                 );
        insert new List<Public_Event__c>{pe1, pe2};

        //Create Sessions with all required fields
        Session__c  s1 = new Session__c( Name = 'Session Test 1',
                                         Public_Event__c = pe1.Id,
                                         Is_Mandatory__c = true,
                                         Start_Date_Time__c = Datetime.newInstance(2022, 5, 1, 12, 00, 0),
                                         End_Date_Time__c = Datetime.newInstance(2022, 5, 3, 12, 00, 0)
                                        );
        Session__c  s2 = new Session__c( Name = 'Session Test 2',
                                         Public_Event__c = pe1.Id,
                                         Is_Mandatory__c = true,
                                         Start_Date_Time__c = Datetime.newInstance(2022, 5, 4, 12, 00, 0),
                                         End_Date_Time__c = Datetime.newInstance(2022, 5, 6, 12, 00, 0)
                                        );
        Session__c  s3 = new Session__c( Name = 'Session Test 3',
                                         Public_Event__c = pe1.Id,
                                         Is_Mandatory__c = false,
                                         Start_Date_Time__c = Datetime.newInstance(2022, 5, 7, 12, 00, 0),
                                         End_Date_Time__c = Datetime.newInstance(2022, 5, 9, 12, 00, 0)
                                        );
        Session__c  s4 = new Session__c( Name = 'Session Test 4',
                                         Public_Event__c = pe2.Id,
                                         Is_Mandatory__c = true,
                                         Start_Date_Time__c = Datetime.newInstance(2022, 6, 4, 12, 00, 0),
                                         End_Date_Time__c = Datetime.newInstance(2022, 6, 6, 12, 00, 0)
                                       );
        Session__c  s5 = new Session__c( Name = 'Session Test 5',
                                         Public_Event__c = pe2.Id,
                                         Is_Mandatory__c = false,
                                         Start_Date_Time__c = Datetime.newInstance(2022, 6, 7, 12, 00, 0),
                                         End_Date_Time__c = Datetime.newInstance(2022, 6, 9, 12, 00, 0)
                                       );
        insert new List<Session__c>{s1, s2, s3, s4, s5};
    }

    //Test Flow without Contact Email Information
    @isTest
    static void testWithoutEmail() {
    
    //Get Contact and Public Event
    Contact cont = [SELECT Id FROM Contact WHERE FirstName = 'Test' ];
    Public_Event__c pe = [SELECT Id FROM Public_Event__c WHERE Name = 'Public Event Test 1' ];  

    //Create Event Registration with all required fields
    Event_Registration__c evReg = new Event_Registration__c( Contact__c = cont.Id,
                                                             Public_Event__c = pe.Id
                                                            );
    insert evReg;
    }

    //Test Flow with Contact Email Information
    @isTest
    static void testWithEmail() {
    
        //Get Public Event
        Public_Event__c pe1 = [SELECT Id FROM Public_Event__c WHERE Name = 'Public Event Test 1'];
        Public_Event__c pe2 = [SELECT Id FROM Public_Event__c WHERE Name = 'Public Event Test 2'];  
        
        //Create a Contact with all required fields    
        Contact cont = new Contact( FirstName = 'Test',
                                    LastName = 'Attendee',
                                    Contact_Type__c = 'Customer',
                                    Email = 'tgrgl@hotmail.com'   
                                );
        insert cont;
        
        //Create Event Registration with all required fields
        Event_Registration__c evReg1 = new Event_Registration__c( Contact__c = cont.Id,
                                                                 Public_Event__c = pe1.Id
                                                                );
        insert evreg1;
        Event_Registration__c evReg2 = new Event_Registration__c( Contact__c = cont.Id,
                                                                 Public_Event__c = pe2.Id
                                                                );
        insert evreg2;

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
    Public_Event__c pe = [SELECT Id FROM Public_Event__c WHERE Name = 'Public Event Test 2'];

    //Create Event Registration with all required fields
    Event_Registration__c evReg = new Event_Registration__c( Contact__c = cont.Id,
                                                             Public_Event__c = pe.Id
                                                            );
    insert evreg;

    List<Session_Registration__c> sReg1 =[SELECT Id, Name, Attendee__c, Cancelled__c  FROM Session_Registration__c];
    system.debug('sReg1 ==>> ' + sReg1);

    evReg.Cancelled__c = true;
    update evreg;

    List<Session_Registration__c> sReg2 =[SELECT Id, Name, Attendee__c, Cancelled__c  FROM Session_Registration__c];
    system.debug('sReg2 ==>> ' + sReg2);
    }
}