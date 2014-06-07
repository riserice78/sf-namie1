global class JobController{
    public JobController(){
    
    }
    @RemoteAction
    global static List<JobOpening__c> getJobOpeningsList() {
        return [select Id, Name, Account__c, Account__r.Name, Account__r.LogoURL__c, Summary__c, LastModifiedDate from JobOpening__c where IsValid__c = true order by LastModifiedDate desc];
    }
    @RemoteAction
    global static Boolean applyForJob(JobApplicant__c applicant) {
        try{
            upsert applicant;
            return true;
        }catch(Exception e){
            System.debug('Error in applyForJob' + e);
        }
        return false;
    }
}