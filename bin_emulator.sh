#! /bin/bash

function print_usage
{
    echo -e "Usage:\t$0 [OPTION] [FILE]...\n"

    echo -e "Without options, FILE will be throw to The bin (~/.Trash)\n"

    echo -e "OPTION\n------\n"
    echo -e "-l | --list :\n\tSee the current bin content"
    echo -e "--clean :\n\tEmpty the Trash"
    echo -e "-h | --help :\n\tPrint this usage\n"

    echo -e "Call bin without options and files is equivalent to use 'bin --list'"
}

function bin_status
{
    TRASH_DESCRIPTION=$(tree ~/.Trash | tail -n 1)

    echo "Bin status"
    echo -e "----------\n"

    ls -l ~/.Trash
    echo -e "\nBin content: $TRASH_DESCRIPTION."
}

function bin_throw
{
    nbr_cpy=0

    for i in `seq 1 $#`; do
        ARG_i=$(eval echo \${$i})

        mv --backup=numbered -t ~/.Trash $ARG_i && \
            echo Move $ARG_i to Trash. && \
            nbr_cpy=$(($nbr_cpy + 1))
    done

    echo -e "\nSummary: Move $nbr_cpy files to Trash."
}

function bin_emulator
{
    if [ $# -eq 0 ] || [ $1 = '-l' ] || [ $1 = '--list' ]; then
        bin_status
    elif [ $1 = '-h' ] || [ $1 = '--help' ]; then
        print_usage
    elif [ $1 = '--clean' ]; then
        echo Clean the bin
        rm -rf ~/.Trash/*
    else
        bin_throw $@
    fi
}

bin_emulator $@
