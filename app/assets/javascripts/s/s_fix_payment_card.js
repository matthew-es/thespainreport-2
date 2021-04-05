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
cardButton.addEventListener('click', function(ev) {
 		stripe.confirmCardSetup(
 		document.getElementById('card-button').dataset.secret, {
 			payment_method: {card: card}
 		}
 	).then(function(result) {
 		var em = document.getElementById("email_for_server").value;
 		var at = document.getElementById("authenticity_token").value;
 		var la = document.getElementById("language_for_server").value;
 		var fr = document.getElementById("frame_for_server").value;
 		var art = document.getElementById("article_for_server").value;
 		
		var sub = document.getElementById("subscription_for_server").value;
		var pa = document.getElementById("plan_amount_for_server").value;
		var rc = document.getElementById("residence_country_code_for_server").value;
		var pi = document.getElementById("stripe_payment_intent_for_server").value;
 		var si = document.getElementById("stripe_setup_intent_for_server").value;
 		
 		var inna = document.getElementById("invoice_name_for_server").value;
	 	var inid = document.getElementById("invoice_tax_id_for_server").value;
	 	var inad = document.getElementById("invoice_address_for_server").value;
 		
 		if (result.error) {
 			sendError(result)
 		} else {
 			// Hide send button
 			document.getElementById("card-button").style.display = "none";
 			
 			// Send stuff to server to check user/account and calculate VAT
 			var pm = result.setupIntent.payment_method;
 			
 			var string_for_server = 
 			'email_for_server=' + em 
 			+ '&language_for_server=' + la
 			+ '&frame_for_server=' + fr
 			+ '&authenticity_token=' + at 
 			+ '&article_for_server=' + art
 			+ '&subscription_for_server=' + sub 
 			+ '&plan_amount_for_server=' + pa 
 			+ '&residence_country_code_for_server=' + rc 
 			+ '&stripe_payment_intent_for_server=' + pi 
 			+ '&stripe_setup_intent_for_server=' + si 
 			+ '&stripe_pm_for_server=' + pm
 			+ '&invoice_name_for_server=' + inna
		 	+ '&invoice_tax_id_for_server=' + inid
		 	+ '&invoice_address_for_server=' + inad
 			;
 			
			var xhttp = new XMLHttpRequest();
			  xhttp.onreadystatechange = function() {
			    if (this.readyState == 1 || 2 || 3) {
			    	var content = 'Doing some sums for the tax man…<br />' + ajax_image;
				    document.getElementById("ajax_form_message").style.display = "block";
				    document.getElementById("ajax_form_message").innerHTML = content;
			    }
			    
			    if (this.readyState == 4 && this.status == 499) {
					    	var details = JSON.parse(this.responseText);
					    	document.getElementById("ajax_form_one").style.display = "none";
					    	document.getElementById("ajax_form_message").style.display = "none";
					    	document.getElementById("ajax_form_login").style.display = "block";
						}
			    
			    if (this.readyState == 4 && this.status == 200) {
				     var details = JSON.parse(this.responseText)
				     var details_plan_amount = details["plan_amount"]
				     var details_vat_country = details["vat_country"]
				     var details_vat_rate = details["vat_rate"]
				     var details_vat_amount = details["vat_amount"]
				     var details_total_amount = details["total_amount"]
				     var details_email = details["email"]
				     
				     document.getElementById("confirm_email").innerHTML = details_email;
				     document.getElementById("confirm_plan_amount").innerHTML = "€ " + preciseTaxes(details_plan_amount/100, 2);
				     document.getElementById('confirm_vat_rate').innerHTML = preciseTaxes(details_vat_rate*100, 1) + "%";
				     if (details_vat_amount == "0") {
				     	document.getElementById("confirm_vat_amount").innerHTML = "Exempt";
				     } else {
				     	document.getElementById("confirm_vat_amount").innerHTML = "€ " + preciseTaxes(details_vat_amount/100, 2);
				     }
				     document.getElementById("confirm_total_amount").innerHTML = "€ " + preciseTaxes(details_total_amount/100, 2);
				     document.getElementById("vat_rate_for_server").value = details_vat_rate;
				     document.getElementById("vat_amount_for_server").value = details_vat_amount;
				     document.getElementById("total_amount_for_server").value = details_total_amount;
				     document.getElementById("ajax_form_message").style.display = "none";
				     document.getElementById("ajax_form_confirm").style.display = "block";
			    }
			  };
 			xhttp.open("POST", "/fix_problem_confirm_with_card", true);
			xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
			xhttp.setRequestHeader('X-CSRF-TOKEN', at);
			xhttp.send(string_for_server);
 		}
 	});
});