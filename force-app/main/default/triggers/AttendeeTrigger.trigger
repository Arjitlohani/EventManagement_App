trigger AttendeeTrigger on Attendee__c (before insert, after insert, after update, after delete) {
    if (Trigger.isBefore && Trigger.isInsert) {
        AttendeeTriggerHandler.handleBeforeInsert(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        AttendeeTriggerHandler.handleAfterInsert(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        AttendeeTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isDelete) {
        AttendeeTriggerHandler.handleAfterDelete(Trigger.old);
    }
}