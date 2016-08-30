export PATH=~/bin:$PATH
export EDITOR=vim
# export PAGER=vimpager
export HISTCONTROL=ignoreboth:erasedups

PROMPT_DIRTRIM=3

# os x color stuff
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    # git branch on prompt stuff
    if [[ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh ]]; then
        . /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u \[\033[01;34m\]\w\[\033[00m\]\[\033[31m\]$(__git_ps1)\[\033[00m\] \$ '
    fi

else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

if [[ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ]]; then
    . /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
fi

# show title when sshing
settitle() {
  printf "\033k$1\033\\"
}

ssh() {
  settitle "$*"
  command ssh "$@"
  settitle "bash"
}

alias vless=vimpager

# golang
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export PATH=$PATH:$HOME/bin

# ansible
export ANSIBLE_VAULT_PASSWORD_FILE=~/.vault-pass.txt

# npm completion
source /usr/local/Cellar/node5/$(node --version | sed -e 's/^v//')/etc/bash_completion.d/npm

# added by travis gem
[ -f /Users/jmartin/.travis/travis.sh ] && source /Users/jmartin/.travis/travis.sh


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# hub
if which hub > /dev/null; then
  alias git=hub
fi
# [ -f /usr/local/etc/bash_completion.d ] && source /usr/local/etc/bash_completion.d

source ~/.local/bin/bashmarks.sh


# Apps
# THE RIGHT ONE
export APP_ENV="development"


PATH="/Users/jmartin/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/jmartin/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/jmartin/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/jmartin/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/jmartin/perl5"; export PERL_MM_OPT;

man() {
	env \
		LESS_TERMCAP_md=$'\e[1;36m' \
		LESS_TERMCAP_me=$'\e[0m' \
		LESS_TERMCAP_se=$'\e[0m' \
		LESS_TERMCAP_so=$'\e[1;44;92m' \
		LESS_TERMCAP_ue=$'\e[0m' \
		LESS_TERMCAP_us=$'\e[1;32m' \
			man "$@"
}

random-str() {
    cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}

source .homebrew.sh
