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


var payment_intent_secret = document.getElementById("payment_intent_secret").dataset.secret;
var payment_method = document.getElementById("payment_method").dataset.secret;
console.log(payment_intent_secret);
console.log(payment_method);


function fixWithClick(ev) {
	  console.log("Inside fixWithClick...")
	  
	  document.getElementById("fix-with-click-button").style.display = "none";
	  var content = 'One moment, please...<br />' + ajax_image;
	  document.getElementById("ajax_form_message_click").style.display = "block";
	  document.getElementById("ajax_form_message_click").innerHTML = content;
						
	  stripe.confirmCardPayment(payment_intent_secret, {payment_method: payment_method})
	  .then(function(result) {
		// Handle result.error or result.paymentIntent
		location.reload();
		
	  });
};

function fixWithCard(ev) {
	
	document.getElementById("fix-with-card-button").style.display = "none";
	var content = 'One moment, please...<br />' + ajax_image;
	document.getElementById("ajax_form_message_card").style.display = "block";
	document.getElementById("ajax_form_message_card").innerHTML = content;
	
	stripe.confirmCardPayment(payment_intent_secret, {
		payment_method: {card: card},
		setup_future_usage: "off_session"
	  })
	  .then(function(result) {
		// Handle result.error or result.paymentIntent
		location.reload();
	  });
};