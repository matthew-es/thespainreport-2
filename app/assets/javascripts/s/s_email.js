// What is new reader's email?
	function setEmail() { 
	 		document.getElementById("email_for_server").value = document.getElementById('customer_email').value;
	 	}
	 	
// What is existing reader's email?
	function setExistingEmail() { 
	 		document.getElementById("email_for_server").value = document.getElementById('customer_email').getAttribute('data-email');
	 	}