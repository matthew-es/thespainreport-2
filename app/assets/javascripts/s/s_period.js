// How frequently does the reader want to pay?

function startPeriod() {
	document.getElementById('select_payment_period').options['month'].selected = true;
	document.getElementById('payment_period_for_server').value = 'month';
}

function changePeriod() {
		var select_period = document.getElementById('select_payment_period').value;
		document.getElementById('payment_period_for_server').value = select_period;
	}