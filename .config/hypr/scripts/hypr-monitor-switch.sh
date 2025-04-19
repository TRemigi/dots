#!/bin/bash

export XDG_RUNTIME_DIR="/run/user/$(id -u)"

DP_STATUS_FILE="/sys/class/drm/card1-DP-2/status"
EXTERNAL_MONITOR="DP-2"
INTERNAL_MONITOR="eDP-1"

sleep 1

if [[ -f "$DP_STATUS_FILE" && $(<"$DP_STATUS_FILE") == "connected" ]]; then
  hyprctl dispatch dpms off "$INTERNAL_MONITOR"
  hyprctl keyword monitor "$INTERNAL_MONITOR,disable"
  hyprctl keyword monitor "$EXTERNAL_MONITOR,1920x1080@144,0x0,1"
  sleep 0.3

  # Move all workspaces to external monitor
  hyprctl workspaces -j | jq -r '.[].id' | while read -r wid; do
    hyprctl dispatch moveworkspacetomonitor "$wid" "$EXTERNAL_MONITOR"
  done

  pkill waybar && waybar &

else
  hyprctl keyword monitor "$EXTERNAL_MONITOR,disable"
  hyprctl keyword monitor "$INTERNAL_MONITOR,1920x1200@60,0x0,1"
  sleep 0.3

  # Move all workspaces back to internal monitor
  hyprctl workspaces -j | jq -r '.[].id' | while read -r wid; do
    hyprctl dispatch moveworkspacetomonitor "$wid" "$INTERNAL_MONITOR"
  done
  (pkill waybar; nohup waybar > /dev/null 2>&1 &) &
fi
