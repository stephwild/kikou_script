#! /bin/bash

# Arg_1: stream for usage() output
usage () {
    echo "Usage: $0 <dir_to_dump>" > "$1"
}

if [ $# -ne 1 ]; then
    usage /dev/stderr
    exit 1
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage /dev/stdout
    exit 0
fi

DUMP_TOP=~/.Dumps

if [ ! -d $DUMP_TOP ]; then
    mkdir $DUMP_TOP

    if [ $? -ne 0 ]; then
        echo "ERROR: Cannot mkdir \`${DUMP_TOP}\`" > /dev/stderr
        exit 2;
    fi
fi

DUMP_NEW=${DUMP_TOP}/$(date +%d-%m-%Y_%H:%M:%S)

mkdir "$DUMP_NEW"

if [ $? -ne 0 ]; then
    echo "ERROR: Cannot mkdir \`${DUMP_NEW}\`" > /dev/stderr
    exit 2;
fi

find "$1" \(  -iname \*.pdf  -o    \
              -iname \*.doc  -o    \
              -iname \*.docx -o    \
              -iname \*.pptx -o    \
              -iname \*.odf  -o    \
              -iname \*.txt  -o    \
              -iname \*.md   \) -a \
              -exec cp '{}' "$DUMP_NEW" \;
# -exec cp '{}' "$DUMP_NEW/{}" \;
