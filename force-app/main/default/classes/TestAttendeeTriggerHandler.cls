@isTest
public class TestAttendeeTriggerHandler {
    @isTest
    static void testTriggerHandlerFlow() {
        Event__c ev = new Event__c(Name = 'Final Project', Status__c = 'Open', Event_Date__c = Date.today());
        insert ev;

        Session__c sess = new Session__c(
            Name = 'Demo Session',
            Event__c = ev.Id,
            Capacity__c = 2,
            Remaining_Slots__c = 1
        );
        insert sess;

        // Before Insert / After Insert
        Attendee__c a1 = new Attendee__c(Name = 'Arjit Lohani', Email__c = 'arjitloh223@gmail.com', Session__c = sess.Id);
        insert a1;

        Attendee__c a2 = new Attendee__c(Name = 'Ranjit Lohani', Email__c = 'ranjit@gmail.com', Session__c = sess.Id);
        insert a2;

        // After Update (trigger email logic)
        a2.Status__c = 'Checked In';
        update a2;

        // After Delete (free slots)
        delete a1;

        Session__c updatedSession = [SELECT Remaining_Slots__c FROM Session__c WHERE Id = :sess.Id];
        System.assertNotEquals(null, updatedSession.Remaining_Slots__c);
    }
}