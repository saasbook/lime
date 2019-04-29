$(document).ready(function() {

    $( function() {
        $( "#deadline" ).datepicker({

        });
    } );

    let form_button = document.getElementById("submit_button");
    if (form_button.addEventListener){
        form_button.addEventListener("click", validate, false);  //Modern browsers
    }else if(form_button.attachEvent){
        form_sbutton.attachEvent('onsubmit', validate);            //Old IE
    }

    function validate(e) {
        if ($("#desc").val() != "" && $("#desc").val().match(/(\w+)/g).length > 500) {
            $("#message").show();
            $("#message").text("Description was too long.");
            $("#message").css("color", "red");
        } else if($("#contact_email").val() === "" || $("#title").val().length === "" || $("#url").val().length === "" || $("#desc").val() === ""){
            findRequiredFields();
            $("#message").show();
            $("#message").text("Please fill in the required fields.");
            $("#message").css("color", "red");
        } else {
            $("#form_section").submit();
            $("#message").show();
            $("#message").text("Your resource has been successfully submitted and will be reviewed!");
            $("#message").css("color", "green");
            $("#submit_button").attr("disabled", true);
            $("#submit_button").text("Submitted!");
            $("#submit_button").css("background-color", "green");
        }
    }

    function findRequiredFields() {
        if($("#contact_email").val() === "") {
            $("#contact_email").addClass("required_field");
        } else {
            $("#contact_email").removeClass("required_field");
        }
        if($("#title").val() === "") {
            $("#title").addClass("required_field");
        } else{
            $("#title").removeClass("required_field");
        }
        if($("#url").val() === "") {
            $("#url").addClass("required_field");
        } else {
            $("#url").removeClass("required_field");
        }
        if($("#desc").val() === "") {
            $("#desc").addClass("required_field");
        } else {
            $("#desc").removeClass("required_field");
        }
    }

    document.getElementById("contact_email").addEventListener("change", function(e) {
        if (!validateEmail($("#contact_email").val())) {
            $("#email-valid").show();
        } else {
            $("#email-valid").hide();
        }
    });

    document.getElementById("contact_phone").addEventListener("change", function(e) {
        if (!validatePhone($("#contact_phone").val())) {
            $("#phone-valid").show();
        } else {
            $("#phone-valid").hide();
        }
    });
    
    function validateEmail(email) {
        let pattern = new RegExp(/^[+a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i);
        return pattern.test(email);
    }

    function validatePhone(phone) {
        let pattern = new RegExp(/^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/i);
        return pattern.test(phone);
    }
});
