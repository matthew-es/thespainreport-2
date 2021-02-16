// For...
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