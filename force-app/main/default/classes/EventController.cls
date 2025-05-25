public with sharing class EventController {
    @AuraEnabled(cacheable=true)
    public static List<Event__c> getOpenEvents() {
        return [SELECT Id, Name, Event_Date__c, Location__c, Status__c FROM Event__c WHERE Status__c != 'Closed' ORDER BY Event_Date__c DESC];
    }
}