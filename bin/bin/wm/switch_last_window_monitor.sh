#!/bin/bash

# TODO: Fix this!!
# chatgpted
# Get the current active window ID
current_window=$(hyprctl activewindow)

# Get the monitor of the current active window
current_monitor=$(hyprctl activewindow | grep -oP 'monitor: \K\d+')

# Get the last active window's ID on a different monitor
last_window=$(hyprctl monitors | grep -v $current_monitor | awk '{print $1}')

echo $last_window

# Switch focus to that window (if found)
if [ -n "$last_window" ]; then
  hyprctl focuswindow $last_window
fi

