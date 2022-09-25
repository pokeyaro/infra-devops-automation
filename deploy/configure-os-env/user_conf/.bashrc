# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
if [[ "$(id -u)" -eq 0 ]]; then
        PS1='[\u@\h \w] # '
else
        PS1='[\u@\h \w] \$ '
fi
umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval "$(dircolors)"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

# User specific aliases and functions
alias rm='rm -rf'
alias cp='cp -rfa'
alias md='mkdir -p'
alias ..='cd ..'
alias vi='vim'

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Set the terminal to never time out
export TMOUT=0
