#!/bin/sh
set +x

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

# currently pretty bad, I'd just download the github release yourself

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


### Args ###

__NAME__=$(basename "$0")
print_help() {
    echo "Usage: ./$__NAME__ [-g url] [-o /path/to/output] [-t #] 

    Options:
        -h, --help          prints this message
        -g, --git           repository to pull from
        -o, --output        directory to install to
        -t, --tries         number of times to retry after failure
    "
}

VALID_ARGS=$(getopt -n $(basename "$0") -o hg:o:t: \
    --long help,git:,output:,tries: -- "$@")
if [ $? -ne 0 ]; then
    print_help
    exit 1
fi

REPO="https://github.com/nfisherman/nfisherman.com"
OUTDIR=""
TRIES="5"
eval set -- "$VALID_ARGS"
while [ : ]; do
    case "$1" in
        -h | --help) 
            print_help
            exit
            ;;
        -g | --git) 
            REPO="$2"
            shift 2
            ;;
        -o | --output)
            if ! [ -f "$2" ]; then
                printf "%s: '%s' does not exist" "-o" "$2"
                exit 1
            fi
            OUTDIR="$2"
            shift 2
            ;;
        -t | --tries)
            if ! [ "$2" -eq "$2" ] 2>/dev/null; then 
                printf "%s: '%s' is not an integer" "-t" "$2"
                exit 1;
            fi
            TRIES="$2"
            shift 2
            ;;
        :)
            echo "Option requires an argument."
            print_help
            exit 1
            ;;
        ?)
            echo "Invalid command option."
            print_help
            exit 1
            ;;
        --) shift;
            break
            ;;
    esac
done


### Parse ###

# remove ".git" & trailing backslash
REPO="$(echo "$REPO" | sed 's/\.git//' - | sed 's/\/*$//' -)"

# add trailing backslash
case "$OUTDIR" in
    "" | */) ;;
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

if [ "$OUTDIR" != "" ]; then
    mkdir -p "$OUTDIR" \
    || { echo "[FATAL] You do not have access to $OUTDIR."; exit 1; }
fi


### Attempt download & verify ###

homeplate=$(pwd)
cd /tmp || { echo "No access to /tmp folder???"; exit 1; }
i=0
while [ $i -lt $TRIES ] \
&& ! sha256sum --check "nfisherman-website.tar.gz.DIGESTS" 2>/dev/null; do
    rm nfisherman-website.tar.gz* 2>/dev/null

    wget "$REPO/releases/latest/download/nfisherman-website.tar.gz"
    wget "$REPO/releases/latest/download/nfisherman-website.tar.gz.DIGESTS"

    i=$((i + 1))
done

if [ $i = $TRIES ]; then
    echo "[FATAL] Failed to install too many times. Aborting..."
    rm nfisherman-website.tar.gz*
    exit 1
fi


### Select installation folder ###

install="$OUTDIR/" \
|| { echo "[FATAL] Script directory has disappeared???"; exit 1; }
if [ "${OUTDIR}" = "" ]; then
    install="${homeplate:?}/" 
fi


### Clear out installation folder ###

find "$install"* ! -name "$(basename $0)" -type f -exec rm {} + 2>/dev/null
find "$install"* -type d -exec rm -r {} +


### Install ###

tar --overwrite -xzvf "nfisherman-website.tar.gz" -C "$install/" .
rm nfisherman-website.tar.gz*