#!/usr/bin sh

# only swap ctrl and capslock for non-HHKB keyboard
#
# AT Translated Set 2 keyboard
# xinput list
setxkbmap -device 13 -layout us -option "ctrl:swapcaps"
