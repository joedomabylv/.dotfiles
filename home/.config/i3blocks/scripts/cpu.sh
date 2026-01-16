#!/usr/bin/env bash
# cpu usage in percent

# read from /proc/stat twice to calculate usage
read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
prev_idle=$((idle + iowait))
prev_total=$((user + nice + system + idle + iowait + irq + softirq + steal))

sleep 0.2

read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
idle2=$((idle + iowait))
total2=$((user + nice + system + idle + iowait + irq + softirq + steal))

diff_idle=$((idle2 - prev_idle))
diff_total=$((total2 - prev_total))

if [[ "$diff_total" -eq 0 ]]; then
  echo "0%"
  exit 0
fi

usage=$(( (100 * (diff_total - diff_idle)) / diff_total ))
echo "${usage}%"
