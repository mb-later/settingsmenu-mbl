window.addEventListener("message", function (event) {   
    
    if (event.data.action == "opennnui") {
        if (event.data.job == "police") {
            console.log("polis")
        } else {
            $(".gpskapat").css({"display":"none"})
        }
        setTimeout(function() {
        $(".container").fadeIn(750, function() {
        $(".container").css({"display":"block"})
        
        });
    }, 10)
} else if (event.data.action == "closenui") {
    setTimeout(function() {
        $(".container").fadeOut(750, function() {
        $(".container").css({"display":"none"});
      });
    }, 10)  
    }
});

