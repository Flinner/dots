alias fm='ranger'
alias fm.='. ranger'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias sl='ls -CF'

alias p='paru'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias update='sudo pacman -Sy && sudo powerpill -Su && paru -Su'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias ip='ip --color=auto'
alias ytfzfd='YTFZF_PLAYER="youtube-dl --embed-subs --write-sub --sub-lang en" ytfzf'
