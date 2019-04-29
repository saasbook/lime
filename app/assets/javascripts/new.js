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

    let form_button = document.getElementById("submit");
    if (form_button.addEventListener){
        form_button.addEventListener("submit", validate(e), false);  //Modern browsers
    }else if(ele.attachEvent){
        form_button.attachEvent('onsubmit', validate);            //Old IE
    }

    function validate(e) {
        if(!isValid){
            e.preventDefault();    //stop form from submitting
            console.log("fill required fields");
        }
    }

    function requiredFields() {

    }