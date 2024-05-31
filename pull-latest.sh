#!/bin/sh

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

#################
### Variables ###
#################

# The repo to pull a release from
REPO="https://github.com/nfisherman/nfisherman.com"

# Output directory
OUTDIR="nfisherman.com"

# How many times the script will try to download before giving up
TRIES=5

### Compatibility ###

iscmd() { 
    command -v "$1" > /dev/null
}

if ! iscmd "curl"; then
    echo "curl: command not found"
    whoops=1
fi

if ! iscmd "tar"; then
    if ! iscmd 1; then
        echo "either \"tar\" or \"unzip\" must be installed, but neither are"
        whoops=1
    else
        unzip=1
    fi
fi
if ! iscmd "wget"; then 
    echo "wget: command not found"
    whoops=1
fi

if [ "$whoops" = 1 ]; then
    echo "[FATAL] Resolve dependency issues then try again."
    exit 1
fi


### Parse ###

# remove ".git" & trailing backslash
REPO="$(echo "$REPO" | sed 's/\.git//' - | sed 's/\/*$//' -)"
# convert to API url
api="$(echo "$REPO" | sed 's/github\.com/api\.github\.com\/repos/' -)"

# add trailing backslash
case "$OUTDIR" in
    "") OUTDIR="./" ;;
    */) ;;
    *) OUTDIR="$OUTDIR/" ;;
esac

if ! [ -n "$TRIES" -a $TRIES -eq $TRIES ]; then 
    TRIES=0
fi


### Connection Test ###

if ! wget -q --tries="$TRIES" --spider "$REPO"; then
    echo "[FATAL] Could not establish network connection."
    exit 1
fi

mkdir -p "$OUTDIR" || { echo "[FATAL] You do not have access to $OUTDIR."; exit 1; }
if [ "$unzip" = 1 ]; then
    RANDY="/tmp/src-download-$(tr -cd 0-9 </dev/urandom | head -c 3).zip"

    curl -s "$api/releases/latest" \
    | grep "$api/zipball/*" \
    | cut -d : -f 2,3 \
    | tr -d ,\" \
    | wget --tries="$TRIES" -qi - -O "$RANDY"

    unzip -q "$RANDY" -d "$OUTDIR/"
    rm "$RANDY"
else
    curl -s "$api/releases/latest" \
    | grep "$api/tarball/*" \
    | cut -d : -f 2,3 \
    | tr -d ,\" \
    | wget --tries="$TRIES" -qi - -O- \
    | tar -xzf - -C "$OUTDIR"
fi