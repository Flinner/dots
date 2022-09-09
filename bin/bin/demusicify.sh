#!/bin/bash

[ -z "$2" ] && echo "usage: input.mp4 output.mp4" 
[ -z "$2" ] && exit

VIDEO="$1"
VIDEO_OUTPUT="$2"

TMP_RAW_AUDIO=$(mktemp --suffix ".mp3")
TMP_VOCALS_DIR=$(mktemp --directory)
TMP_VOCALS=$(mktemp --suffix ".mp3")

# Extract Audio from Video
ffmpeg -i "$VIDEO" -vn "$TMP_RAW_AUDIO" -y

# move to a tmp file, becuase demucs creates a lot of garbage
pushd "$TMP_VOCALS_DIR" || exit

demucs --two-stems=vocals --segment 10 "$TMP_RAW_AUDIO" 

cp ./separated/*/*/vocals.wav "$TMP_VOCALS"

# return back to working directory for no reason
popd || exit

# https://json2video.com/how-to/ffmpeg-course/ffmpeg-add-audio-to-video.html
ffmpeg \
    -i "$VIDEO" -i "$TMP_VOCALS"  \
    -c:v copy \
    -map 0 -map 1:a \
    -y "$VIDEO_OUTPUT"


rm "$TMP_RAW_AUDIO"
rm "$TMP_VOCALS"
rm -rf "$TMP_VOCALS_DIR"
