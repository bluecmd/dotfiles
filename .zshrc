HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=100000
setopt extendedglob nomatch notify share_history
setopt prompt_subst
unsetopt appendhistory autocd beep
autoload -Uz compinit
compinit

function isvpn {
  if [[ "${IS_VPN}" == "1" ]]; then
    echo -n '🔒'
  elif [[ ! -z "$(ip netns identify)" ]]; then
    echo -n '📦'
  elif [[ ! -z "${NIX_SHELL_PACKAGES}" ]]; then
    echo -n '🐚'
  else
    echo -n '  '
  fi
}

export EDITOR='vim'

alias ls='ls --color'
alias vi='vim'
alias work='~bluecmd/.dotfiles/work.sh'

bindkey -e
bindkey '^Z' push-line

up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}
zle -N up-line-or-local-history
down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}
zle -N down-line-or-local-history

bindkey '^[[A' up-line-or-local-history    # Cursor up
bindkey '^[[B' down-line-or-local-history  # Cursor down
bindkey '^P' up-line-or-local-history      # [CTRL] + p
bindkey '^N' down-line-or-local-history    # [CTRL] + n
bindkey '^[[1;5A' up-line-or-history       # [CTRL] + Cursor up
bindkey '^[[1;5B' down-line-or-history     # [CTRL] + Cursor down

export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin/:$HOME/.local/bin
if [[ -f ${HOME}/.zshrc.local ]]; then
  source ${HOME}/.zshrc.local
fi

# 31: red
# 32: green
# 33: yellow
# 34: blue
# 35: magenta
# 36: cyan
c=${COLOR:-36}
PROMPT=$'%{\e['${c}$'m%}[%{\e[38;5;243m%}%m%{\e['${c}$'m%}]%{\e[0;0m%}\$ '
RPROMPT=$'[%{\e['${c}$'m%}%c%{\e[0m%}] [$(TZ=Europe/Stockholm date +%H:%M:%S)] $(isvpn)'


if [[ -z "${NO_VPN}" ]]; then
  function refreshvpn() {
    IS_VPN=$(curl -s https://am.i.mullvad.net/connected 2> /dev/null | \
      grep 'You are connected' -c)
  }

  TRAPALRM() {
    refreshvpn
    zle reset-prompt }
  TMOUT=20

  refreshvpn
fi

mod-accept-line() {
    zle reset-prompt
    zle accept-line
}

zle -N mod-accept-line
bindkey "^M" mod-accept-line

if uname -r | grep -q Microsoft; then
  umask 0022
  cd ~
  # apt install x11-xkb-utils
  setxkbmap -rules base -model pc105 -layout us -variant altgr-intl
  # Needed for SSH X11 forwarding
  export DISPLAY="localhost:0"
  if [[ -z "${GNOME_TERMINAL_SCREEN}" ]]; then
    if env NO_AT_BRIDGE=1 gnome-terminal; then
      echo "Gnome-terminal successfully launched instead"
      # Sleep is sometimes broken in WLS (https://github.com/microsoft/WSL/issues/4898)
      python3 -c 'import time; time.sleep(0.5)'
      exit 0
    fi
  fi
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
  fi
fi

if [[ -n $SSH_AGENT_PID ]]; then
  if ! ssh-add -L &> /dev/null; then
    ssh-add -c
  fi
fi

if [[ -f /etc/profile.d/nix.sh ]]; then
  source /etc/profile.d/nix.sh
fi
