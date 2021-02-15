
	function preciseTaxes( num, precision ) {
		    return (+(Math.round(+(num + 'e' + precision)) + 'e' + -precision)).toFixed(precision);
		}
	
	function startCountry() {
		var ip = "<%= @ip_address %>";
		var ip_country = "<%= @country_code %>"; 
		
		document.getElementById('ip_address_for_server').value = ip;
		document.getElementById('ip_country_code_for_server').value = ip_country;
		document.getElementById('select_residence_country').options[ip_country].selected = true;
	}
	
	function startAmount() {
		var setup_amount = 2500;
		
		document.getElementById("plan_amount_for_server").value = setup_amount;
		document.getElementById("plan_amount").innerHTML = preciseTaxes(parseFloat(setup_amount/100), 2);
		
	}
	
	function setAmount(clicked_value) {
		var setup_amount = parseFloat(clicked_value/100);
		
		document.getElementById("plan_amount").innerHTML = preciseTaxes(setup_amount, 2);
		document.getElementById("plan_amount_for_server").value = clicked_value;
	}
	
	function setEmail() { 
	 		document.getElementById("email_for_server").value = document.getElementById("customer_email").value;
	 	}
	
	function changeResidence() {
			var select_country = document.getElementById('select_residence_country').value;
			document.getElementById('residence_country_code_for_server').value = select_country;
		}
	
	function getSetup() {
	  var xhttp = new XMLHttpRequest();
	  xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {
	     var details = JSON.parse(this.responseText);
	     document.getElementById("card-button").setAttribute("data-secret", details["secret"]);
	     document.getElementById("stripe_payment_intent_for_server").value = details["payment_intent"];
	     document.getElementById("stripe_setup_intent_for_server").value = details["setup_intent"];
	     document.getElementById("customer_email").onfocus = null;
	     document.getElementById("card-element").onmouseover = null;
	    }
	  };
	  xhttp.open("GET", "/stripe_get_payment_intent", true);
	  xhttp.send();
	}
	
	function checkUser() {
		var at = document.getElementById("authenticity_token").value;
 		var em = document.getElementById("email_for_server").value;
 		var string_for_server = 
 			'email_for_server=' + em 
 			+ '&authenticity_token=' + at;
 			
 		var xhttp = new XMLHttpRequest();
 			xhttp.onreadystatechange = function() {
 				if (this.readyState == 1 || 2 || 3) {
					    	var content = 'Checking your email address…<br />' + '<img src="<%= asset_path('ajax-loader.gif') %>" class="ajax_form_message_image" id="ajax_form_message_image" />';
					    	document.getElementById("ajax_form_message").style.display = "block";
					    	document.getElementById("ajax_form_message").innerHTML = content;
					    }
			    if (this.readyState == 4 && this.status == 499) {
			    	var details = JSON.parse(this.responseText);
			    	document.getElementById("ajax_form_message").style.display = "block";
			    	document.getElementById("ajax_form_message").innerHTML = details["message"];
				}
				
				if (this.readyState == 4 && this.status == 200) {
			    	
				}
				
 			}
 		xhttp.open("POST", "/check_if_user", true);
		xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xhttp.setRequestHeader('X-CSRF-TOKEN', at);
		xhttp.send(string_for_server);
	}
	
	function setupExistingpayment() {
		var at = document.getElementById("authenticity_token").value;
 		var pa = document.getElementById("plan_amount_for_server").value;
 		var ipc = document.getElementById("ip_country_code_for_server").value;
		
		var string_for_server = 
			'&authenticity_token=' + at 
 			+ '&plan_amount_for_server=' + pa 
 			+ '&ip_country_code_for_server=' + ipc;
		
		var xhttp = new XMLHttpRequest();
		  xhttp.onreadystatechange = function() {
		    if (this.readyState == 1 || 2 || 3) {
		    	var content = 'Doing some sums for the tax man…<br />' + '<img src="<%= asset_path('ajax-loader.gif') %>" class="ajax_form_message_image" id="ajax_form_message_image" />';
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
			     document.getElementById("button_existing_payment_method").style.display = "none";
			     document.getElementById("ajax_form_confirm").style.display = "block";
		    }
		  };
 		xhttp.open("POST", "/stripe_credit_card", true);
		xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xhttp.setRequestHeader('X-CSRF-TOKEN', at);
		xhttp.send(string_for_server);
	}
	
	function confirmPayment() {
		var e = document.getElementById("email_for_server").value;
 		var at = document.getElementById("authenticity_token").value;
 		var cid = document.getElementById("frame_id_for_server").value;
 		var cls = document.getElementById("frame_link_slug_for_server").value;
 		var ceq = document.getElementById("frame_emotional_quest_action_for_server").value;
 		var cmw = document.getElementById("frame_money_word_singular_for_server").value;
 		var cbt = document.getElementById("frame_button_cta_for_server").value;
 		var aid = document.getElementById("article_id_for_server").value;
 		var ref = document.getElementById("referrer_for_server").value;
 		var ipa = document.getElementById("ip_address_for_server").value;
 		var ipc = document.getElementById("ip_country_code_for_server").value;
 		var pa = document.getElementById("plan_amount_for_server").value;
 		var va = document.getElementById("vat_amount_for_server").value;
 		var ta = document.getElementById("total_amount_for_server").value;
 		var string_for_server = 
 		'email_for_server=' + e
 		+ '&authenticity_token=' + at
 		+ '&frame_id_for_server=' + cid 
 		+ '&frame_link_slug_for_server=' + cls
 		+ '&frame_emotional_quest_action_for_server=' + ceq
 		+ '&frame_money_word_singular_for_server=' + cmw 
 		+ '&frame_button_cta_for_server=' + cbt
 		+ '&article_id_for_server=' + aid
 		+ '&referrer_for_server=' + ref
 		+ '&ip_address_for_server=' + ipa
 		+ '&ip_country_code_for_server=' + ipc 
 		+ '&plan_amount_for_server=' + pa 
 		+ '&vat_amount_for_server=' + va 
 		+ '&total_amount_for_server=' + ta;
 	
		var xhttp = new XMLHttpRequest();
		  xhttp.onreadystatechange = function() {
		    if (this.readyState == 1 || 2 || 3) {
		    	var content = 'Confirming your payment now…<br />' + '<img src="<%= asset_path('ajax-loader.gif') %>" class="ajax_form_message_image" id="ajax_form_message_image" />';
		    	document.getElementById("ajax_form_message").style.display = "block";
		    	document.getElementById("ajax_form_message").className = "margin-top-10 padding-10 alert-warning";
		    	document.getElementById("ajax_form_message").innerHTML = content;
		    }
		    if (this.readyState == 4 && this.status == 499) {
		    	var details = JSON.parse(this.responseText);
		    	document.getElementById("ajax_form_message").style.display = "block";
		    	document.getElementById("ajax_form_message").innerHTML = details["message"];
		    	document.getElementById("confirm_first_payment").style.display = "none";
		    	document.getElementById("confirm_sca_payment").setAttribute("data-secret", details["secret"]);
		    	document.getElementById("confirm_sca_payment").style.display = "block";
		    }
		    if (this.readyState == 4 && this.status == 400) {
		    	var details = JSON.parse(this.responseText);
		    	document.getElementById("ajax_form_message").style.display = "block";
		    	document.getElementById("ajax_form_message").className = "margin-top-10 padding-10 alert-error";
		    	document.getElementById("ajax_form_message").innerHTML = details["message"];
		    }
		    if (this.readyState == 4 && this.status == 200) {
		     document.getElementById("ajax_form_message").style.display = "none";
		     document.getElementById("ajax_form_confirm").style.display = "none";
		     document.getElementById("ajax_form_welcome").style.display = "block";
		     document.getElementById("ajax_form_welcome_existing").style.display = "inline";
		    }
		    if (this.readyState == 4 && this.status == 201) {
		     document.getElementById("ajax_form_message").style.display = "none";
		     document.getElementById("ajax_form_confirm").style.display = "none";
		     document.getElementById("ajax_form_welcome").style.display = "block";
		     document.getElementById("ajax_form_welcome_new").style.display = "inline";
		    }
		  };
 		xhttp.open("POST", "/stripe_first_payment", true);
		xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xhttp.setRequestHeader('X-CSRF-TOKEN', at);
		xhttp.send(string_for_server);
	}
	
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
	
	function sendError(result) {
		// Get bits for server
 			var at = document.getElementById("authenticity_token").value;
 			var pi = document.getElementById("stripe_payment_intent_for_server").value;
 			var sta = (result.error.payment_intent == undefined) ? result.error.setup_intent.status : result.error.payment_intent.status;
 			var obj = (result.error.payment_intent == undefined) ? result.error.setup_intent.object : result.error.payment_intent.object;
 			
 			var e_obj = obj;
 			var e_sta = sta;
 			var e_cod = result.error.decline_code;
 			var e_mes = result.error.message;
 			
 			// Compose string for server
 			var string_for_server = 
 				'stripe_payment_intent_for_server=' +  pi
 				+ '&authenticity_token=' + at 
 				+ '&payment_error_object=' + e_obj 
 				+ '&payment_error_status=' + e_sta 
 				+ '&payment_error_code=' + e_cod 
 				+ '&payment_error_message=' + e_mes 
 				;
 			
 			// Send it all to the server
 			var xhttp = new XMLHttpRequest();
 			
 			// Display the server solution message to the user
 			xhttp.onreadystatechange = function() {
 				if (this.readyState == 1 || 2 || 3) {
		    	var content = 'Checking card…<br />' + '<img src="<%= asset_path('ajax-loader.gif') %>" class="ajax_form_message_image" id="ajax_form_message_image" />';
		    	document.getElementById("ajax_form_message").style.display = "block";
		    	document.getElementById("ajax_form_message").className = "margin-top-10 padding-10 alert-warning";
		    	document.getElementById("ajax_form_message").innerHTML = content;
 				}
 				
 				if (this.readyState == 4 && this.status == 400) {
	 				var details = JSON.parse(this.responseText);
	 				document.getElementById("ajax_form_message").style.display = "block";
	 				document.getElementById("ajax_form_message").className = "margin-top-10 padding-10 alert-error";
					document.getElementById("ajax_form_message").innerHTML = details["message"];
 				}
 				
 				if (this.readyState == 4 && this.status == 477) {
	 				var details = JSON.parse(this.responseText);
	 				document.getElementById("ajax_form_message").style.display = "block";
					document.getElementById("ajax_form_message").innerHTML = details["message"];
 				}
 			}
 			
 			xhttp.open("POST", "/new_payment_error", true);
			xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
			xhttp.setRequestHeader('X-CSRF-TOKEN', at);
			xhttp.send(string_for_server);
	}
	
	window.addEventListener('load', function () {    
	   	startCountry();
	   	startAmount();
	   	setEmail();
		changeResidence();
	}, false);