

$(function() {
    function display(bool) {
        if (bool) {
            document.querySelector(".body").style.display = "block"


        } else {}

    }
    document.querySelector("#kapatma").onclick = () => { document.querySelector(".textt").style.display = "none" };
    display(false)

    window.addEventListener('message', function(event) {

        var item = event.data;

        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }


    })
})