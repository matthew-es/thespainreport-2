// Calculate properly rounded amounts for tax calculations
function preciseTaxes( num, precision ) {
	    return (+(Math.round(+(num + 'e' + precision)) + 'e' + -precision)).toFixed(precision);
	}


// Format the price right in each language
function priceLanguage(amount) {
	var price_language = document.getElementById("language_for_server").value;
	console.log(price_language);
	console.log(amount);
	
	if (price_language == "1") {
		price_format = "€" + preciseTaxes(parseFloat(amount/100), 2) + "/month";
	} else if (price_language == "2") {
		price_format = preciseTaxes(parseFloat(amount/100), 2) + " euros al mes";
	}
}


// How much does the reader want to contribute?
function setAmount(amount) {
	priceLanguage(amount);
	
	document.getElementById("plan_amount").innerHTML = price_format;
	document.getElementById("plan_amount_for_server").value = amount;
	document.getElementById("plan_amount").style.cssText = "color: black; background-color: #ffe4b3;";
}