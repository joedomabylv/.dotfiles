#!/usr/bin/env bash
# volume block for i3blocks
# left click opens pavucontrol
# scroll adjusts volume

if [[ "${BLOCK_BUTTON:-}" == "1" ]]; then
  pavucontrol & disown
fi

if [[ "${BLOCK_BUTTON:-}" == "4" ]]; then
  pactl set-sink-volume @DEFAULT_SINK@ +5%
  pkill -SIGUSR1 i3blocks 2>/dev/null || true
fi

if [[ "${BLOCK_BUTTON:-}" == "5" ]]; then
  pactl set-sink-volume @DEFAULT_SINK@ -5%
  pkill -SIGUSR1 i3blocks 2>/dev/null || true
fi

mute="$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')"
vol="$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n 1)"

if [[ "$mute" == "yes" ]]; then
  echo "muted"
else
  echo "$vol"
fi
