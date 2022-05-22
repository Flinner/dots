#!/bin/sh

echo "compresing $1"
echo "to  compress-$1"

convert "$1"\
  -sampling-factor 4:2:0 \
  -strip \
  -quality 85 \
  -interlace Plane \
  -gaussian-blur 0.05 \
  -colorspace RGB \
  "compressed-$1"

