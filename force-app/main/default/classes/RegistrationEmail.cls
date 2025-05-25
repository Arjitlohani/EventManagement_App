public class RegistrationEmail {
    
    public static void sendStatusEmail(String toAddress, String attendeeName, String sessionName, String status) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { toAddress });
        email.setSubject('Event Registration Notification');

        
        String body;

    if (status == 'Waitlisted') {
            body = 'Hi ' + attendeeName + ',\n\n' +
                'You are currently on the waitlist for session: ' + sessionName + '.\n' +
                'We will get back to you as soon as any spot is available.';
        } else if (status == 'Checked In') {
            body = 'Hi ' + attendeeName + ',\n\n' +
                'You have successfully checked in for session: ' + sessionName + '.\n' +
                'Enjoy your session!';
        } else if (status == 'Cancelled') {
            body = 'Hi ' + attendeeName + ',\n\n' +
                'So sorry you had to cancel your registration for session: ' + sessionName + '.\n' +
                'Do let us know if you change your mind and want to join the session.';
        } else {
            body = 'Hi ' + attendeeName + ',\n\n' +
                'This is a notification about your session registration status: ' + status;
        }

        
        email.setPlainTextBody(body);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}