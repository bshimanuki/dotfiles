# Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Aliases
# List directory
alias ls='ls --color=auto -F'
alias la='ls -A'
alias lla='ll -A'
alias s='ls'

# Remove
alias rm='nocorrect rm -I'

# Directory
unsetopt auto_pushd
unsetopt pushd_ignore_dups

# Completion
autoload -Uz compinit
compinit
setopt autolist completealiases
unsetopt listambiguous
zmodload zsh/complist
bindkey -M menuselect '^M' .accept-line
bindkey '^[[Z' reverse-menu-complete
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# Globbing
setopt glob extendedglob autocd
unsetopt caseglob

# Prompt
autoload promptinit
promptinit
prompt suse
case $TERM in
	xterm*)
		precmd(){print -Pn "\e]0;%~/ >\a"}
		preexec(){print -Pn "\e]0;%~/ > $1\a"}
		;;
esac
case "$TERM" in
	screen*)
		precmd(){print -Pn "\033]2;%~/ >\033\\"}
		preexec(){print -Pn "\033]2;%~/ > $1\033\\"}
		;;
esac

# Lines configured by user
typeset -U path
path=(~/bin $path)
setopt HIST_IGNORE_DUPS
bindkey -v

# Delete word
bindkey -M emacs '^[[3;5~' kill-word

# Bind ctrl-left / ctrl-right
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word

# Help
autoload -U run-help
autoload run-help-git
autoload run-help-svn
autoload run-help-svk
alias help=run-help

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
