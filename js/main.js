/* This program is free software. It comes without any warranty, to
     * the extent permitted by applicable law. You can redistribute it
     * and/or modify it under the terms of the Do What The Fuck You Want
     * To Public License, Version 2, as published by Sam Hocevar. See
     * http://www.wtfpl.net/ for more details. */

const lastfm_username = "ingenuineangel";

function randomize_logo() {
    const logo = document.getElementById('logo_img');
    
    let dir = "/asset/img/logo/";
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

function hide_decorations(){
    let textDecorations = document.getElementsByClassName('text-decoration');

    if(!textDecorations[0].hasAttribute("src")){
        for(const deco of textDecorations){
            deco.style.display = "none";
        }
    }
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
    hide_decorations();
    recently_played(lastfm_username);

    setInterval(recently_played(lastfm_username), 360000);
}