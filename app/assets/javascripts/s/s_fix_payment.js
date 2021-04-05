// Get setup intent for card...

function getSetup() {
    document.getElementById("customer_email").onfocus = null;
    document.getElementById("customer_email").onmouseover = null;
    document.getElementById("card-element").onmouseover = null;
    
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
         var details = JSON.parse(this.responseText);
         document.getElementById("card-button").setAttribute("data-secret", details["secret"]);
         document.getElementById("stripe_setup_intent_for_server").value = details["setup_intent"];
         document.getElementById("stripe_payment_intent_for_server").value = document.getElementById("payment_to_fix").getAttribute("data-payment");
         document.getElementById("residence_country_code_for_server").value = document.getElementById("payment_to_fix").getAttribute("data-country");
        }
  };
  xhttp.open("GET", "/stripe_get_payment_intent", true);
  xhttp.send();
}

// Handle form submission.
var confirmButton = document.getElementById('confirm-button');
stripe.handleCardAction(confirmButton.dataset.secret).then(function(result) {
    // Handle result.error or result.paymentIntent
    console.log(result)
  });