$(document).ready(function() {
    $(".single_checkbox").click(function() {
        if($(this).find('input[type="checkbox"]').prop("checked") == true){
        $(this).find('input[type="checkbox"]').prop({"checked": false});
        if ($(this).hasClass("gold_label")) {
            $(this).children(".label").css({"background-color":"rgb(255, 240, 209)"});
        } else {
            $(this).children(".label").css({"background-color":"#D8DFEB"});
        }
        } else {
        $(this).find('input[type="checkbox"]').prop({"checked": true});
        $(this).children(".label").css({"background-color":"#96CAE7"});
        }
    });
    $(".single_radio").click(function() {
        if($(this).find('input[type="radio"]').prop("checked") == true){
            $(this).find('input[type="radio"]').prop({"checked": false});
            $(this).children(".label").css({"background-color":"#D8DFEB"});
        } else {
            $(this).find('input[type="radio"]').prop({"checked": true});
            $(".loc-radio").css({"background-color":"#D8DFEB"});
            $(this).children(".loc-radio").css({"background-color":"#96CAE7"});
        }
    });
});