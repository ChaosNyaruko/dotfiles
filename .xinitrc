#!/bin/sh prefix="/usr" exec_prefix="${prefix}" xrdb="xrdb" xinitdir="/etc/X11/xinit" xclock="xclock" xterm="xterm" twm="twm" xmodmap="xmodmap" userresources="$HOME/.Xresources" usermodmap="$HOME/.Xmodmap" sysresources="$xinitdir/.Xresources" sysmodmap="$xinitdir/.Xmodmap" # merge in defaults and keymaps
if [ -f "$sysresources" ]; then
    if [ -x /usr/bin/cpp ] ; then
        "$xrdb" -merge "$sysresources"
    else
        "$xrdb" -nocpp -merge "$sysresources"
    fi
fi

if [ -f "$sysmodmap" ]; then
    "$xmodmap" "$sysmodmap"
fi

if [ -f "$userresources" ]; then
    if [ -x /usr/bin/cpp ] ; then
        "$xrdb" -merge "$userresources"
    else
        "$xrdb" -nocpp -merge "$userresources"
    fi
fi

if [ -f "$usermodmap" ]; then
    "$xmodmap" "$usermodmap"
fi

# start some nice programs

if [ -d "$xinitdir"/xinitrc.d ] ; then
	for f in "$xinitdir/xinitrc.d"/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

export GDK_SCALE=2 # Firefox Chromium Mpv
export QT_SCALE_FACTOR=1.5 # vlc
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# SDL_IM_MODULE=fcitx
# GLFW_IM_MODULE=ibus

exec /usr/bin/i3
