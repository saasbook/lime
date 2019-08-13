$(document).ready(function() {
    $("#flag-btn").click(function () {
        if ($(".flag-form").is(":visible")) {
            $(".flag-form").toggle(500);
            $("#flag-btn").html("Found something incorrect?");
        } else {
            $(".flag-form").toggle(0, () => 
            window.scrollTo(0,document.body.scrollHeight));
            $(".flag-form").css("display", "flex");
            $("#flag-btn").html("Hide form");
        }
        
    });
});