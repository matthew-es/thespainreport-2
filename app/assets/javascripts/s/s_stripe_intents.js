// Reader has shown interest in payment form, so initialise Stripe, get setup and payment intents back
function getSetup() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
     var details = JSON.parse(this.responseText);
     document.getElementById("card-button").setAttribute("data-secret", details["secret"]);
     document.getElementById("stripe_payment_intent_for_server").value = details["payment_intent"];
     document.getElementById("stripe_setup_intent_for_server").value = details["setup_intent"];
     document.getElementById("customer_email").onfocus = null;
     document.getElementById("card-element").onmouseover = null;
    }
  };
  xhttp.open("GET", "/stripe_get_payment_intent", true);
  xhttp.send();
}