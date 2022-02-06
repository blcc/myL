#!/bin/bash

## Shorten url or anything with files

## Usage:
##   Shorten link:
##      $0 <url link or long string>
##   Expand link:
##      $0 <L://linkstring>

## Directory store the links, 
workdir='/run/shm/myL'

## Algorithm to shorten string
shorten='/usr/bin/sha1sum'

## Shorten to number of character, may auto increase 
nw=5

## default prefix is 'L://'
prefix='L://'

arg="$*"

mkdir -p "$workdir"

## check input
if [[ "${arg}" == "${prefix}"* ]] ; then
#### if L:// => expend link
    dst=${arg#"$prefix"}
    if [ -f "${workdir}/${dst}" ]; then
        str=$(cat "${workdir}/${dst}")
        echo -n "$str"
        exit 0
    else
        exit 1
    fi
else
#### if not L:// => shorten string
    n=0
    while true ; do
        ustr=$(echo -n "${arg}" | $shorten | cut -c -${nw})
        if [ -f "${workdir}/${ustr}" ]; then
            n=$(expr $n + 1)
            if [ "${arg}" == "$(cat ${workdir}/${ustr})" ]; then
                echo -n "${prefix}${ustr}"
                exit
            else
                nw=$(expr $nw + 1) 
                continue
            fi
        else
            dst="${ustr}"
            break
        fi
    done
    echo -n "${arg}" > ${workdir}/${dst}
    echo -n "${prefix}${dst}"
    exit 0
fi

