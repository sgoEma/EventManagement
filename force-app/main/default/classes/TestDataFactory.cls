/*
@Author:-Tuğrul GÜL
@Description:- This code is created for Test Setup Data
@Created:- 27/05/2022
@Last Updated:- 27/05/2022
*/
@isTest
public class TestDataFactory {

    /*
    @param:- Integer numP , List<Venue__c> vList
    @description:- Creates as many Public Events as numP value
    @returns:- List<Public_Event__c> pList
    */
    public static List<Public_Event__c> createPublicEvents(Integer numP, List<Venue__c> vList) {
        List<Public_Event__c> pList = new List<Public_Event__c>();
        for(Integer i =0; i<numP;i++){
            Public_Event__c pe = new Public_Event__c(   Name = 'Public Event Test ' + String.valueOf(i),
                                                        Type__c = 'Dreamforce',
                                                        Start_Date__c = Datetime.now(),
                                                        End_Date__c = (Datetime.now()).addMonths(1),
                                                        City__c = 'London',
                                                        Country__c = 'England',
                                                        Main_Venue__c = vList[0].Id
                                                    );
            if(math.mod(i, 2) == 0){
                pe.City__c = null;
                pe.Country__c = null;
            }else{
                pe.City__c = 'İzmir';
                pe.Country__c = 'Türkiye';
            }
            pList.add(pe);
        }
        insert pList;
        return pList;
    }

    /*
    @param:- Integer numS, List<Public_Event__c> pList, List<Room__c> rList
    @description:- Creates as many Public Events as numP value
    @returns:- List<Session__c> pList
    */
    public static List<Session__c> createSessions(Integer numS, List<Public_Event__c> pList, List<Room__c> rList) {
        List<Session__c> sList = new List<Session__c>();
        for(Integer i = 0; i<numS; i++){
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
        return sList;
    }
    
    /*
    @param:- Integer numV 
    @description:- Creates as many Venues as numV value  
    @returns:- List<Venues__c> vList
    */
    public static List<Venue__c> createVenues(Integer numV) {
        List<Venue__c> vList = new List<Venue__c>();
        for(Integer i = 0; i<numV; i++){
            Venue__c ve = new Venue__c( Name = 'Venue Test '+ String.valueOf(i),
                                        Street__c = 'Alsancak',
                                        City__c = 'İzmir',
                                        Country__c = 'Türkiye'
                                    );
            vList.add(ve);
        }
        insert vList;
        return vList;
    }

    /*
    @param:- Integer numR, List<Venue__c> vList
    @description:- Creates as many Rooms as numP value
    @returns:- List<Room__c> pList
    */
    public static List<Room__c> createRooms(Integer numR, List<Venue__c> vList){
        List<Room__c> rList = new List<Room__c>();
        for(Integer i = 0; i<numR; i++){
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
        return rList;
    }
}
