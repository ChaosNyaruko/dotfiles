#!/bin/bash
function shit {
for i in {60934..60939};do 
    /opt/homebrew/opt/coreutils/libexec/gnubin/echo -ne "\r$(printf '\\u%x' $i)"
    # echo -ne "\r$(printf '%x' $i)"
    sleep 0.1
done
}

function spin {
  while :; do
    for X in '┤' '┘' '┴' '└' '├' '┌' '┬' '┐'; do
      echo -en "\b$X"
      sleep 0.1
    done
  done
}

spin & # starts the spinner in the background
spinner_pid=$!

# some long running command
sleep 5

kill -9 $spinner_pid && wait # kills the background process
echo -en "\033[2K\r" # Clears the line

