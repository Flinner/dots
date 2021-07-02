#!/usr/bin/env bash

#xdg specs
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share

export CARGO_HOME="$XDG_DATA_HOME"/cargo

export GOPATH="$XDG_DATA_HOME"/go
export GOBIN="$XDG_DATA_HOME"/go
export DOOM_PATH="$HOME/.emacs.d/bin"

export PATH="$DOOM_PATH:$HOME/.local/bin:$HOME/bin:$CARGO_HOME/bin:$GOPATH:$PATH"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

#  z-jumper to store symbolc links
export _Z_NO_RESOLVE_SYMLINKS=1
export _Z_DATA="$HOME/.local/share/z"

# jupyter garbage export JUPYTERLAB_DIR=$HOME/.local/share/jupyter/lab

# python path for jupyter garbage
export PYTHONPATH="$HOME/.local/bin"

# andriod studio, not that I use it
# also needed by shitlab! (matlab)
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS="-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"

#support for gpg
export GPG_TTY=$(tty)

# ZSH Home
export ZSH="$HOME/.config/.oh-my-zsh"

# fish
export fish_greeting="" #disable greeting

#Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='nvim'
fi

export TERMINAL="alacritty"

# man colors
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode - bold, magenta
export LESS_TERMCAP_me=$(printf '\e[0m')     # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m')     # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
export LESS_TERMCAP_ue=$(printf '\e[0m')     # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode - cyan
