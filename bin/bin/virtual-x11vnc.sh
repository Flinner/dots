#!/usr/bin/env  bash

## gtf output
#Modeline "2560x1600_60.00"  348.16  2560 2752 3032 3504  1600 1601 1604 1656  -HSync +Vsync

mode=$(gtf 1600 2560 60 | grep Modeline | sed 's/\s*Modeline\s*//')
# mode = "2560x1600_60.00"  348.16  2560 2752 3032 3504  1600 1601 1604 1656  -HSync +Vsync


mode_string=$(echo "$mode" | sed -E 's/.*\"(.*)\".*/\1/g')
# mode_string = "2560x1600_60.00"

echo "===================="
echo "$mode"
echo "$mode_string"
echo "===================="

xrandr --newmode $(echo "$mode")
xrandr --addmode VIRTUAL1 "$mode_string"

#xrandr --output VIRTUAL1 --mode "$mode_string" --below eDP1
xrandr --output VIRTUAL1 --mode 1600x2560_60.00 --below eDP1


x11vnc -clip 1600x2560+0+1080 -usepw -repeat

