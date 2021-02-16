// Calculate properly rounded amounts for tax calculations
function preciseTaxes( num, precision ) {
	    return (+(Math.round(+(num + 'e' + precision)) + 'e' + -precision)).toFixed(precision);
	}

// How much does the reader want to contribute? How much tax is applicable..?

function startAmount() {
	var setup_amount = 2500;
	
	document.getElementById("plan_amount").innerHTML = preciseTaxes(parseFloat(setup_amount/100), 2);
	document.getElementById("plan_amount_for_server").value = setup_amount;
}

function changeAmount(clicked_value) {
	var setup_amount = clicked_value;
	
	document.getElementById("plan_amount").innerHTML = preciseTaxes(parseFloat(setup_amount/100), 2);
	document.getElementById("plan_amount_for_server").value = clicked_value;
}