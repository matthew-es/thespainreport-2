function checkUser() {
	var at = document.getElementById("authenticity_token").value;
 	var em = document.getElementById("email_for_server").value;
 	var string_for_server = 
 		'email_for_server=' + em 
 		+ '&authenticity_token=' + at;
 		
 	var xhttp = new XMLHttpRequest();
 		xhttp.onreadystatechange = function() {
 			if (this.readyState == 1 || 2 || 3) {
				    	var content = 'Checking your email address…<br />' + '<img src="<%= asset_path(\'ajax-loader.gif\') %>" class="ajax_form_message_image" id="ajax_form_message_image" />';
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