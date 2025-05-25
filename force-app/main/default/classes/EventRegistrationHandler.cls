public with sharing class EventRegistrationHandler {

    public static void register(String attendeeName, String attendeeEmail, Id sessionId) {
        try {
            // Retrieve the session record
            Session__c session = [
                SELECT Id, Remaining_Slots__c
                FROM Session__c
                WHERE Id = :sessionId
                LIMIT 1
            ];

            // Prepare a variable to store status
            String statusValue;

            // Check remaining slots
            if (session.Remaining_Slots__c != null && session.Remaining_Slots__c > 0) {
                statusValue = 'Registered';
                session.Remaining_Slots__c = session.Remaining_Slots__c - 1;
            } else {
                statusValue = 'Waitlisted';
            }

            // Create attendee
            Attendee__c newAttendee = new Attendee__c(
                Name = attendeeName,
                Email__c = attendeeEmail,
                Session__c = sessionId,
                Registration_Date__c = System.now(),
                Status__c = statusValue
                
            );

            insert newAttendee;

            // Update session only if a slot was taken
            if (statusValue == 'Registered') {
                update session;
            }

        } catch (Exception e) {
            System.debug('Registration error: ' + e.getMessage());
        }
    }
}