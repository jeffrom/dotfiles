# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[31m\]$(__git_ps1)\[\033[00m\] \$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


# env vars
export ROOT=$HOME/code
export PYTHONPATH=$ROOT/python:$ROOT/python/stubs:$HOME/repos
export PYTHONSTARTUP=~/.pythonrc
export NODE_PATH=~/tmp/doctorjs/narcissus/lib/:~/tmp/doctorjs/lib/jsctags:~/tmp/doctorjs/lib

go=`which go`
if [[ "$go" ]]; then
    export GOPATH=$HOME/go
    _goroot=`$go env GOROOT`

    export PATH=$PATH:$_goroot/bin:$GOPATH/bin
fi

export PATH=$PATH:$HOME/bin

export EDITOR=vi
export SVN_MERGE=~/bin/mergewrap.py
#export TERM=xterm-color
export TERM=xterm-256color
export GREP_OPTIONS="--exclude-dir=\.svn --exclude=TAGS --exclude=tags --exclude=*.swp"

#alias less=$HOME/bin/someless
alias diff='diff -u'
#alias git='git --no-pager'

# mail
#MAIL=/var/spool/mail/`whoami` && export MAIL
#
## gnupg
#ps cax | grep gpg-agent > /dev/null
#if [ ! $? -eq 0 ]; then
#    gpg-agent --daemon --enable-ssh-support --write-env-file "${HOME}/.gpg-agent-info"
#fi
#
#_export_gpg_info() {
#    if [ -f "${HOME}/.gpg-agent-info" ]; then
#        . "${HOME}/.gpg-agent-info"
#        export GPG_AGENT_INFO
#        export SSH_AUTH_SOCK
#        export SSH_AGENT_PID
#    fi
#
#    if [ -n "$DBUS_SESSION_BUS_ADDRESS" ]; then
#        echo export DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" >> $HOME/.gpg-agent-info
#    fi
#}
#_export_gpg_info
#
#PROMPT_COMMAND=_export_gpg_info
#
##wrap mutt w/ gpg for password safety
#alias mutt=$HOME/bin/wrapmutt
#
## hack for screen to work w/ gpgp
#_ssh_auth_save() {
#    ln -sf "$SSH_AUTH_SOCK" "$HOME/.screen/ssh-auth-sock.$HOSTNAME"
#}
#alias screen='_ssh_auth_save ; export HOSTNAME=$(hostname) ; screen'

# added by Anaconda 1.8.0 installer
#export PATH="/home/jeff/anaconda/bin:$PATH"
