#!/usr/bin/env bash

# https://github.com/Fumon/rofi-spellcheck/blob/main/rofi-spellcheck.sh
#
#MIT License
#Copyright (c) 2022 Jade Bilkey

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
# Select "wayland" or "x11"
display_server="x11"


case $ROFI_RETV in
	0) 
		# Get Version
		version=$(echo -en | enchant-2 -a)
		echo -en "\0prompt\x1fspell\n\0message\x1f$version\n";;
	1) 
        if [ $display_server == "wayland" ]; then wl-copy $@
        elif [ $display_server == "x11" ]; then echo -en $@ | xclip -i -selection clipboard > /dev/null
        else exit 1; fi ;;
	2)
		
		spell=$(echo -en $@ | LANG=en_US enchant-2 -a);
		output=$(echo -en "$spell" | sed -E "/^@/d; /^$/d; s/&/&amp;/g; s/^(.+): /\\\\0message\x1f\1\n/; s/\\*/\\\\0message\x1fCorrect!\n$@\n/; s/, /\n/g; ");
		echo -en "$output";;
esac
exit 0

