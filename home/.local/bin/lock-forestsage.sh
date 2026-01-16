#!/usr/bin/env bash
set -euo pipefail

# forestsage palette
bg="#1b1f1a"
fg="#e6e2d6"
sage="#8fa88a"
berry="#a4636a"
sky="#7aa6a1"
gold="#c4a86a"
clay="#b07d5a"
pine="#3f5e4a"

# note: actually runs i3lock-color
exec i3lock \
  --blur 10 \
  --clock \
  --indicator \
  --inside-color="${bg}cc" \
  --ring-color="${pine}ff" \
  --line-color="${bg}00" \
  --separator-color="${bg}00" \
  --keyhl-color="${sage}ff" \
  --bshl-color="${clay}ff" \
  --insidever-color="${sky}cc" \
  --ringver-color="${sky}ff" \
  --insidewrong-color="${berry}cc" \
  --ringwrong-color="${berry}ff" \
  --verif-color="${fg}ff" \
  --wrong-color="${fg}ff" \
  --time-color="${gold}ff" \
  --date-color="${sage}ff" \
  --radius=120 \
  --ring-width=10 \
  --time-str="%I:%M %p" \
  --date-str="%a %b %d"
