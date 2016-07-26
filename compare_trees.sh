#! /bin/bash

usage () {
    echo "Usage: $0 [ -h | --help ] <tree_1> <tree_2>"          > "$1"
    echo                                                        > "$1"
    echo "This hashes of the trees specified in commandline."   > "$1"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage /dev/stdout
    exit 0
fi

if [ $# -ne 2 ]; then
    usage /dev/stderr
    exit 1
fi

DEBUG_FLAG=0

TREE1="$1"
TREE2="$2"

if [ ! -d "$TREE1" ] || [ ! -d "$TREE2" ]; then
    echo "ERROR: An arg is not a directory" > /dev/stderr
    exit 1
fi

OLDIFS="$IFS"
IFS=$'\n'

FILES_TREE1=($(find "$TREE1" -type f))
FILES_TREE2=($(find "$TREE2" -type f))

echo "Generating files hashes from \`$TREE1\`"

for (( i = 0; i < ${#FILES_TREE1[@]}; i++ )); do
    HASH_TREE1[$i]=$(sha1sum "${FILES_TREE1[$i]}" | awk '{ print $1 }')
done

echo "Generating files hashes from \`$TREE2\`"

for (( i=0; i < ${#FILES_TREE2[@]}; i++ )); do
    HASH_TREE2[$i]=$(sha1sum "${FILES_TREE2[$i]}" | awk '{ print $1 }')
done

for (( i=0; i < ${#FILES_TREE1[@]}; i++ )); do
    UNIQUE=1

    for (( v=0; v < ${#FILES_TREE2[@]}; v++ )); do

        if [ $DEBUG_FLAG -eq 1 ]; then
            echo "i = $i"
            echo "v = $v"
        fi

        if [ "${FILES_TREE1[$i]}" = "${FILES_TREE2[$v]}" ]; then
            UNIQUE=0
            continue
        fi

        if [ "${HASH_TREE1[$i]}" = "${HASH_TREE2[$v]}" ]; then
            echo "${FILES_TREE1[$i]} & ${FILES_TREE2[$v]} are the same"
            UNIQUE=0
            continue
        fi
    done

    if [ $UNIQUE -eq 1 ]; then
        echo "${FILES_TREE1[$i]} is unique"
    fi
done

IFS=$OLDIFS
