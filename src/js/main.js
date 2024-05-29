function randomize_logo() {
    const logo = document.getElementById('logo_img');
    
    var dir = "/img/logo/";
    var imgs = [
        "fishing_with_grandson_md_wht.gif",
        "fishingboat.gif",
        "fishingbobber.gif",
        "Fishingemail.gif",
        "swimfish.gif"
    ]

    var randImg = dir + imgs[
        Math.floor(Math.random() * imgs.length)
    ];

    logo.src = randImg;
}