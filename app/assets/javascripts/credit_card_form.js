$(document).ready(function () {
  var show_error, stripeResponseHandler, submitHandler;

  // function to handle the submit of the form and intercept the default event
  submitHandler = function (event) {
    var $form = $(event.target);
    $form.find("input[type=submit]").prop("disabled", true);
    if (Stripe){
      Stripe.card.createToken($form, stripeResponseHandler);
    } else {
      show_error("Failed to load credit card processing functionality. Please reload the page");
    }
    return false;
  }
  // initiate submit handler listener for any form with class cc_form
  $(".cc_form").on('submit', submitHandler);

  // function to handle plan drop down changing
  var handlePlanChange = function (plan_type, form) {
    console.log("Plan change", "Plan type: ", plan_type);
    var $form = $(form);

    if (plan_type == undefined) {
      plan_type = $('#tenant_plan :selected').val();
    } else if (plan_type == 2 /* Premium */) {
      $('[data-stripe]').prop('required', true);
      $form.off('submit');
      $form.on('submit', submitHandler);
      $('[data-stripe]').show();
    } else if (plan_type == 1 /* Free */) {
      $('[data-stripe]').hide();
      $('[data-stripe]').removeProp('required');
      $('[data-stripe]').val('');
      $form.off('submit');
    }
  }
  // Call it on load.
  handlePlanChange($('#tenant_plan :selected').val(), ".cc_form");

  // set up plan change event listener #tenant_plan in the forms for cc_form
  $("#tenant_plan").on('change', function(event){
    handlePlanChange($('#tenant_plan :selected').val(), ".cc_form");
  });

  // function to handle the token received from stripe and remove cc fields
  stripeResponseHandler = function (status, response) {
    var token, $form;
    $form = $('.cc_form');

    if (response.error){
      console.log(response.error.message);
      show_error(response.error.message);
      $form.find("input[type=submit]").prop("disabled", false);
    } else {
      token = response.id;
      $form.append($("<input type=\"hidden\" name=\"payment[token]\">").val(token));

      const selectors = ["[data-stripe=number]", "[data-stripe=cvv]", "[data-stripe=exp-year]", "[data-stripe=exp-month]", "[data-stripe=label]"];

      selectors.forEach((selector) => {
        const element = $(selector);
        if (element.length) {
          element.remove();
        }
      });

      $form.get(0).submit();
    }
    return false;
  }

  // function to show errors when stripe functionality errors.
  show_error = function (message) {
    if ($("#flash_messages").size() < 1) {
      $('div.container.main div:first').prepend("<div id='flash-messages'></div>");
    }

    $("#flash_messages").html('<div class="alert alert-warning"><a class="close" data-dismiss="alert">x</a><div id="flash_alert">' + message + '</div></div>');
    $('.alert').delay(5000).fadeOut(3000);
    return false;
  }
});