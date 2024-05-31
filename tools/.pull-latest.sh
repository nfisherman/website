#!/bin/sh

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

# currently pretty bad, I'd just download the github release yourself

#################
### Variables ###
#################

# The repo to pull a release from
REPO="https://github.com/nfisherman/nfisherman.com"

# Output directory
# Leave blank to perform an in-place update
OUTDIR=""

# How many times the script will try to download before giving up
TRIES=5


### Dependencies ###

iscmd() { 
    command -v "$1" > /dev/null
}

if ! iscmd "curl"; then
    echo "curl: command not found"
    whoops=1
fi
if ! iscmd "tar"; then
    echo "tar: command not found"
    whoops=1
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

homeplate=$(pwd)
cd /tmp || { echo "No access to /tmp folder???"; exit 1; }
i=1
while [ $i -le $TRIES ] \
&& ! sha256sum --check "nfisherman-website-*.DIGESTS" 2>/dev/null; do
    rm "nfisherman-website-*" 2>/dev/null

    curl -s "$api/releases/latest" \
    | grep "nfisherman-website-*" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget --tries="$TRIES" -qi - -O "/tmp/"

    i=$(i + 1)
done

if [ $i = $TRIES ]; then
    echo "[FATAL] Failed to install too many times. Aborting..."
    rm nfisherman-website-*
    exit 1
fi

cd "$homeplate" || { echo "Script directory has disappeared???"; exit 1; }
if [ $OUTDIR = "" ]; then
    cd "$homeplate" || { echo "[FATAL] Script directory has disappeared???"; exit 1; }
else
    cd "$OUTDIR" || { echo "[FATAL] No access to output dir."; exit 1; }
fi

find . ! -name "$(basename $0)" -type f -exec rm {} +
find . -type d -exec rm -r {} +

tar --overwrite -xzvf nfisherman-website-*.tar.gz