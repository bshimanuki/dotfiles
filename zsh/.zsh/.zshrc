export fpath=("${ZDOTDIR:-$HOME}/.zfunc" "${fpath[@]}")

# Don't recompile zcompdump
alias compinit='compinit -C'

# Local options
if [[ -r "${ZDOTDIR:-$HOME}/local.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/local.zsh"
fi

# Prezto
if [[ -r "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# fzf
if (( $+commands[fzf] )); then
	export FZF_DEFAULT_OPTS='--bind ctrl-n:page-down,ctrl-p:page-up'
	if [[ -r "${HOME}/.vim/plugged/fzf/shell/completion.zsh" ]]; then
		source "${HOME}/.vim/plugged/fzf/shell/completion.zsh"
	fi
	if [[ -r "${HOME}/.vim/plugged/fzf/shell/key-bindings.zsh" ]]; then
		source "${HOME}/.vim/plugged/fzf/shell/key-bindings.zsh"
	fi
fi

# Aliases
if [[ -r "${ZDOTDIR:-$HOME}/aliases.zsh" ]]; then
	source "${ZDOTDIR:-$HOME}/aliases.zsh"
fi

# Directory
unsetopt auto_pushd
unsetopt cd_able_vars
typeset -U path
path=(~/bin "${path[@]}")

# Completion
setopt autolist
unsetopt listambiguous
zmodload zsh/complist
bindkey -M menuselect "^M" .accept-line
bindkey "\e[Z" reverse-menu-complete # shift-tab
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
function() {
	local exe_ext='exe|so|dll'
	local compiled_ext='d|o|pdf|py[cdo]'
	local img_ext='gif|jpg|png'
	local data_ext='npy|npz|onnx|pb|pkl|pt'
	local tex_ext='aux|bbl|bcf|blg|brf|fdb_latexmk|fls|idx|ilg|lof|lol|lot|pre|synctex.gz|synctex.gz\\(busy\\)|toc|x.gnuplot' # exclude: log
	local file_ext="${exe_ext}|${compiled_ext}|${img_ext}|${data_ext}|${tex_ext}"
	local dir='__pycache__'
	zstyle ':completion:*:*:vi(m|):*' file-patterns "^(*.(${file_ext})|${dir}):source-files" '%p:all-files'
}

# Globbing
setopt glob globdots extendedglob autocd
unsetopt caseglob

# Prompt
autoload promptinit
promptinit
prompt suse
setopt prompt_sp
case $TERM in
	xterm*)
		precmd(){printf "\e]0;%s/ >\a" "${(%):-%~}"}
		preexec(){printf "\e]0;%s/ > %s\a" "${(%):-%~}" "$1"}
		;;
	screen*)
		precmd(){printf "\033]2;%s/ >\033\\" "${(%):-%~}"}
		preexec(){printf "\033]2;%s/ > %s\033\\" "${(%):-%~}" "$1"}
		;;
esac

# Python
if (( ${+commands[pyenv]} )); then
	eval "$(pyenv init -)"
fi

# Help
autoload -U run-help
autoload run-help-git
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
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
setopt interactive_comments

# Key Bindings
KEYTIMEOUT=1

bindkey '\e[1;5D' backward-word # ctrl-left
bindkey '\e[1;5C' forward-word # ctrl-right

bindkey '^H' backward-delete-char
bindkey '^W' backward-kill-word
bindkey '^U' kill-line
bindkey -as '\e' '\a'
bindkey -r '^X'
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -a '^P' history-substring-search-up
bindkey -a '^N' history-substring-search-down

## use v for edit-command-line and move ^V to visual-mode in vicmd mode
bindkey -a '^V' visual-mode
bindkey -a 'v' edit-command-line

# Broken function in old zsh
autoload -Uz __git_files

setupwacom() {
	local wacom_device='Wacom Intuos Pro S Pad pad'
	if [ -x "$(command -v xsetwacom)" ] && (xsetwacom list devices | grep "$wacom_device" > /dev/null); then
		xsetwacom --set "$wacom_device" Button 1 'key +alt tab -alt'
		xsetwacom --set "$wacom_device" Button 2 'key +ctrl z -ctrl'
		xsetwacom --set "$wacom_device" Button 3 'key +ctrl y -ctrl'
		xsetwacom --set "$wacom_device" Button 8 'key shift'
		xsetwacom --set "$wacom_device" Button 9 'key ctrl'
		xsetwacom --set "$wacom_device" Button 10 'key alt'
	fi
}
setupwacom

# Git management
source "${ZDOTDIR:-$HOME}/git.zsh"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# gcloud
[ -f '/opt/google-cloud-sdk/path.zsh.inc' ] && . '/opt/google-cloud-sdk/path.zsh.inc'
[ -f '/opt/google-cloud-sdk/completion.zsh.inc' ] && . '/opt/google-cloud-sdk/completion.zsh.inc'

# homebrew
[ -f '/opt/homebrew/bin/brew' ] && eval "$(/opt/homebrew/bin/brew shellenv)"
