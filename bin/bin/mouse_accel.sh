#!/bin/bash

STATE_FILE="/tmp/mouse_accel_state"
DEFAULT_SPEED=40
STEP=20
MAX_SPEED=200
TIME_THRESHOLD_MS=100

now_ms() {
    date +%s%3N  # current time in milliseconds
}

# Read previous state
if [[ -f "$STATE_FILE" ]]; then
    read -r last_time last_speed < "$STATE_FILE"
else
    last_time=0
    last_speed=$DEFAULT_SPEED
fi

current_time=$(now_ms)
delta=$((current_time - last_time))

if (( delta <= TIME_THRESHOLD_MS )); then
    # Accelerate
    new_speed=$((last_speed + STEP))
    [[ $new_speed -gt $MAX_SPEED ]] && new_speed=$MAX_SPEED
else
    # Reset
    new_speed=$DEFAULT_SPEED
fi

# Save new state
echo "$current_time $new_speed" > "$STATE_FILE"

# Output the new speed
echo "$new_speed"

