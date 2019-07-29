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
    
    /* scroll and width and height changes */
    if ($("#filter-column").length > 0) {
        let navigationHeight = $("body").height();
        const margin = parseInt($("#filter-column").css("margin-top"));
        let initial_filter_height = ($(window).height() - navigationHeight - margin - margin);
        if ($(window).width() >= 750) {
            $("#filter-column").css({height: initial_filter_height});
        }

        $(window).on('resize', function() {
            if ($(window).width() >= 750) {
                navigationHeight = $("body").height();
                initial_filter_height = ($(window).height() - navigationHeight - margin - margin);
                changeSize();
            }
        });

        function changeSize() {
            if ($(window).width() < 750) {
                $("#filter-column").stop().animate({height: "auto", top: 0},0);
            } else {
                navigationHeight = $("body").height();
                let newHeight = initial_filter_height;
                let newTop = navigationHeight - $(window).scrollTop();
                if ($(window).scrollTop() > navigationHeight) {
                    newHeight = initial_filter_height + navigationHeight;
                    newTop = 0;
                    
                } else {
                    newHeight = initial_filter_height + $(window).scrollTop();
                    
                }
                
                if ($(".filter-rows")[0].style.display === "block") {
                    $("#filter-column").stop().animate({height: newHeight, top: newTop},0);
                    
                } else {
                    newHeight = parseInt($("#search-row").css("height")) + parseInt($("#filter-header").css("height")) + 64;
                    $("#filter-column").stop().animate({height: newHeight, top: newTop},0);
                }
            }
            
        }

        
        $(window).on('scroll', changeSize);
        changeSize();
    }
    

});