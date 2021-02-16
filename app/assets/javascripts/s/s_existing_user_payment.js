// For processing a payment by a reader with an ALREADY EXISTING Stripe payment method
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
	    	var content = 'Doing some sums for the tax man…<br />' + '<img src="<%= asset_path(\'ajax-loader.gif\') %>" class="ajax_form_message_image" id="ajax_form_message_image" />';
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