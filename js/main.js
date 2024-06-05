/* This program is free software. It comes without any warranty, to
     * the extent permitted by applicable law. You can redistribute it
     * and/or modify it under the terms of the Do What The Fuck You Want
     * To Public License, Version 2, as published by Sam Hocevar. See
     * http://www.wtfpl.net/ for more details. */


function sonicemote() {
    let sonic = document.querySelector('#sonic');

    sonic.src = "/asset/img/sprites/sonic/emote.gif";
    sonic.style['margin-right'] = "0";
}

function idleanim(){
    let sonic = document.querySelector('#sonic');
    let tails = document.querySelector('#tails');
    let amy = document.querySelector('#amy');
    let knuckles = document.querySelector('#knuckles');

    sonic.src = "/asset/img/sprites/sonic/idle.gif";
    tails.src = "/asset/img/sprites/tails/idle.gif";
    amy.src = "/asset/img/sprites/amy/idle.gif";
    knuckles.src = "/asset/img/sprites/knuckles/idle.gif";
}

function runanim(){
    let sonic = document.querySelector('#sonic');
    let tails = document.querySelector('#tails');
    let amy = document.querySelector('#amy');
    let knuckles = document.querySelector('#knuckles');

    sonic.src = "/asset/img/sprites/sonic/run.gif";
    sonic.style['margin-right'] = "18px";

    tails.src = "/asset/img/sprites/tails/run.gif";

    amy.src = "/asset/img/sprites/amy/run.gif";

    knuckles.src = "/asset/img/sprites/knuckles/run.gif";
}