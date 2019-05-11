$(document).ready(function() {
    let unapproved = document.querySelectorAll(".unapproved-resource");
    for (var i = 0; i < unapproved.length; i++) {
        unapproved[i].addEventListener("click", function() {
          let checkBox = $(this).find('input');
          if(checkBox.prop("checked") === true){
            checkBox.prop("checked", false);
            $(this).css({"background-color":"white"});
          } else {
            checkBox.prop("checked", true);
            $(this).css({"background-color":"#FDB515"});
          }
        });
    }
});