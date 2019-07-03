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

    /* reset filters */
    $("#filter-reset-button").click(function() {
        $(".single_checkbox").each(function () {
            $(this).find('input').prop({"checked": false});
            $(this).children(".label").css({"background-color":"#fff0d1"});
        })
    });
    
    /* pagination */

    let itemsPerPage = 10;
    let numResources = $(".resource-container").length
    let numPages = Math.ceil(numResources / itemsPerPage);

    let openPage = function(pageNum) {
        currentPage = pageNum;
        let start = ((pageNum - 1) * itemsPerPage) + 1;
        let end = (pageNum * itemsPerPage);
        let count = 1;
        $(".resource-container").each(function() {
            if (count >= start && count <= end) {
                $(this).removeClass("hidden-resource");
            } else {
                $(this).addClass("hidden-resource");
            }
            count++;
        });
    }

    let setActive = function() {
        let count = 1;
        $(".page-item").each(function() {
            if (count === Number(currentPage)) {
                $(this).addClass("active"); 
            }
            count++;
            if (count > numPages) {
                count = 1;
            }
        });
    }

    for (let i = 1; i <= numPages; i++) {
        $(".pagination").append('<li class="page-item"><p class="page-link">' + i + '</p></li>');
    }
    $(".pagination").append('<li class="page-arrow next disabled" id="next"><p id="nextLink" class="page-link nextLink">Next</p></li>');
    if (numPages > 1) {
        $(".next").removeClass("disabled")
    }
    $(".resource-container").addClass("hidden-resource");

    openPage(1);
    setActive(1);
    var currentPage = 1;

    $(".page-link").click(function() {
        if($(this).hasClass("nextLink")) {
            openPage(Number(currentPage) + 1);
        } else if ($(this).hasClass("prevLink")){
            openPage(Number(currentPage) - 1);
        } else {
            openPage($(this).text());
        }
        
    });

    $(".page-item").click(function() {
        $(".page-item").removeClass("active");
        setActive();

        if (currentPage < numPages) {
            $(".next").removeClass("disabled");
        } else {
            $(".next").addClass("disabled");
        }
        if ((currentPage >= 2)) {
            $(".prev").removeClass("disabled");
        } else {
            $(".prev").addClass("disabled");
        }    
    });

    $(".page-arrow").click(function() {
        $(".page-item").removeClass("active"); 
        if ($(this).hasClass("next") && currentPage >= numPages) {
            $(".next").addClass("disabled");
            $(".prev").removeClass("disabled")
        } else if ($(this).hasClass("prev") && currentPage <= 1) {
            $(".prev").addClass("disabled");
            $(".next").removeClass("disabled")
        } else {
            $(".page-arrow").removeClass("disabled")
        }

        setActive();
    });

    

    

    

    /* implementation to show/hide results based on filters selected */

    /* data structure to store all resources */
    // let resources = [];
    // $('.resource_information').each(function(i, resource) {
    //     console.log(resource.props);
    //     resources.push(resource.data('resource'));
    // });
    // console.log(resources);


    // $(".single_checkbox").click(function() {
    //     let association = $(this).find(".label")[0].textContent
    //     console.log(association);

    //     $(".resource-container").each(function() {
    //         console.log($(this).find());
    //         // if (count >= start && count <= end) {
    //         //     $(this).removeClass("hidden-resource");
    //         // } else {
    //         //     $(this).addClass("hidden-resource");
    //         // }
    //         // count++;
    //     });
    // });




});