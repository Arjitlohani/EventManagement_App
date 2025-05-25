import { LightningElement, track, wire } from 'lwc';
import getAllEventsWithSessions from '@salesforce/apex/EventSessionController.getAllEventsWithSessions';

export default class AllEventsSessions extends LightningElement {
    @track eventsWithSessions = [];
    @track error;

    @wire(getAllEventsWithSessions)
    wiredData({ error, data }) {
        if (data) {
            // Format dates here for each session
            this.eventsWithSessions = data.map(evWrap => {
                // clone sessions with formatted date/time strings
                const formattedSessions = evWrap.sessionList.map(session => {
                    return {
                        ...session,
                        formattedStartTime: this.formatDateTime(session.Start_Time__c),
                        formattedEndTime: this.formatDateTime(session.End_Time__c)
                    };
                });

                return {
                    ...evWrap,
                    sessionList: formattedSessions
                };
            });

            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.eventsWithSessions = [];
        }
    }

    formatDateTime(dateTimeStr) {
        if (!dateTimeStr) return '';
        return new Date(dateTimeStr).toLocaleString([], { dateStyle: 'short', timeStyle: 'short' });
    }

    get showNoEventsMessage() {
  return (!this.eventsWithSessions || this.eventsWithSessions.length === 0) && !this.error;
}

}
