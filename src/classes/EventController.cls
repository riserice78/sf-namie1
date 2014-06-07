global class EventController{
    public EventController(){
    
    }

    @RemoteAction
    global static Map<String, List<String>> queryEvents(){
        Map<String, List<String>> eventMap = new Map<String, List<String>>();
        for(Event__c event : [select Id, Name, LastModifiedDate, MainImageURL__c, ActivityDateTime__c, Summary__c,
                CurrentNumberOfParticipants__c, MaxNumberOfParticipants__c, Location__c, Location__r.Name from Event__c
                where ActivityDateTime__c >= TODAY order by ActivityDateTime__c asc]){
            String eventDate = String.valueOf(event.ActivityDateTime__c.date());
            List<String> eventList;
            if(!eventMap.containsKey(eventDate)){
                eventList = new List<String>();
            }else{
                eventList = eventMap.get(eventDate);
            }
            eventList.add(event.Name);
            eventMap.put(eventDate, eventList);            
        }
      return eventMap;
    }    


    @RemoteAction
    global static List<Event__c> queryEventOnDay(String eventDayParam){
        DateTime eventDay = DateTime.newInstance(Date.valueOf(eventDayParam), Time.newInstance(0, 0, 0, 0));
        DateTime eventDayAfter = eventDay.addDays(1);
        
        return [select Id, Name, LastModifiedDate, MainImageURL__c, ActivityDateTime__c, Summary__c, IsVolunteer__c,
                CurrentNumberOfParticipants__c, MaxNumberOfParticipants__c, Location__c, Location__r.Name from Event__c
                where ActivityDateTime__c >= :eventDay and ActivityDateTime__c < :eventDayAfter order by ActivityDateTime__c asc];
    }    


    @RemoteAction
    global static List<WeekHolder> queryCalendar(String startDateParam){
        List<WeekHolder> wList = new List<WeekHolder>();
        WeekHolder wh = new WeekHolder();
        Date startDate = Date.valueOf(startDateParam);
        //add previous month's dates, set isValid to false
        Date tempDate = startDate.toStartOfMonth().toStartOfWeek();
        while(!startDate.isSameDay(tempDate)){    //add day to list until today
            if(wh.dayList.size()==7){    //create new week
                wList.add(wh);
                wh = new WeekHolder();
            }
            wh.dayList.add( new DayHolder(tempDate, false) );
            tempDate = tempDate.addDays(1);
        }
                
        Map<String, List<String>> eventMap = EventController.queryEvents();
        //group by day, add by week (ADD VALID DAYS)
        for(integer n=tempDate.day(); n<=Date.daysInMonth(startDate.year(), startDate.month()); n++){
            if(wh.dayList.size()==7){    //create new week
                wList.add(wh);
                wh = new WeekHolder();
            }
            if(eventMap.containsKey(String.valueOf(tempDate))){    //add eventList to day
                wh.dayList.add( new DayHolder(tempDate, true, eventMap.get(String.valueOf(tempDate))) );
            }else{
                wh.dayList.add( new DayHolder(tempDate, true) );              
            }
            tempDate = tempDate.addDays(1);            
        }

        //add next month's dates, set isValid to false
        for(integer n = wh.dayList.size(); n<7; n++){
            if(eventMap.containsKey(String.valueOf(tempDate))){    //add eventList to day
                wh.dayList.add( new DayHolder(tempDate, true, eventMap.get(String.valueOf(tempDate))) );
            }else{
                wh.dayList.add( new DayHolder(tempDate, true) );              
            }
            tempDate = tempDate.addDays(1);
            
            if(wh.dayList.size()==7)
                wList.add(wh);

        }
                
        return wList;
    }
    
    
    global class WeekHolder{
        public List<DayHolder> dayList{get; set;}
        public WeekHolder(){
            dayList = new List<DayHolder>();
        }
    }
    
    public class DayHolder{
        public List<String> eventList{get; set;}
        public String day{get; set;}
        public Boolean isActive{get; set;}
        public String actualDate{get; set;}
        
        public DayHolder(Date d, Boolean isActive){
            this(d, isActive, null);
        }

        public DayHolder(Date d, Boolean isActive, List<String> eventList){
            this.actualDate = d.format();
            this.isActive = isActive;
            this.day = '' + d.day();
            this.eventList = eventList;
        }

    }



    @RemoteAction
    global static List<Event__c> getUpcomingVolunteerList() {
        return [select Id, Name, LastModifiedDate, MainImageURL__c, ActivityDateTime__c, Summary__c,
            CurrentNumberOfParticipants__c, MaxNumberOfParticipants__c, Location__c, Location__r.Name from Event__c
            where IsVolunteer__c = true and ActivityDateTime__c >= TODAY order by ActivityDateTime__c asc];
    }

    @RemoteAction
    global static Boolean joinEvent(Participant__c participant) {
        try{
            upsert participant;
            return true;
        }catch(Exception e){
            System.debug('Error in joinEvent ' + e);
        }
        return false;
    }
}