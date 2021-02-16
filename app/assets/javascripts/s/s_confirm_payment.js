// Presented with invoice elements, amount, VAT, user clicks confirm...

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
 	+ '&plan_amount_for_server=' + pa 
 	+ '&vat_amount_for_server=' + va 
 	+ '&total_amount_for_server=' + ta;
 
	var xhttp = new XMLHttpRequest();
	  xhttp.onreadystatechange = function() {
	    if (this.readyState == 1 || 2 || 3) {
	    	var content = 'Confirming your payment now…<br />' + '<img src="<%= asset_path(\'ajax-loader.gif\') %>" class="ajax_form_message_image" id="ajax_form_message_image" />';
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