#!/usr/bin/env bash

if ! command -v tar > /dev/null; then
    echo "tar: command not found"
    exit 1
fi
if ! command -v node > /dev/null; then
    echo "node: command not found"
    exit 1
fi


__NAME__=$(basename "$0")
function print_help() {
    echo "Usage: $__NAME__ [-o /path/to/output] [-s /path/to/source]
    
    Required Arguments:
        -v, --version       reported version number

    Options:
        -h, --help          prints this message
        -o, --output        directory to output build
        -s, --source        directory to build from
    "
}

VALID_ARGS=$(getopt -o hv:o:s: --long help,version:,output:,source: -- "$@")
if [[ $? -ne 0 ]]; then
    print_help
    exit 1
fi

OUTPUT="release"
SOURCE="_site"
eval set -- "$VALID_ARGS"
while [ : ]; do
    case "$1" in
        -h | --help) 
            print_help
            exit
            ;;
        -v | --version) 
            VERSION="$2"
            shift 2
            ;;
        -o | --output)
            OUTPUT="$2"
            shift 2
            ;;
        -s | --source)
            SOURCE="$2"
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

if [[ "$VERSION" == "" ]]; then
    echo -e "version (-v, --version) is a required argument"
    print_help
    exit 1
fi

VERSION=$(echo "$VERSION" | sed 's/v*//' -)
OUTPUT=$(echo "$OUTPUT" | sed 's/\/*$//' -)
SOURCE=$(echo "$SOURCE" | sed 's/\/*$//' -)
fullpath="$OUTPUT/v$VERSION/nfisherman_website_v$VERSION.tar.gz"

mkdir -p "$OUTPUT/v$VERSION" || { echo "[FATAL] You do not have access to $OUTPUT."; exit 1; }

rm -rf _site
npx @11ty/eleventy

tar -czvf "$fullpath" -C "$SOURCE" .
sha256sum "$fullpath" \
| sed "s/${OUTPUT}\/v${VERSION}\///" > "$fullpath.DIGESTS"
