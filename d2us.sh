#!/bin/bash

holler=true
[ "$1" == "-q" ] && holler=false && shift

sed -i 's@\r@@' $1

if [ $? == 0 ]; then
    ($holler) && echo "d2us.sh: unofficially converting $1 to Unix format ..."
    echo "a" > /dev/null
else
    ($holler) && echo "Could not convert!" >&2
    echo "b" > /dev/null
fi
