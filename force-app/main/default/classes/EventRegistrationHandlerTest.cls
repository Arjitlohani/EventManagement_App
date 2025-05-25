@isTest
public class EventRegistrationHandlerTest {
    @isTest
    static void testRegister() {
        Event__c ev = new Event__c(Name = 'Project Final', Status__c = 'Open', Event_Date__c = Date.today());
        insert ev;

        Session__c sess = new Session__c(
            Name = 'Demo Session',
            Event__c = ev.Id,
            Capacity__c = 5,
            Remaining_Slots__c = 2
        );
        insert sess;

        Test.startTest();
        EventRegistrationHandler.register('Arjit Lohani', 'arjitloh223@gmail.com', sess.Id);
        Test.stopTest();

        List<Attendee__c> attendees = [SELECT Id, Status__c FROM Attendee__c WHERE Session__c = :sess.Id];
        System.assertEquals(1, attendees.size());
        System.assertEquals('Registered', attendees[0].Status__c);
    }
}