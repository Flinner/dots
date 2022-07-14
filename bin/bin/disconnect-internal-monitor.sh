#!/bin/sh

intern=eDP-1-1
extern=HDMI-0

if xrandr | grep "$extern disconnected"; then
    xrandr --output "$extern" --off --output "$intern" --auto
    echo "External Monitor $extern is disconnected"
else
    xrandr --output "$intern" --off --output "$extern" --auto
    echo "    External Monitor $extern is connected"
    echo "So, Internal Monitor $intern was shutdown"
fi
