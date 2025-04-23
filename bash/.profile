# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

if [ -f ~/.config/sh_vars/variables.sh ]; then  .  $HOME/.config/sh_vars/variables.sh ;fi
if [ -f ~/.config/sh_vars/aliases.sh ]; then  .  $HOME/.config/sh_vars/aliases.sh ;fi

# if running zsh
    if [ -f "$HOME/.zsh" ]; then
	. "$HOME/.zsh"
    fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Japanese Input
#export GTK_IM_MODULE=ibus
#export XMODIFIERS=@im=ibus
#export QT_IM_MODULE=ibus

#if [ -x /usr/bin/spice-vdagent ] ; then
  #/usr/bin/spice-vdagent
  ##!/bin/sh

  #sleep 2

  #xrandr --output "$(xrandr | awk '/ connected/{print $1; exit; }')" --auto

  #xev -root -event randr | \
    #grep --line-buffered 'subtype XRROutputChangeNotifyEvent' | \
    #while read foo ; do \
      #xrandr --output "$(xrandr | awk '/ connected/{print $1; exit; }')" --auto
    #done



#fi



export QSYS_ROOTDIR="/home/lambda/Programs/intelQuartus/quartus/sopc_builder/bin"

[ -f "/home/lambda/.ghcup/env" ] && . "/home/lambda/.ghcup/env" # ghcup-env