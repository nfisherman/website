#!/bin/sh

#################
### Variables ###
#################

REPO="https://github.com/nfisherman/nfisherman.com.git"

### Compatibility ###

if ! command -v tar >/dev/null 2>&1; then
    echo "tar must be installed"
    exit 1
elif ! command -v nc >/dev/null 2>&1; then
    echo "nc must be installed"
    exit 1
elif ! command -v wget >/dev/null 2>&1; then
    echo "wget must be installed"
    exit 1
fi

### Parse ###

REPO="$(echo "$REPO" | sed 's/\.git//' -)"

if nc -zw1 "$REPO" 443; then
    echo "Connected"
else
    echo "Could not establish a network connection."
    exit 1
fi
