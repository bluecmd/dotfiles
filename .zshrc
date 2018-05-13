HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=100000
setopt extendedglob nomatch notify share_history
setopt prompt_subst
unsetopt appendhistory autocd beep

autoload -Uz compinit
compinit

PROMPT=$'%{\e[01;32m%}[%{\e[01;30m%}%m%{\e[01;32m%}]%{\e[01;30m%}%{\e[0;0m%}\$ '
RPROMPT=$'[%{\e[01;32m%}%c%{\e[0m%}] [$(TZ=Europe/Stockholm date +%H:%M:%S)]'

TMOUT=1
TRAPALRM() {
  zle reset-prompt }

EDITOR="vim"

alias ls='ls --color'
alias vi='vim'
alias l='i3lock -c000000'

bindkey '^Z' push-line

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin/
