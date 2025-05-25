public with sharing class EventSessionController {
    @AuraEnabled(cacheable=true)
    public static List<EventWithSessions> getAllEventsWithSessions() {
       
        List<Event__c> events = [SELECT Id, Name FROM Event__c ORDER BY Event_Date__c DESC];

        
        Map<Id, List<Session__c>> eventIdToSessions = new Map<Id, List<Session__c>>();

        List<Session__c> sessions = [SELECT Id, Name, Start_Time__c, End_Time__c, Event__c
                                    FROM Session__c
                                    WHERE Event__c IN :events
                                    ORDER BY Start_Time__c ASC];

        for(Session__c ses : sessions) {
            if(!eventIdToSessions.containsKey(ses.Event__c)) {
                eventIdToSessions.put(ses.Event__c, new List<Session__c>());
            }
            eventIdToSessions.get(ses.Event__c).add(ses);
        }

        // Build wrapper list
        List<EventWithSessions> result = new List<EventWithSessions>();
        for(Event__c ev : events) {
            List<Session__c> sesList = eventIdToSessions.containsKey(ev.Id) ? eventIdToSessions.get(ev.Id) : new List<Session__c>();
            result.add(new EventWithSessions(ev, sesList));
        }

        return result;
    }

    public class EventWithSessions {
        @AuraEnabled public Event__c eventRecord;
        @AuraEnabled public List<Session__c> sessionList;

        public EventWithSessions(Event__c ev, List<Session__c> sessions) {
            this.eventRecord = ev;
            this.sessionList = sessions;
        }
    }
}