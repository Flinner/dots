#!/bin/bash
#https://stackoverflow.com/questions/7261855/recommendation-for-compressing-jpg-files-with-imagemagick

#quality in 85
#progressive (comprobed compression)
#a very tiny gausssian blur to optimize the size (0.05 or 0.5 of radius) depends on the quality and size of the picture, this notably optimizes the size of the jpeg.
#Strip any comment or EXIF metadata

magick "$1" -strip -interlace Plane -sampling-factor 4:2:0 -quality 75% "$2"
