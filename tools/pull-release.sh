#!/bin/sh

#################
### Variables ###
#################

REPO=""

### Compatibility ###

if command -v apt-get; then
    echo
fi    

### Parse ###



if nc -zw1 "$REPO" 443; then
    echo "Connected"
else
    echo "Could not establish a network connection."
    exit 1
fi
