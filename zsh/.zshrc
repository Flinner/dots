
 ########
 # INIT #
 ########
#===============================================================================================
declare -A ZINIT
# zinit, don't pollute my home!
ZINIT[BIN_DIR]="$HOME/.local/share/zinit/zinit.git"
ZINIT[HOME_DIR]="$HOME/.local/share/zinit"
ZINIT[MAN_DIR]="$HOME/.local/share/zinit/man"
ZINIT[ZCOMPDUMP_PATH]="$HOME/.cache/zinit/.zcompdump"

ZDOTDIR="$HOME/.cache/zsh/"

### Added by Zinit's installer
if [[ ! -f "${ZINIT[BIN_DIR]}/zinit.zsh" ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p $ZINIT[HOME_DIR] && command chmod g-rwX $ZINIT[HOME_DIR]
    command git clone https://github.com/zdharma-continuum/zinit $ZINIT[BIN_DIR] && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "${ZINIT[BIN_DIR]}/zinit.zsh"
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

if [[ "${TERM}" == "dumb" ]]; then
    exec sh
fi

# Get a random preset
fastfetch --config $(printf "%s\n" examples/{6,7,9,13,17,20,21,22} | shuf -n 1)

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


zplugin ice wait'2' lucid
zplugin load zdharma-continuum/fast-syntax-highlighting  

zplugin ice wait'0' lucid
zplugin load 'flinner/zsh-emacs'

zplugin ice wait lucid atload'_zsh_autosuggest_start'
zplugin light zsh-users/zsh-autosuggestions

zplugin ice wait'0' lucid
zinit load agkozak/zsh-z

zplugin ice wait'1' lucid
zinit load "MichaelAquilina/zsh-auto-notify"

zi ice from"gh-r" as"program" bpick"ys-*" pick"ys-*/ys"
zi light yaml/yamlscript


#zplugin ice wait'5' lucid
#zplugin load chisui/zsh-nix-shell


#zplugin ice wait'1' lucid
#zplugin load marlonrichert/zsh-autocomplete

# This one to be ran just once, in interactive session
#
autoload -Uz compinit 

compinit

compdef _gnu_generic ytfzf
compdef _gnu_generic emacs
# insensitve completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_IGNORE_SPACE # Remove commands from history when the first character is a space
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt CORRECT           # Correct spelling of commands
setopt CORRECT_ALL       # Correct spelling of arguments
setopt INTERACTIVE_COMMENTS # can have comments at the prompt
setopt HIST_VERIFY      # history expansions get verified in a new line
setopt SHARE_HISTORY     # SHARE_HISTORY between zsh sessins
    # disabled due to SHARE_HISTORY being used
    #setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time
SAVEHIST=1000
HISTSIZE=1000
HISTFILE="$HOME/.local/share/zsh/zsh_history"
AUTO_NOTIFY_IGNORE+=("fm", "ranger", "nvim", "vim")
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
# Quit with jk or ESC
bindkey jk vi-cmd-mode
bindkey '\e' vi-cmd-mode

# exit on partianl command with Ctrl-D
exit_zsh() { exit }
zle -N exit_zsh
bindkey '^v' edit-command-line
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

#  should kill upto to the slash 
autoload -U select-word-style
select-word-style bash



#zle -N zle-line-init
#zle -N zle-line-finish
#zle -N zle-keymap-select
#===============================================================================================

#########################
# ALIASES AND FUNCTIONS #
#########################


#===============================================================================================
copy () { xclip -selection c "$@" }
# DeepSeeked teehee :)
copy() {
    local input
    
    # Read from stdin if available
    if [ ! -t 0 ]; then
        input=$(cat)
    fi

    # Check if we're running under Wayland
    if [ "$XDG_SESSION_TYPE" = "wayland" ] || [ -n "$WAYLAND_DISPLAY" ]; then
        # Try using wl-copy (Wayland)
        if command -v wl-copy >/dev/null 2>&1; then
            if [ -n "$input" ]; then
                printf '%s' "$input" | wl-copy
            else
                wl-copy "$@"
            fi
        else
            echo "Error: wl-copy not found. Install wl-clipboard package." >&2
            return 1
        fi
    else
        # Fall back to xclip (X11)
        if command -v xclip >/dev/null 2>&1; then
            if [ -n "$input" ]; then
                printf '%s' "$input" | xclip -selection c
            else
                xclip -selection c "$@"
            fi
        else
            echo "Error: xclip not found. Please install it." >&2
            return 1
        fi
    fi
}


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
  _URL=$(curl -F "file=@$file" 0x0.st)
  echo "$_URL" | xclip -sel clip 
  echo "$_URL"
}

# curl with cache
curl_cache(){
  local cache_path=`echo $1 |  sed 's|/|_|g'`
  local cache_path="/tmp/$cache_path"

  [ -f "$cache_path" ] || curl -s "$1" -o "$cache_path"

  cat "$cache_path"
}
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../'


alias doas='sudo '
alias sudo='sudo '

alias fm='ranger'
alias fm.='. ranger'
alias books="fm ~/Documents/Books"

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias sl='ls -CF'
alias ls='ls --color=auto'

alias please='sudo $(fc -ln -1)'
alias plz='echo sudo $(fc -ln -1); sudo $(fc -ln -1)'

alias p='paru'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias ip='ip --color=auto'
alias ytfzfd='YTFZF_PLAYER="youtube-dl --embed-subs --write-sub --sub-lang en" ytfzf'

alias cargo-doc-server="python -m http.server -d target/doc/ -b 127.0.0.1"
alias startx="exec startx"

#===============================================================================================

#VARS

#===============================================================================================

source ~/.config/sh_vars/variables.sh

#xdg specs
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share

export CARGO_HOME="$XDG_DATA_HOME"/cargo

export GOPATH="$XDG_DATA_HOME"/go
export GOBIN="$XDG_DATA_HOME"/go
export DOOM_PATH="$HOME/.emacs.d/bin"
export YARN_PATH="$HOME/.yarn/bin"
export DENO_PATH="$HOME/.deno/bin"

export PATH="$DENO_PATH:$DOOM_PATH:$HOME/.local/bin:$HOME/bin:$CARGO_HOME/bin:$YARN_PATH:$GOPATH:$PATH"


# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

#  z-jumper to store symbolc links
export _Z_NO_RESOLVE_SYMLINKS=1
export _Z_DATA="$HOME/.local/share/z"

# jupyter garbage
# export JUPYTERLAB_DIR=$HOME/.local/share/jupyter/lab

# python path for jupyter garbage
# export PYTHONPATH="$HOME/.local/bin"

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
  export EDITOR='vim' # neovim unusuable rn due to python3 provider missing :(
fi

export TERMINAL="alacritty"
export TERM=xterm-256color

# man colors
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode - red
export LESS_TERMCAP_md=$(printf '\e[01;35m') # enter double-bright mode - bold, magenta
export LESS_TERMCAP_me=$(printf '\e[0m')     # turn off all appearance modes (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m')     # leave standout mode
export LESS_TERMCAP_so=$(printf '\e[01;33m') # enter standout mode - yellow
export LESS_TERMCAP_ue=$(printf '\e[0m')     # leave underline mode
export LESS_TERMCAP_us=$(printf '\e[04;36m') # enter underline mode - cyan

# fcitx (japanese)
GTK_IM_MODULE='fcitx'
QT_IM_MODULE='fcitx'
SDL_IM_MODULE='fcitx'
XMODIFIERS='@im=fcitx'

# for emacs-ng
WINIT_X11_SCALE_FACTOR=1

#===============================================================================================

# Load the pure theme, with zsh-async library that's bundled with it
PS1="> "
RPS1=" "
# TODO: Check if starship binary exist, and choose to eval one of the next two
# lines of code
#zplugin ice wait'!0' lucid pick"async.zsh" src"pure.zsh"; zplugin light sindresorhus/pure
eval "$(starship init zsh)"

#~/bin/dennis
#cutefetch 2> /dev/null
~/bin/is-reboot-needed

export QSYS_ROOTDIR="/home/lambda/Programs/intelQuartus/quartus/sopc_builder/bin"
export JUPYTERLAB_DIR=$HOME/.local/share/jupyter/lab

[ -f "/home/lambda/.ghcup/env" ] && . "/home/lambda/.ghcup/env" # ghcup-env

