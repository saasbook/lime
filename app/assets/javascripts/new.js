$(document).ready(function() {
    // jQuery(document).ready(function($) {
    //     $(document).foundation();
    //     console.log("testststs");
    //     });

    $( function() {
        $( "#deadline" ).datepicker({

        });
    } );


    jQuery('document').ready(function() {
        if($('#new').length){
        console.log("element exists");
        }
    });

    let contact_email = document.getElementById("contact_email");
    // contact_email.addEventListener('change', requiredFields);

    let form_section = document.getElementById("form_section");
    let form_button = document.getElementById("submit_button");
    // if (form_section.addEventListener){
    //     form_section.addEventListener("submit", validate, false);  //Modern browsers
    // }else if(form_button.attachEvent){
    //     form_section.attachEvent('onsubmit', validate);            //Old IE
    // }

    if (form_button.addEventListener){
        form_button.addEventListener("click", validate, false);  //Modern browsers
    }else if(form_button.attachEvent){
        form_sbutton.attachEvent('onsubmit', validate);            //Old IE
    }

    function validate(e) {
        console.log($("#desc").val() == "")
        // let desc_length = $("#desc").val().match(/(\w+)/g).length;
        if ($("#desc").val() != "" && $("#desc").val().match(/(\w+)/g).length > 500) {
            $("#message").show();
            $("#message").text("Description was too long.");
            $("#message").css("color", "red");
        } else if($("#contact_email").val().length <= 0 || $("#title").val().length <= 0 || $("#url").val().length <= 0 || $("#desc").val().length <= 0){
            // e.preventDefault();    //stop form from submitting
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

    function requiredFields() {

    }

});
