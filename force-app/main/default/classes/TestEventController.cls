@isTest
public class TestEventController {
    @isTest
    static void testGetOpenEvents() {
        insert new Event__c(Name = 'Project Demo', Status__c = 'Open', Event_Date__c = Date.today());

        Test.startTest();
        List<Event__c> results = EventController.getOpenEvents();
        Test.stopTest();

        System.assert(!results.isEmpty(), 'Should return at least one event');
    }
}