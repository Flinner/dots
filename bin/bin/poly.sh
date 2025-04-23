for m in $(polybar --list-monitors | cut -d":" -f1); do
MONITOR=$m ~/.config/polybar/launch.sh --hack &
done

