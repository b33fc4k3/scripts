#!/bin/bash

# oder /usr/bin/env bash

# interactive menu
# or params and flags
# also either or ... probably just wanting to change keyboard layout !?
# good bash resource: http://www.thegeekstuff.com/2010/06/bash-conditional-expression/
# http://stackoverflow.com/questions/902946/about-bash-profile-bashrc-and-where-should-alias-be-written-in

# as seen here: http://stackoverflow.com/questions/16483119/example-of-how-to-use-getopt-in-bash

# https://github.com/baskerville/bspwm
# http://www.osnews.com/story/25359/Introduction_calm_window_manager/
# http://forums.debian.net/viewtopic.php?f=6&t=75097 themes
# http://urukrama.wordpress.com/openbox-guide/#xcompmgr

usage() {
    echo -e "
Usage: $0 
[-s <dual|external|notebook|multiseat>]
[-w <stumpwm|cwm|2bwm>
[-k <caps2ctrl|dvorak>]
" 1>&2; exit 1; }

#optspec=":hv-:"
while getopts ":s:w:k:" option; 
do
    case "${option}" 
        in
        s) 
            dsp=${OPTARG}
            [[ ${dsp} == "dual" || ${dsp} == "external" || ${dsp} == "notebook" || ${dsp} == "multiseat" ]] || usage
            ;;
        w) 
            wm=${OPTARG} 
            [[ ${wm} == "stumpwm" || ${wm} == "cwm" || ${wm} == "2bwm" ]] || usage
            ;;
        k) 
            kbd=${OPTARG} 
            [[ ${kbd} == "caps2ctrl" || ${kbd} == "dvorak" ]] || usage
            ;;
        *) 
            usage 
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${dsp}" ] || [ -z "${wm}" ] || [ -z "${kbd}" ]; then
    usage
fi

echo "dsp = ${dsp}"
echo "wm = ${wm}"
echo "kbd = ${kbd}"

dual="xrandr --output HDMI-0 --auto --right-of LVDS &"
external="xrandr --output HDMI-0 --auto --output LVDS --off &"

#setup() {
#
#}

if xrandr -q | grep "HDMI-0 connected" >/dev/null; then
    echo $(xrandr -q)
fi

# INTERESTING: http://pissedoffadmins.com/general/dual-monitor-xinitrc-configuration.html
# http://crunchbang.org/forums/viewtopic.php?id=20655
# xinitrc_blub
xsetroot -cursor_name plus -fg white -bg black &
# set up wallpaper after resolution change
feh --bg-scale ~/Bilder/wallpaper/wisconsin.jpg &
xset b off &
xrdb -load /home/marten/.Xresources &
# probably xbindkeys? setxkbmap
xmodmap ~/scripts/keys/xmodmap_swap-caps-ctrl &
${wm} &
xcompmgr -l 0.5 -t 0.5 -o 0.5 -r 2 -c &
exec urxvt

# startx
xinit .xinitrc_cwm -- :2 -nolisten tcp vt$XDG_VTNR

# xinit /usr/bin/enlightenment -- -nolisten tcp -br +bs -dpi 96 vt$XDG_VTNR

# as in https://wiki.archlinux.org/index.php/xinitrc
#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Here Xfce is kept as default
session=${1:-xfce}

case $session in
    enlightenment) exec enlightenment_start;;
    fluxbox) exec startfluxbox;;
    gnome) exec gnome-session;;
    lxde) exec startlxde;;
    kde) exec startkde;;
    openbox) exec openbox-session;;
    xfce) exec startxfce4;;
    # No known session, try to run it as command
    *) exec $1;;                
esac
