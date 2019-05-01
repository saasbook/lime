$(document).ready(function() {
    let unapproved = document.querySelectorAll(".unapproved-resource");
    for (var i = 0; i < unapproved.length; i++) {
        unapproved[i].addEventListener("click", function() {

          if($(this).find('input[type="checkbox"]').prop("checked") == true){
            $(this).find('input[type="checkbox"]').prop({"checked": false});
            $(this).css({"background-color":"white"});

          } else {
            $(this).find('input[type="checkbox"]').prop({"checked": true});
            $(this).css({"background-color":"#FDB515"});
          }
          
        });
    }
});