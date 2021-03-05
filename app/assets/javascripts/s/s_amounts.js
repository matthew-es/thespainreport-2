// Calculate properly rounded amounts for tax calculations
function preciseTaxes( num, precision ) {
	    return (+(Math.round(+(num + 'e' + precision)) + 'e' + -precision)).toFixed(precision);
	}


// Format the price right in each language
function priceLanguage(amount) {
	var price_language = document.getElementById("language_for_server").value;
	
	if (price_language == "1") {
		price_format = "€" + preciseTaxes(parseFloat(amount/100), 2) + "/month";
	} else if (price_language == "2") {
		price_format = preciseTaxes(parseFloat(amount/100), 2) + " euros al mes";
	}
}


// How much does the reader want to contribute?
function setAmount(amount) {
	priceLanguage(amount);
	
	document.getElementById("plan_amount").value = amount;
	document.getElementById("plan_amount_for_server").value = amount;
	document.getElementById("plan_amount").style.cssText = "color: black; background-color: #ffe4b3;";
	
	document.getElementById("plan_amount").style.borderColor = "red";
}


// Super patrons: how much does he want to contribute?
function setSuperAmount(amount) {
	document.getElementById("plan_amount").value = amount;
	new_amount = document.getElementById("plan_amount");
}


// Check the invoice deatils are minimally filled in...
function checkVatDetails() {
	var na = document.getElementById("invoice_name").value.length
	var id = document.getElementById("invoice_tax_id").value.length
	var ad = document.getElementById("invoice_address").value.length
	
	
	if (na == 0) {
		document.getElementById("card-button").disabled = true;
		document.getElementById("invoice_name").style.cssText = "border: orange 2px solid; outline-color: orange; color: orange;";
	}
	else if (na < 7) {
		document.getElementById("card-button").disabled = true;
		document.getElementById("invoice_name").style.cssText = "border: red 2px solid; outline-color: red; color: red;";
	} else if (na >= 7) {
		document.getElementById("invoice_name").style.cssText = "border: green 2px solid; outline-color: green; color: green;";
	}
	
	
	if (id == 0) {
		document.getElementById("card-button").disabled = true;
		document.getElementById("invoice_tax_id").style.cssText = "border: orange 2px solid; outline-color: orange; color: orange;";
	}
	else if (id < 7) {
		document.getElementById("card-button").disabled = true;
		document.getElementById("invoice_tax_id").style.cssText = "border: red 2px solid; outline-color: red; color: red;";
	} else if (id >= 7) {
		document.getElementById("invoice_tax_id").style.cssText = "border: green 2px solid; outline-color: green; color: green;";
	}
	
	
	if (ad == 0) {
		document.getElementById("card-button").disabled = true;
		document.getElementById("invoice_address").style.cssText = "border: orange 2px solid; outline-color: orange; color: orange;";
	}
	else if (ad < 7) {
		document.getElementById("card-button").disabled = true;
		document.getElementById("invoice_address").style.cssText = "border: red 2px solid; outline-color: red; color: red;";
	} else if (ad >= 7) {
		document.getElementById("invoice_address").style.cssText = "border: green 2px solid; outline-color: green; color: green;";
	}


	if (na >= 7 && id >= 7 && ad >= 7) {
		document.getElementById("card-button").disabled = false;
		checkEmail();
	}
}


// Super patrons: check how much is in the box...
function checkAmount() {
	var amount_max = 2000;
	var amount_min = 5;
	var amount_vat = 330;
	var amount = to_check.value;
	
	if (amount <= amount_max && amount >= amount_min) {
		document.getElementById("plan_amount").style.cssText = "border: green 2px solid; outline-color: green; color: green;";
		document.getElementById("customer_email").disabled = false;
		document.getElementById("card-button").disabled = false;
		
		if (amount >= amount_vat) {
			document.getElementById("invoice_details").style.display = "block";
			document.getElementById("card-button").disabled = true;
			checkVatDetails();
		}
		if (amount < amount_vat) {
			document.getElementById("invoice_details").style.display = "none";
		}
		
		document.getElementById("payment_form_errors").style.display = "none";
	}
	
	if (amount > amount_max || amount < amount_min || amount % 5 != 0) {
		document.getElementById("plan_amount").style.cssText = "border: red 2px solid; outline-color: red; color: red;";
		document.getElementById("invoice_details").style.display = "none";
		document.getElementById("payment_form_errors").style.display = "inline";
		document.getElementById("customer_email").disabled = true;
		document.getElementById("card-button").disabled = true;
	}
	
	document.getElementById("plan_amount_for_server").value = (amount * 100);
}


// Set tax name
function setTaxName() {
	document.getElementById("invoice_name_for_server").value = document.getElementById("invoice_name").value;
}

// Set tax id
function setTaxId() {
	document.getElementById("invoice_tax_id_for_server").value = document.getElementById("invoice_tax_id").value;
}

// Set tax address
function setTaxAddress() {
	document.getElementById("invoice_address_for_server").value = document.getElementById("invoice_address").value;
}