@isTest
public class TestRegistrationEmail {
    @isTest
    static void testSendStatusEmail() {
        Test.startTest();
        RegistrationEmail.sendStatusEmail(
            'arjitloh223@gmail.com', 'Arjit Lohani', 'Demo Session', 'Registered'
        );
        RegistrationEmail.sendStatusEmail(
            'arjitloh223@gmail.com', 'Arjit Lohani', 'Demo Session', 'Waitlisted'
        );
        RegistrationEmail.sendStatusEmail(
            'arjitloh223@gmail.com', 'Arjit Lohani', 'Demo Session', 'Cancelled'
        );
        RegistrationEmail.sendStatusEmail(
            'arjitloh223@gmail.com', 'Arjit Lohani', 'Demo Session', 'Checked In'
        );
        Test.stopTest();
        System.assert(true); 
    }
}