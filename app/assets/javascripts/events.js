var test;
$(function() {
  $("#vol_checkin_form").on('submit', function(event) {
    event.preventDefault();
    $.ajax({
      url: "/events/checkin",
      type: "POST",
      data: $(this).serialize(),
      success: function(data, status, jqxhr) {
        var newrow = "<tr class='newrow' style='display:none;'><td>" + data.name + "</td><td>" + data.checkin_time + "</td></tr>"
        $("tr#header").after(newrow);
        $(".newrow").show('slow');
        $("#vol_checkin_form").trigger('reset');
        $("#vol_checkin_terms").hide();
        $("#vol_message").removeClass();
        $("#vol_message").addClass('alert alert-success');
        $("#vol_message").text("Thanks for checking in!");
        $("#vol_message").show('slow');
      }
    });
  });
  $("#checkin_email").on('focusin', function(event) {
    $("#vol_checkin_ml").hide();
    $("#vol_message").hide('slow');
    $("#ml_signup_check").attr('checked', false);
  });
  
  $("#checkin_email").on('focusout', function(event) {
    var em = $(this).val();
    if (em.match(/@/)) {
      $.ajax({
        url: "/events/check_email",
        dataType: "json",
        type: "POST",
        data: "email=" + em + "&event=" + $("#checkin_event").val(),
        success: function(data, status, jqxhr) {
          $("#checkin_fname").val(data.fname)
          $("#checkin_lname").val(data.lname)
          if (!data.terms) {
            $("#vol_checkin_terms").show(400);
          }
          $("#vol_checkin_btn").attr('disabled', false);
          if (data.fname.length === 0) {
            $("#ml_signup_check").attr('checked', true);
            $("#vol_checkin_ml").show();
          }
        },
        statusCode: {
          208: function() {
            $("#vol_checkin_form").trigger('reset');
            $("#vol_checkin_terms").hide();
            $("#vol_message").removeClass();
            $("#vol_message").addClass('alert alert-info');
            $("#vol_message").text("You have already checked in — thanks!");
            $("#vol_message").show('slow');
          }
        }
         
      });
    }
  });
});
