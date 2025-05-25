import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 

export default class RegistrationForEvent extends LightningElement {
    handleStatusChange(event) {
    if (event.detail.status === 'FINISHED') {
      // Optional: Show success message
      alert('Registration Completed!');
    }
  }
}