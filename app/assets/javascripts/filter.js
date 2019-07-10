$(document).ready(function() {
    
     /* checkboxes */
    
     $(".single_checkbox").each(function () {
        if($(this).find('input[type="checkbox"]').prop("checked") == true || $(this).find('input[type="radio"]').prop("checked") == true){
            $(this).children(".label").css({"background-color":"#96CAE7"});
        }

    });


    $(".single_checkbox").click(function() {
        if ($(this).find('input[type="radio"]').prop("checked") == false) {
            if ($(this).hasClass("loc_label")) {
                if ($(this).hasClass("gold_label")) {
                    $(".loc-radio").css({"background-color":"rgb(255, 240, 209)"});
                    
                } else {
                    $(".loc-radio").css({"background-color":"#D8DFEB"});
                }
            } else if ($(this).hasClass("sort_label")) {
                $(".sort-radio").css({"background-color":"rgb(255, 240, 209)"});
            }
        }
        
        if($(this).find('input').prop("checked") == true){
            $(this).find('input').prop({"checked": false});
            if ($(this).hasClass("gold_label")) {
                $(this).children(".label").css({"background-color":"rgb(255, 240, 209)"});
            } else {
                $(this).children(".label").css({"background-color":"#D8DFEB"});
            }
        } else if ($(this).find('input').prop("checked") == false){
            $(this).find('input').prop({"checked": true});
            $(this).children(".label").css({"background-color":"#96CAE7"});
        }
    });
    
    const initial_filter_height = $("#filter-column").height()
    $(window).on('scroll', function () {
        let newHeight = initial_filter_height;
        // TODO get size of the header div, use it for calculations
        if ($(window).scrollTop() > 160) {
            newHeight = initial_filter_height + 180;
            $("#filter-column").stop().animate({height: newHeight, top: 40},200);
        } else {
            newHeight = initial_filter_height + $(window).scrollTop();
            let newTop = 180 - $(window).scrollTop();
            $("#filter-column").stop().animate({height: newHeight, top: newTop},0);
        }
        
        
    });

});