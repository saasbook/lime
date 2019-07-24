$(document).ready(function() {
    function validate() {
        if ($("#description").val() != "" && $("#description").val().match(/(\w+)/g).length > 500) {
            $("#message").show();
            $("#message").text("Description was too long.");
            $("#message").css("color", "red");
            return false;
        } else if($("#contact_email").val() === "" || $("#title").val() === "" || $("#url").val() === "" || $("#description").val() === ""){
            findRequiredFields();
            $("#message").show();
            $("#message").text("Please fill in the required fields.");
            $("#message").css("color", "red");
            return false;
        } else {
            return true;
        }
    }

    $("#submit_button").click(function () {
        var form = $("#form_section");
        if (validate()) {
            $.ajax({ 
                url   : form.attr('action'),
                type  : form.attr('method'),
                data  : form.serialize()
           });
           $("#message").show();
            $("#message").text("Your resource has been submitted!");
            $("#message").css("color", "green");
            $('#submit_button').attr('disabled','disabled');
            return true;
        } else {
            return false;
        }
    });

    function findRequiredFields() {
        $(".required_input").each(function() {
            if($(this).val() === "") {
                $(this).addClass("required_field");
            } else {
                $(this).removeClass("required_field");
            }
        });
        findRequiredLocation();
        findRequiredTypes();
    }

    function findRequiredLocation() {
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
    }

    function findRequiredTypes() {
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
    
    $(".validate-input").each(function() {
        $(this).change(function(e) {
            let value = $(this).val();
            let type = $(this).attr('id');
            if(!validateInput(value, type)) {
                $("#" + type.substring(8) + "-valid").show();
            } else {
                $("#" + type.substring(8) + "-valid").hide();
            }
        });
    });
    
    function validateInput(input, type) {
        if (type === "contact_email") {
            let pattern = new RegExp(/^[+a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i);
            return pattern.test(input);
        } else if (type === "contact_phone") {
            let pattern = new RegExp(/^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/i);
            return pattern.test(input);
        }
    }
});
