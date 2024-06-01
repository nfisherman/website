#!/usr/bin/env bash

# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://www.wtfpl.net/ for more details.

print_help() {
    echo "Usage: ./$(basename $0) {/path/to/output} [-p [\"args\"]] 
    [-t /path/to/pull-latest.sh]

Required Arguments:
    {/path/to/output}       location of test folder

Options:
    -h, --help              prints this message
    -p=, --pull-latest=     runs ./pull-latest.sh after test folder creation
        [\"args\"]              optional, string collection of pull-latest.sh
                                arguments
    -t, --tools             where your pull-latest.sh is located"
}

DIR="$1"
case "$DIR" in
    */) 
        DIR="${DIR}test" ;;
esac
if ! mkdir -p "$DIR"; then
    print_help
    exit 1
fi
shift

VALID_ARGS=$(getopt -n $(basename "$0") -o hp::t: \
    --long help,pull-latest::,tools: -- "$@")
if [[ $? -ne 0 ]]; then
    print_help
    exit 1
fi

PULL=0
TOOLS="$(pwd)"
eval set -- "$VALID_ARGS"
while [ : ]; do
    case "$1" in
        -h | --help) 
            print_help
            exit
            ;;
        -p | --pull-latest)
        echo $2
        echo $1
        echo $0
            if [ "$2" != "" ]; then
            echo "balls"

                ARGS="$2"
                shift
            fi
            PULL=1
            shift
            ;;
        -t | --tools)
            if ! [[ -d "$3" ]]; then
                echo "$2: $3 does not exist"
                print_help
                exit 1
            fi
            if ! [[ -f "$3/pull-latest.sh" ]]; then
                echo "$2: $3/pull-latest.sh could not be found"
                print_help
                exit 1
            fi
            if ! [[ "${2:0:1}" != "/" ]] && ! [[ "${2:0:1}" != "~" ]]; then
                TOOLS="$(pwd)/${2}"
            else
                TOOLS="${2}"
            fi
            shift 2
            ;;
        :)
            echo -e "Option requires an argument."
            print_help
            exit 1
            ;;
        ?)
            echo -e "Invalid command option."
            print_help
            exit 1
            ;;
        --) shift;
            break
            ;;
    esac
done

cd "$DIR" || { echo "[FATAL] $DIR disappeared."; exit 1; }
cp "${TOOLS}/pull-latest.sh" "./" \
|| { echo "[FATAL] Insufficient permissions to copy pull-latest.sh."; exit 1; }

if [[ $PULL == 1 ]]; then 
    
    sh -c "./pull-latest.sh $ARGS"
fi

echo "[Info] Test folder created at $(pwd)."