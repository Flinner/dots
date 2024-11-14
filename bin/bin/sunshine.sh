#!/bin/bash

export DISPLAY=:2

dpi=${1:-144}

# Check existing X server
ps -e | grep X >/dev/null
[[ ${?} -ne 0 ]] && {
  echo "DPI: ${dpi}"
  echo "Xft.dpi: ${dpi}" > $HOME/.Xresources
  echo "Starting X server"
  startx &>/dev/null &
  [[ ${?} -eq 0 ]] && {
    echo "X server started successfully"
  } || echo "X server failed to start"
} || echo "X server already running"

# Give some time for X server to startup
sleep 3

# Check if sunshine is already running
ps -e | grep -e .*sunshine$ >/dev/null
[[ ${?} -ne 0 ]] && {
  sudo ~/bin/sunshine-setup.sh
  #sudo ~/bin/sunshine-setup.sh
  echo "Starting Sunshine!"
  sunshine > /dev/null &
  [[ ${?} -eq 0 ]] && {
    echo "Sunshine started successfully"
  } || echo "Sunshine failed to start"
} || echo "Sunshine is already running"

# Add any other Programs that you want to startup automatically
# e.g.
~/.fehbg
# steam &> /dev/null &
# firefox &> /dev/null &
# kdeconnect-app &> /dev/null &
