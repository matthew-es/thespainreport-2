// Which country does the reader pay taxes in? Defaults to Spain...

function startCountry() {
	document.getElementById('select_residence_country').options['ES'].selected = true;
	document.getElementById('residence_country_code_for_server').value = 'ES';
}

function changeCountry() {
		var select_country = document.getElementById('select_residence_country').value;
		document.getElementById('residence_country_code_for_server').value = select_country;
	}