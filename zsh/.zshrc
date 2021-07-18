 ########
 # INIT #
 ########
#===============================================================================================
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
#zinit light-mode for \
    #zinit-zsh/z-a-rust \
    #zinit-zsh/z-a-as-monitor \
    #zinit-zsh/z-a-patch-dl \
    #zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk
#===============================================================================================

###########
# PLUGINS #
###########

#===============================================================================================
#zplugin load zdharma/history-search-multi-word

zplugin ice wait'1' lucid
zplugin snippet OMZ::plugins/fzf/fzf.plugin.zsh 
zplugin ice wait'1' lucid
zplugin snippet OMZ::plugins/fancy-ctrl-z/fancy-ctrl-z.plugin.zsh 
zplugin snippet OMZ::plugins/vi-mode/vi-mode.plugin.zsh 


zplugin ice wait'1' lucid
zplugin load zdharma/fast-syntax-highlighting  

zplugin ice wait'1' lucid
zplugin load 'flinner/zsh-emacs'

zplugin ice wait lucid atload'_zsh_autosuggest_start'
zplugin light zsh-users/zsh-autosuggestions

zplugin ice wait'0' lucid
zinit load agkozak/zsh-z


#zplugin ice wait'1' lucid
#zplugin load marlonrichert/zsh-autocomplete

# This one to be ran just once, in interactive session
#
autoload -Uz compinit 

compinit

compdef _gnu_generic ytfzf
# insensitve completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time
#===============================================================================================

############
# KEYBINDS #
############

#===============================================================================================

bindkey -e
function zle-keymap-select zle-line-init zle-line-finish
{
  case $KEYMAP in
      vicmd)      print -n '\033[1 q';; #line cursor
      viins|main) print -n '\033[6 q';; # block cursor
  esac
}
bindkey jk vi-cmd-mode

# exit on partianl command with Ctrl-D
exit_zsh() { exit }
zle -N exit_zsh
bindkey '^D' exit_zsh

#===============================================================================================

#########
# OTHER #
#########

#disable url globbing (for mpv) # https://superuser.com/questions/649635/zsh-says-no-matches-found-when-trying-to-download-video-with-youtube-dl
#TODO: delete this
#autoload -Uz bracketed-paste-magic
#zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic


SAVEHIST=1000
HISTSIZE=1000
HISTFILE=~/.zsh_history
setopt CORRECT
setopt CORRECT_ALL
#zle -N zle-line-init
#zle -N zle-line-finish
#zle -N zle-keymap-select
#===============================================================================================

#########################
# ALIASES AND FUNCTIONS #
#########################


#===============================================================================================
copy () { xclip -selection c "$@" }

chmodx-last () { chmod +x "$_"  ; }

# get weather, example: weather New York
weather () { curl wttr.in/"$*"; }

# get public ip address
ip.me () { curl eth0.me ; curl ipv6.icanhazip.com } # or ip.me

# 0x0, upload files and use as pastebin example: 0x0 file.sh
0x0 () {
  [ ! -z "$1" ] && file=$1 || file=$(find . -maxdepth 2 -type f | fzf)
  [ -z "$file" ] && return
  echo "file=@$file"
  curl -F "file=@$file" 0x0.st | xclip -sel clip
}

alias doas='sudo '
alias sudo='sudo '

alias fm='ranger'
alias fm.='. ranger'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias sl='ls -CF'
alias ls='ls --color=auto'

alias p='paru'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias ip='ip --color=auto'
alias ytfzfd='YTFZF_PLAYER="youtube-dl --embed-subs --write-sub --sub-lang en" ytfzf'

#===============================================================================================

#VARS

#===============================================================================================

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

#===============================================================================================

# Load the pure theme, with zsh-async library that's bundled with it
PS1="> "
RPS1=" "
#zplugin ice wait'!0' lucid pick"async.zsh" src"pure.zsh"; zplugin light sindresorhus/pure
eval "$(starship init zsh)"
