#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ $TERM = "xterm-kitty" ]; then
	alias ssh="kitty +kitten ssh"
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias tree='tree -C'
alias ffuf='ffuf -c'
alias dd='dd status=progress'
# alias paru='paru --fm yazi'

alias dotager="/usr/bin/env git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

export PATH="$HOME/.local/bin:$PATH"
export HISTCONTROL=ignoredups:erasedups

export GOPATH=/opt/go
export PATH="$PATH:$GOPATH/bin"

export EDITOR=nvim
export VISUAL=nvim

# PS1='[\u@\h \W]\$ '
PS1="\[$(tput setaf 33)\]\u\[$(tput setaf 69)\]@\[$(tput setaf 105)\]\h \[$(tput setaf 141)\]\w \[$(tput sgr0)\]$ "

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/mcruces/.lmstudio/bin"
# End of LM Studio CLI section

# To use fnm as node version manager
eval "$(fnm env --use-on-cd --shell bash)"
