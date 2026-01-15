#!/bin/sh
#picom --experimental-backend -b
picom -b &
xrandr --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --mode 1920x1080 --rate 240.30 --pos 3440x0 --rotate normal --output HDMI-A-0 --mode 3440x1440 --rate 100 --pos 0x0 --rotate normal
