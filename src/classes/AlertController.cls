global class AlertController{
    
    public AlertController(){

    }
    
    @RemoteAction
    global static List<Alert__c> getAlertList() {
        return [select Id, Name, Description__c, LastModifiedDate from Alert__c where IsValid__c = true order by LastModifiedDate desc];
    }
    @RemoteAction
    global static List<Location__c> getEvacuationList() {
        return [select Id, Name, Phone__c, ShortDescription__c, Type__c, Geolocation__latitude__s, Geolocation__longitude__s from Location__c where IsEvacuationCenter__c = true order by Name];
    }
    @RemoteAction
    global static boolean sendHelpNotice(SafetyStatus__c helpNotice) {
        try{
            upsert helpNotice;
        }catch(Exception e){
            System.debug(e);
            return false;
        }
        return true;
    }
    @RemoteAction
    global static boolean sendSafetyNotice(SafetyStatus__c safetyNotice) {
        try{
            upsert safetyNotice;
        }catch(Exception e){
            System.debug(e);
            return false;
        }
        return true;
    }
}