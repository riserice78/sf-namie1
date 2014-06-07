@isTest 
private class Namie1Test {

    static testMethod void namie1Test() {
        //AlertController
        alertTest();
        
        //JobController
        jobTest();
        
        //NewsController
        newsTest();
        
        //EventController
        eventTest();
    }
    
    private static void alertTest() {
        Alert__c alert = new Alert__c(IsValid__c=true);
        upsert alert;
        AlertController alertCtrl = new AlertController();
        AlertController.getAlertList();
        AlertController.getEvacuationList();
        AlertController.sendHelpNotice(new SafetyStatus__c(Alert__c=alert.Id, User__c=UserInfo.getUserId()));
        AlertController.sendSafetyNotice(new SafetyStatus__c(Alert__c=alert.Id, User__c=UserInfo.getUserId()));
        
        //alert controller exception test
        AlertController.sendSafetyNotice(new SafetyStatus__c(User__c=UserInfo.getUserId()));
        AlertController.sendHelpNotice(new SafetyStatus__c(User__c=UserInfo.getUserId()));
    }

    private static void jobTest() {
        Account account = new Account(name='SFDC');
        upsert account;
        JobOpening__c jobOpening = new JobOpening__c(Name='sse', Account__c=account.Id, IsValid__c=true);
        upsert jobOpening;
        JobController jobCtrl = new JobController();
        JobController.getJobOpeningsList();
        JobController.applyForJob(new JobApplicant__c(JobOpening__c=jobOpening.Id, Applicant__c=UserInfo.getUserId()));
        
        //job controller exception test
        JobController.applyForJob(new JobApplicant__c(Applicant__c=UserInfo.getUserId()));
    }

    private static void newsTest() {
        NewsController newsCtrl = new NewsController();
        NewsController.getNewsList();
    }
    
    private static void eventTest() {
        Account account = new Account(Name='SFDC');
        upsert account;
        Contact contact = new COntact(LastName='R R', AccountId=account.Id);
        upsert contact;
        Event__c event = new Event__c(name='テスト', ActivityDateTime__c=Date.Today(), Summary__c='something fun for everyone!', Organizer__c=contact.Id);
        upsert event;
        
        EventController eventCtrl = new EventController();
        EventController.getUpcomingVolunteerList();
        EventController.joinEvent(new Participant__c(Event__c=event.Id, ParticipantUser__c=UserInfo.getUserId()));
        EventController.queryCalendar(String.valueOf(Date.Today()));
        EventController.queryEventOnDay(String.valueOf(Date.Today()));
        //event controller exception test
        EventController.joinEvent(new Participant__c(ParticipantUser__c=UserInfo.getUserId()));
    }

    
}