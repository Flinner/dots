#!/bin/bash

PYTORCH_NO_CUDA_MEMORY_CACHING=1

[ -z "$2" ] && echo "usage: input.mp4 output.mp4" 
[ -z "$2" ] && exit

VIDEO="$1"
VIDEO_OUTPUT="$2"

mkdir -p ~/tmp/demusicify
echo "Created ~/tmp/demusicify"

echo "Using ~/tmp/demusicify as a temp directory"
TMP_RAW_AUDIO=$(mktemp -p ~/tmp/demusicify --suffix ".mp3")
TMP_VOCALS_DIR=$(mktemp -p ~/tmp/demusicify --directory)
TMP_VOCALS=$(mktemp -p ~/tmp/demusicify --suffix ".mp3")

function cleanup () {

    read -p "Do you want to cleanup? y/n" -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
        echo "Cleaning up!"
        rm "$TMP_RAW_AUDIO"
        rm "$TMP_VOCALS"
        rm -rf "$TMP_VOCALS_DIR"
    fi
}
trap cleanup EXIT

# Extract Audio from Video
ffmpeg -i "$VIDEO" -vn "$TMP_RAW_AUDIO" -y

# move to a tmp file, becuase demucs creates a lot of garbage
pushd "$TMP_VOCALS_DIR" || exit

demucs --two-stems=vocals --segment 15 "$TMP_RAW_AUDIO" 

cp ./separated/*/*/vocals.wav "$TMP_VOCALS"

# return back to working directory for no reason
popd || exit

# https://json2video.com/how-to/ffmpeg-course/ffmpeg-add-audio-to-video.html
ffmpeg \
    -i "$VIDEO" -i "$TMP_VOCALS"  \
    -c:v copy \
    -map 0 -map 1:a \
    -y "$VIDEO_OUTPUT"
