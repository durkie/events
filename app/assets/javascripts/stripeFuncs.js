$(document).ready(function() {
  $("#payment-form").submit(function(event) {
    $(".payment-errors").text("");
    // disable the submit button to prevent repeated clicks
    $('.submit-button').attr("disabled", "disabled");

    var earlyExit = 0;
    var divs = [".card-expiry-year", ".card-expiry-month", ".card-cvc", ".card-number", ".card-name", ".card-address1", ".card-city", ".card-zip", ".card-state", ".card-country"];

    var amount = Math.floor(($('.charge-amount').val() * 100));
    if (amount < 50) {
        $('.charge-amount').css("background", "#ffff99");
        $(".payment-errors").text("Donation amount must be greater than 50c.");
        earlyExit = 1;
    } else {
        $('.charge-amount').css("background", "#ffffff");
    }

    divs.forEach(function(value) {
        if ($(value).val() === '') {
            $(value).css("background", "#ffff99");
            earlyExit = 1;
        } else {
            $(value).css("background", "#ffff99");
        }
    });

    if (earlyExit) {
        $(".submit-button").removeAttr("disabled");
        return false;
    }

    Stripe.createToken({
        number: $('.card-number').val(),
        cvc: $('.card-cvc').val(),
        exp_month: $('.card-expiry-month').val(),
        exp_year: $('.card-expiry-year').val(),
        name: $('.card-name').val(),
        address_line1: $('.card-address1').val(),
        address_line2: $('.card-address2').val(),
        address_city: $('.card-city').val(),
        address_zip: $('.card-zip').val(),
        address_state: $('.card-state').val(),
        address_country: $('.card-country').val()
    }, stripeResponseHandler);

    // prevent the form from submitting with the default action
    return false;
  });
});

function stripeResponseHandler(status, response) {
    if (response.error) {
        // show the errors on the form
        $(".payment-errors").text(response.error.message);
        $(".submit-button").removeAttr("disabled");
    } else {
        var form$ = $("#payment-form");
        // token contains id, last4, and card type
        var token = response['id'];
        console.log(token);
        // insert the token into the form so it gets submitted to the server
        form$.append("<input type='hidden' name='stripeToken' value='" + token 
+ "'/>");
        // and submit
        form$.get(0).submit();
    }
}
