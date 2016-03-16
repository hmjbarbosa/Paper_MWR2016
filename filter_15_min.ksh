#!/bin/ksh

# check if IN file exists
if [[ ! -e $1 ]]; then
    echo "Input file don't exist!"
    exit
fi

# skip if OUT file already exists
if [[ ! -e ${1}_15min ]] ; then
    cat $1 | awk '{if ($6%15==0) print $0 }' >  ${1}_15min
else
    echo "Output file already exists! Existing cowardly..."
fi

#
