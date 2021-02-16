// User's bank asks for 2FA...

function ConfirmScaPayment() {
	stripe.confirmCardPayment(document.getElementById('confirm_sca_payment').dataset.secret, {
	  payment_method: {card: card}
	}).then(function(result) {
	  if (result.error) {
 		sendError(result)
	  } else {
	    // The payment has been processed!
	    if (result.paymentIntent.status === 'succeeded') {
	      // Show a success message to your customer
	      // There's a risk of the customer closing the window before callback execution
	      // Set up a webhook or plugin to listen for the payment_intent.succeeded event
	      // that handles any business critical post-payment actions
	    }
	  }
	});
}