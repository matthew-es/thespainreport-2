// Get setup intent for card...

function getSetup() {
    document.getElementById("customer_email").onfocus = null;
    document.getElementById("customer_email").onmouseover = null;
    document.getElementById("card-element").onmouseover = null;
    
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
         var details = JSON.parse(this.responseText);
         document.getElementById("card-button").setAttribute("data-secret", details["secret"]);
         document.getElementById("stripe_payment_intent_for_server").value = details["payment_intent"];
         document.getElementById("stripe_setup_intent_for_server").value = details["setup_intent"];
        }
  };
  xhttp.open("GET", "/stripe_get_payment_intent", true);
  xhttp.send();
}


	var style = {
		base: {
			color: '#32325d',
			fontFamily: 'Georgia',
			fontSize: '16px',
			'::placeholder': {
				color: '#aab7c4'
			}
		},
		invalid: {
			color: '#fa755a',
			iconColor: '#fa755a'
		}
	};

	// Create an instance of the card Element.
	var card = elements.create('card', {
		hidePostalCode: true,
		style: style
	});

	// Add an instance of the card Element into the `card-element` <div>.
	card.mount('#card-element');

	// Handle real-time validation errors from the card Element.
	card.addEventListener('change', function(event) {
		var displayError = document.getElementById('card-errors');
		if (event.error) {
			displayError.textContent = event.error.message;
		} else {
			displayError.textContent = '';
		}
	});

// Handle form submission.
var cardButton = document.getElementById('card-button');
stripe.handleCardAction(document.getElementById('card-button').dataset.secret).then(function(result) {
    // Handle result.error or result.paymentIntent
    console.log(result)
  });