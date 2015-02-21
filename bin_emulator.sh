#! /bin/bash

function print_usage {
    echo -e "Usage:\t$0 [OPTION] [FILE]...\n\nOPTION\n------\n"
    echo -e "-s | --status :\n\tSee the current bin content"
    echo -e "-e | --empty :\n\tEmpty the Trash"
    echo -e "-h | --help :\n\tPrint this usage\n"

    echo -e "Without options, FILE will be throw to The bin (~/.Trash)"
}
function bin_status {
    $TRASH_NUMBER=`ls -l | wc -l`

    ls -l ~/.Trash
    echo -e "\nThe bin contains $TRASH_NUMBER trash files."
}

function bin_throw {
    if [ $# -eq 0 ]; then
        echo Error: No files target... Do nothing.
    fi

    for i in `seq 2 $#`; do
        mv -t ~/.Trash
        echo Move `eval echo \${$i}` to Trash.
    done

    echo -e "\nSummary: Move $(($# - 1)) files to Trash."
}

function bin_emulator {
    if [ $1 = '--status' ] || [ $1 = '-s']; then
        bin_status
    elif [ $1 = '-e' ] || [ $1 = '--empty' ]; then
        rm -rf ~/.Trash/*
    elif [ $1 = '-h' ] || [ $1 = '--help' ]; then
        print_usage
    else
        bin_throw $@
    fi
}
