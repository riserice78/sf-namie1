global class NewsController{
    public NewsController(){
    
    }
    @RemoteAction
    global static List<News__c> getNewsList() {
        return [select Id, MainImageURL__c, Name, Introduction__c, LastModifiedDate from News__c 
            where ValidFrom__c <= TODAY and ValidUntil__c >= TODAY order by LastModifiedDate desc];
    }
}