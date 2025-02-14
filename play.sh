#!/bin/bash
for i in {60934..60939};
do 
    /opt/homebrew/opt/coreutils/libexec/gnubin/echo -ne "\r$(printf '\\u%x' $i)"
    # echo -ne "\r$(printf '%x' $i)"
    sleep 0.1
done
