#!/bin/sh
#picom --experimental-backend -b
picom -b
xss-lock -- slock &
xrandr --output DisplayPort-0 --off --output DisplayPort-1 --primary --mode 1920x1080 --pos 3440x137 --rotate normal --output DisplayPort-2 --off --output HDMI-A-0 --mode 3440x1440 --pos 0x0 --rotate normal
