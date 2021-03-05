// What is new reader's email?
	function setEmail() { 
	 		document.getElementById("email_for_server").value = document.getElementById('customer_email').value;
	 	}
	 	
// What is existing reader's email?
	function setExistingEmail() { 
	 		document.getElementById("email_for_server").value = document.getElementById('customer_email').getAttribute('data-email');
	 	}

// Is it probably a valid email address..?
function checkEmail(email) {
	var email = document.getElementById("customer_email").value;
	var email_length = email.length;

	var email_at = email.indexOf("@");
	var email_at_count = (email.match(/@/g) || []).length;

	var email_dot = email.lastIndexOf(".");
	var email_dot_before_at = email.search(/\.@/);
	var email_dot_after_at = email.search(/@\./);
	var two_dots = email.search(/\.\./);

	var email_domain = (email.substr(email.lastIndexOf('.')+1));
	var email_domain_length = email_domain.length;
	
	var at_minus_dot = email_at - email_dot;
	var between_at_dot = email.substring(email.lastIndexOf("@") + 1, email.lastIndexOf(".")).length;
	
	var dont_want_these = email.search(/,|:|;/);
	
	if (email_length == 0) {
		document.getElementById("card-button").disabled = true;
		document.getElementById("customer_email").style.cssText = "border: orange 2px solid; outline-color: orange; color: orange;";
	}	
	else if (email_length >= 7 && email_at !== -1 && email_at !== 0 && email_at_count == 1 && email_dot !== -1 && two_dots == -1 && email_dot_before_at == -1 && email_dot_after_at == -1 && at_minus_dot < 0 && between_at_dot > 1 && email_domain_length >= 2 && dont_want_these == -1) {
		document.getElementById("card-button").disabled = false;
		document.getElementById("customer_email").style.cssText = "border: green 2px solid; outline-color: green; color: green;";
	}	
	else {
		document.getElementById("card-button").disabled = true;
		document.getElementById("customer_email").style.cssText = "border: red 2px solid; outline-color: red; color: red;";
	}
	
}