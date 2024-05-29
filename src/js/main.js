function randomize_logo() {
    const logo = document.getElementById('logo_img');
    
    let dir = "/img/logo/";
    let imgs = [
        "fishing_with_grandson_md_wht.gif",
        "fishingboat.gif",
        "fishingbobber.gif",
        "Fishingemail.gif",
        "swimfish.gif"
    ]

    let randImg = dir + imgs[
        Math.floor(Math.random() * imgs.length)
    ];

    logo.src = randImg;
}

function expand_navbar(){
    document.querySelector('#navexpand').style.display = "none";
    document.querySelector('#nav').style.display = "block";
}

function collapse_navbar(){
    document.querySelector('#navexpand').style.display = "block";
    document.querySelector('#nav').style.display = "none";
}

function recently_played(username) {
    let url = 'https://lastfm-last-played.biancarosa.com.br/' + username + '/latest-song';
    
    let a = document.querySelector('#widget');
    let cover = document.querySelector('#cover');
    let song = document.querySelector('#song');
    let album = document.querySelector('#album');
    let artist = document.querySelector('#artist');
    fetch(url)
        .then(function (response) {
            return response.json()
        }).then(function (json) {
            a.href = json['track']['url'];
            cover.src = json['track']['image'][1]['#text'];
            song.innerHTML = json['track']['name'];
            album.innerHTML = json['track']['album']['#text'];
            artist.innerHTML = json['track']['artist']['#text'];
        });
}

function main() {
    randomize_logo();
    recently_played("ingenuineangel");
}