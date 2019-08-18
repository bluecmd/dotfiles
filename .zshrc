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

export EDITOR="vim"

alias ls='ls --color'
alias vi='vim'

bindkey -e
bindkey '^Z' push-line

export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin/

if uname -r | grep -q Microsoft; then
  umask 0022
  cd ~
  setxkbmap -rules base -model pc105 -layout us -variant altgr-intl
fi

if [[ $(tty) =~ /dev/ttyS[0-9] ]]; then
  resize || echo "Am serial console but resize failed, is xterm installed?"
fi
[[ -e /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found

if [[ -z $SSH_AGENT_PID ]] && [[ -z $SSH_AUTH_SOCK ]] && [[ ! -z $DISPLAY ]]; then
  touch $HOME/.ssh-agent
  source $HOME/.ssh-agent
  if ! ssh-add -L &> /dev/null; then
    ssh-agent | grep -vE '^echo' > $HOME/.ssh-agent
    source $HOME/.ssh-agent
    ssh-add
  fi
fi
