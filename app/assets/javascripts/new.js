$(document).ready(function() {
    // $( function() {
    //     $( "#deadline" ).datepicker({

    //     });
    // } );

    let unchecked = document.querySelectorAll(".single_checkbox");
    for (var i = 0; i < unchecked.length; i++) {
        unchecked[i].addEventListener("click", function() {
            if($(this).find('input[type="checkbox"]').prop("checked") == true){
            $(this).find('input[type="checkbox"]').prop({"checked": false});
            $(this).children(".label").css({"background-color":"#D8DFEB"});
            } else {
            $(this).find('input[type="checkbox"]').prop({"checked": true});
            $(this).children(".label").css({"background-color":"#96CAE7"});
            }
        });
    }
    let unradio = document.querySelectorAll(".single_radio");
    for (var i = 0; i < unchecked.length; i++) {
        unradio[i].addEventListener("click", function() {
            if($(this).find('input[type="radio"]').prop("checked") == true){
            $(this).find('input[type="radio"]').prop({"checked": false});
            $(this).children(".label").css({"background-color":"#D8DFEB"});
            } else {
            $(this).find('input[type="radio"]').prop({"checked": true});
            $(".loc-radio").css({"background-color":"#D8DFEB"});
            $(this).children(".loc-radio").css({"background-color":"#96CAE7"});
            }
        });
    }



    function validate() {
        if ($("#desc").val() != "" && $("#desc").val().match(/(\w+)/g).length > 500) {
            $("#message").show();
            $("#message").text("Description was too long.");
            $("#message").css("color", "red");
            return false;
        } else if($("#contact_email").val() === "" || $("#title").val() === "" || $("#url").val() === "" || $("#desc").val() === ""){
            findRequiredFields();
            $("#message").show();
            $("#message").text("Please fill in the required fields.");
            $("#message").css("color", "red");
            return false;
        } else {
            return true;
        }
    }

    $("#form_section").submit(function () {
        if (validate()) {
            return true;
        } else {
            return false;
        }
    });

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

        let no_location = true;
        $("input[type='radio'][name='location']").each(function() {
            if (this.checked) {
                no_location = false;
            }
        });
        if($("#other").val() != "") {
            no_location = false;
        }
        if (no_location) {
            $("#other_location").addClass("checkbox_missing");
            $(".location_radio").each(function () {
                $(this).addClass("checkbox_missing");
            });
        } else {
            $(".location_radio").each(function () {
                $(this).removeClass("checkbox_missing");
            });
        }

        let no_type = true;
        $("input[type='checkbox'][name='types[]']").each(function() {
            if (this.checked) {
                no_type = false;
            }
        });
        if (no_type) {
            $(".type_checkbox").each(function () {
                $(this).addClass("checkbox_missing");
            });
        } else {
            $(".type_checkbox").each(function () {
                $(this).removeClass("checkbox_missing");
            });
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
