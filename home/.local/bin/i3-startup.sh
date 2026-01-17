#!/usr/bin/env bash
set -u

log="/tmp/i3-startup.log"

# log everything (stdout + stderr) with timestamps
exec > >(awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> "$log") 2>&1

echo "starting i3-startup.sh"
echo "hostname: $(hostname -s)"
echo "display: ${DISPLAY-<unset>}"
echo "xauthority: ${XAUTHORITY-<unset>}"
echo "path: $PATH"

# sometimes outputs aren't ready immediately at login
sleep 1

host="$(hostname -s)"

# apply monitor layout per host
case "$host" in
  "JDV")
    echo "applying desktop xrandr layout"
    xrandr \
      --output DisplayPort-0 --off \
      --output DisplayPort-1 --off \
      --output DisplayPort-2 --primary --mode 1920x1080 --rate 240.30 --pos 3440x0 --rotate normal \
      --output HDMI-A-0 --mode 3440x1440 --rate 100 --pos 0x0 --rotate normal \
      || echo "warning: xrandr layout command failed (continuing)"
    wallpaper="/usr/share/backgrounds/dense-forest.jpg"
    ;;
  "jdv")
    echo "applying laptop xrandr layout"
    xrandr --output eDP --primary --auto \
      || echo "warning: xrandr laptop command failed (continuing)"
    wallpaper="/usr/share/backgrounds/rushing-currents.jpg"
    ;;
  *)
    echo "unknown host, using default wallpaper only"
    wallpaper="/usr/share/backgrounds/rushing-currents.jpg"
    ;;
esac

echo "xrandr summary:"
xrandr --query | grep -E " connected| primary" || true

echo "setting wallpaper: $wallpaper"
feh --no-fehbg --bg-fill "$wallpaper" || echo "warning: feh failed (continuing)"

echo "done i3-startup.sh"

