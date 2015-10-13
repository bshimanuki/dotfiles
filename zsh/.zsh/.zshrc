# Don't recompile zcompdump
alias compinit='compinit -C'

# Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Aliases
alias ls='ls --color=auto -F'
alias la='ls -A'
alias lla='ll -A'
alias s='ls'
alias rm='nocorrect rm -I'
alias gt='git status'

# Directory
unsetopt auto_pushd
unsetopt cd_able_vars
typeset -U path
path=(~/bin $path)

# Completion
setopt autolist completealiases
unsetopt listambiguous
zmodload zsh/complist
bindkey -M menuselect "^M" .accept-line
bindkey "\e[Z" reverse-menu-complete
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# Globbing
setopt glob globdots extendedglob autocd
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
setopt HIST_IGNORE_DUPS

# Key Bindings
bindkey '\e[1;5D' backward-word # ctrl-left
bindkey '\e[1;5C' forward-word # ctrl-right

bindkey '^H' backward-delete-char
bindkey '^W' backward-kill-word
bindkey '^U' kill-line
bindkey -r '^X'
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -a '^P' history-substring-search-up
bindkey -a '^N' history-substring-search-down
