/* When the user clicks on the button,
toggle between hiding and showing the dropdown content */
function dropdown(element) {
    hideAll("dropdown-content", element);
    document.getElementById(element).classList.toggle("show");
}

function hideAll(domClass, ...exceptions) {
    let elements = document.getElementsByClassName("dropdown-content");

    for(const element of elements){
        if (element.classList.contains('show') && !exceptions.includes(element.id)) {
            element.classList.remove('show');
        }
    }
}

function hideExcept(domClass, exceptions) {
    
}
  
// Close the dropdown menu if the user clicks outside of it
window.onclick = function(event) {
    if (!event.target.matches('.dropbtn')) {
        hideAll("dropdown-content");
    }
}