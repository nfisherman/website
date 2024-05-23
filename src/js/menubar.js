/* When the user clicks on the button,
toggle between hiding and showing the dropdown content */
function dropdown(element) {
    hideAll("dropdown-content");
    document.getElementById(element).classList.toggle("show");
}

function hideAll(domClass){
    let elements = document.getElementsByClassName("dropdown-content");

    for(const element of elements){
        if (element.classList.contains('show')) {
            element.classList.remove('show');
        }
    }
}
  
// Close the dropdown menu if the user clicks outside of it
window.onclick = function(event) {
    if (!event.target.matches('.dropbtn')) {
        hideAll("dropdown-content");
    }
}