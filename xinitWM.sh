#!/bin/bash

# oder /usr/bin/env bash

# interactive menu
# or params and flags
# also either or ... probably just wanting to change keyboard layout !?


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
## set up wallpaper in right resolution
#feh --bg-scale ~/Bilder/wallpaper/fall-wisconsin.jpg &

# xinitrc_blub
xsetroot -cursor_name plus -fg white -bg black &
feh --bg-scale ~/Bilder/wallpaper/wisconsin.jpg &
xset b off &
xrdb -load /home/marten/.Xresources &
xmodmap ~/scripts/keys/xmodmap_swap-caps-ctrl &
${wm} &
xcompmgr -l 0.5 -t 0.5 -o 0.5 -r 2 -c &
exec urxvt

# startx
xinit .xinitrc_cwm -- :2 -nolisten tcp vt$XDG_VTNR
