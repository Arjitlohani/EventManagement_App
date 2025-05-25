public class AttendeeTriggerHandler {

    // Handle BEFORE insert logic
   public static void handleBeforeInsert(List<Attendee__c> newAttendees) {
    Set<Id> sessionIds = new Set<Id>();
    for (Attendee__c acc : newAttendees) {
        if (acc.Session__c != null) {
            sessionIds.add(acc.Session__c);
        }
    }

    Map<Id, Session__c> sessionMap = new Map<Id, Session__c>(
        [SELECT Id, Remaining_Slots__c FROM Session__c WHERE Id IN :sessionIds]
    );

    Map<Id, Integer> newCountMap = new Map<Id, Integer>();

    for (Attendee__c acc : newAttendees) {
        if (acc.Session__c != null) {
            Integer currentCount = newCountMap.get(acc.Session__c);
            if (currentCount == null) currentCount = 0;
            newCountMap.put(acc.Session__c, currentCount + 1);
        }
    }

    for (Attendee__c acc : newAttendees) {
        if (acc.Session__c != null && sessionMap.containsKey(acc.Session__c)) {
            Session__c sess = sessionMap.get(acc.Session__c);
            Integer remaining = sess.Remaining_Slots__c != null ? sess.Remaining_Slots__c.intValue() : 0;

            Integer toBeAdded = newCountMap.get(acc.Session__c);

            if (remaining > 0) {
                acc.Status__c = 'Registered';
               
                newCountMap.put(acc.Session__c, toBeAdded - 1);
            } else {
                acc.Status__c = 'Waitlisted';
            }
        }
    }
}

    public static void handleAfterInsert(List<Attendee__c> newAttendees) {
    Map<Id, Integer> sessionCountMap = new Map<Id, Integer>();

    for (Attendee__c acc : newAttendees) {
        if (acc.Session__c != null && acc.Status__c == 'Registered') {
            sessionCountMap.put(acc.Session__c,
                sessionCountMap.containsKey(acc.Session__c) ? sessionCountMap.get(acc.Session__c) + 1 : 1
            );
        }
    }

    List<Session__c> sessionsToUpdate = new List<Session__c>();
    Map<Id, Session__c> sessions = new Map<Id, Session__c>(
        [SELECT Id, Remaining_Slots__c FROM Session__c WHERE Id IN :sessionCountMap.keySet()]
    );

    for (Id sessionId : sessionCountMap.keySet()) {
        Session__c sess = sessions.get(sessionId);
        Integer currentRemaining = sess.Remaining_Slots__c != null ? sess.Remaining_Slots__c.intValue() : 0;
        Integer reduceBy = sessionCountMap.get(sessionId);

        sess.Remaining_Slots__c = Math.max(0, currentRemaining - reduceBy); 
        sessionsToUpdate.add(sess);
    }

    update sessionsToUpdate;
}

public static void handleAfterUpdate(List<Attendee__c> updatedAttendees, Map<Id, Attendee__c> oldMap) {
    Set<Id> sessionIds = new Set<Id>();
    for (Attendee__c acc : updatedAttendees) {
        if (acc.Session__c != null) {
            sessionIds.add(acc.Session__c);
        }
    }

    Map<Id, Session__c> sessionMap = new Map<Id, Session__c>(
        [SELECT Id, Name FROM Session__c WHERE Id IN :sessionIds]
    );

    for (Attendee__c acc : updatedAttendees) {
        Attendee__c oldAcc = oldMap.get(acc.Id);

        // Only act if Status__c has changed and email exists
        if (acc.Status__c != oldAcc.Status__c && acc.Email__c != null && acc.Name != null) {
            String sessionName = sessionMap.containsKey(acc.Session__c)
                ? sessionMap.get(acc.Session__c).Name
                : 'Event session';

            RegistrationEmail.sendStatusEmail(
                acc.Email__c,
                acc.Name,
                sessionName,
                acc.Status__c
            );
        }
    }
}



   public static void handleAfterDelete(List<Attendee__c> oldAttendees) {
    Map<Id, Integer> sessionCountMap = new Map<Id, Integer>();

    // Count how many slots should be returned per session
    for (Attendee__c acc : oldAttendees) {
        if (acc.Session__c != null && acc.Status__c == 'Registered') {
            if (sessionCountMap.containsKey(acc.Session__c)) {
                sessionCountMap.put(acc.Session__c, sessionCountMap.get(acc.Session__c) + 1);
            } else {
                sessionCountMap.put(acc.Session__c, 1);
            }
        }
    }

    // Query sessions with capacity
    List<Session__c> sessionsToUpdate = new List<Session__c>();
    Map<Id, Session__c> sessions = new Map<Id, Session__c>(
        [SELECT Id, Remaining_Slots__c, Capacity__c FROM Session__c WHERE Id IN :sessionCountMap.keySet()]
    );

    for (Id sessionId : sessionCountMap.keySet()) {
        Session__c sess = sessions.get(sessionId);
        Integer remaining = sess.Remaining_Slots__c != null ? sess.Remaining_Slots__c.intValue() : 0;
        Integer capacity = sess.Capacity__c != null ? sess.Capacity__c.intValue() : 0;
        Integer increaseBy = sessionCountMap.get(sessionId);

        // Add slots but don't exceed capacity
        Integer updatedSlots = remaining + increaseBy;
        sess.Remaining_Slots__c = (updatedSlots > capacity) ? capacity : updatedSlots;

        sessionsToUpdate.add(sess);
    }

    update sessionsToUpdate;
}

}