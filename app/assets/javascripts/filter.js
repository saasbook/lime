$(document).ready(function() {

    /* checkboxes */
    
    $(".single_checkbox").each(function () {
        if($(this).find('input[type="checkbox"]').prop("checked") == true){
            $(this).children(".label").css({"background-color":"#96CAE7"});
        }
    });
    
    $(".single_radio").each(function () {
        if($(this).find('input[type="radio"]').prop("checked") == true){
            $(this).children(".label").css({"background-color":"#96CAE7"});
        }
    });


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


    /* pagination */

    let numResources = $(".resource-container").length
    console.log(numResources);
    let numPages = Math.ceil(numResources / 10);
    console.log(numPages);

    for (let i = 2; i <= numPages; i++) {
        $(".pagination").append('<li class="page-item"><a class="page-link" href="#' + i + '">' + i + '</a></li>');
    }
    if (numPages === 1) {
        $(".pagination").append('<li class="page-item disabled"><a class="page-link" href="#" aria-label="Next"><span aria-hidden="true">&raquo;</span><span class="sr-only">Next</span></a></li>')
    } else {
        $(".pagination").append('<li class="page-item"><a class="page-link" href="#" aria-label="Next"><span aria-hidden="true">&raquo;</span><span class="sr-only">Next</span></a></li>')
    }

    $(".resource-container").addClass("hidden-resource");
    let count = 0;
    $(".resource-container").each(function() {
        if (count < 10) {
            console.log($(this));
            $(this).removeClass("hidden-resource");
            count++;
        }
    });





});