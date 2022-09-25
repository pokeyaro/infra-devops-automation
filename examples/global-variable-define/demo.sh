#!/usr/bin/env bash
#written on 2022.06.26
#author: PokeyBoa.mystic
#Description: Global variable definition demo example.

set -o nounset
export LANG=en_US.UTF-8
stty erase '^h'
trap 'echo -e "  \nExit...\n"' EXIT
datesuf=`date +%Y%m%d`
symbols=`perl -e "print '#' x 50;"`
curdir=`dirname $(readlink -f $0)`
basedir=`dirname $curdir`"/"


# unit test
unit_test() {
    echo -e "\n${symbols}"
    echo "current script path: ${curdir}"
    echo "parent path: ${basedir}"
}
unit_test

# EOF
