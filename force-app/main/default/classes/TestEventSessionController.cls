@isTest
public class TestEventSessionController {
    @isTest
    static void testGetAllEventsWithSessions() {
        Event__c ev = new Event__c(Name = 'Project Demo', Status__c = 'Open', Event_Date__c = Date.today());
        insert ev;

        insert new Session__c(Name = 'Demo Session', Event__c = ev.Id);

        Test.startTest();
        List<EventSessionController.EventWithSessions> result = EventSessionController.getAllEventsWithSessions();
        Test.stopTest();

        System.assert(!result.isEmpty(), 'Expected non-empty event list with sessions');
    }
}