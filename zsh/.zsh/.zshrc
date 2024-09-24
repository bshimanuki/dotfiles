export fpath=("${ZDOTDIR:-$HOME}/.zfunc" "${fpath[@]}")

# Don't recompile zcompdump
alias compinit='compinit -C'

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
if [[ `uname` == 'Darwin' ]]
then
	alias ls='ls -G -F -v'
	alias rm='nocorrect rm'
else
	alias ls='ls --color=auto -F -v'
	alias rm='nocorrect rm -I'
fi
alias la='ls -A'
alias lla='ll -A'
alias s='ls'
setopt rm_star_silent
alias mmv='noglob zmv -W'
rg(){command rg -p "$@" | less -FRX}
# tmux
alias tpwd='[ -n "$TMUX" ] && tmux set-option default-command "cd \"$PWD\" && $SHELL -l"'
alias tw='tmux new -A -s work'
alias tp='tmux new -A -s puzzle'
alias tcl='clear && tmux clear-history'
## vim
v(){if [ $# -eq 0 ]; then vi -c "if exists(':Fzfvimfiles') | :Fzfvimfiles"; else vi "$@"; fi}
alias vv='vi -X'
alias nv='nvim'
## git
alias gt='git status'
alias gtt='git status -uno'
unalias gcm
gcm(){git commit -m "$*"}
glgl(){git log --topo-order --graph --pretty=format:"${_git_log_oneline_format}" HEAD $(git show-ref $(git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads) | cut -d' ' -f2)}
alias gff='git pull --ff-only'
alias gmf='git merge --ff-only'
alias gpcf="${aliases[gpc]} --force-with-lease"
alias gpn="${aliases[gp]} --no-verify"
alias gpcn="${aliases[gpc]} --no-verify"
alias gpfn="${aliases[gpf]} --no-verify"
alias gpcfn="${aliases[gpcf]} --no-verify"
git_master_or_main(){ {echo master; git branch -l main master --format '%(refname:short)'} | tail -n 1 }
gfom(){
	local master=$(git_master_or_main)
	git fetch origin "${master:?}:${master:?}"
}
alias gfomm='git fetch origin main:main'
gumd(){
	local red_if_error(){
		exec 3>&1
		stderr=$("$@" 2>&1 1>&3)
		ret=$?
		exec 3>&-
		if [ -n "$stderr" ]; then
			if [ $ret -ne 0 ]; then
				# output in red to stderr
				printf >&2 '\e[31m%s\e[m\n' "$stderr"
			else
				# output normal to stderr
				printf >&2 '%s\n' "$stderr"
			fi
		fi
		return $ret
	}
	local master=$(git_master_or_main)
	red_if_error git fetch origin "${master:?}:${master:?}"
	local current=$(git rev-parse --abbrev-ref HEAD)
	red_if_error git switch ${master:?}
	red_if_error echo git diff --quiet ${master:?} ${current:?}
	if red_if_error git diff --quiet ${master:?} ${current:?}; then
		red_if_error git branch -d "${current:?}"
	else
		local printerror() {
			>&2 echo "error: the branch '${current}' does not match '${master}'"
			return 1
		}
		red_if_error printerror
	fi
}
gcom(){ git switch "$(git_master_or_main)" }
alias grp='git rev-parse'
## docker
alias dk='docker'
alias dc='docker compose'
alias dkr='docker run --rm -i -t'
alias dkrr='docker run --rm -i -t -v "$(pwd):/host" -w /host -u "$(id -u):$(id -g)"'
alias docker-ip='docker inspect \
	-f "{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
	docker-ss(){ sudo nsenter -t "$(docker inspect -f '{{.State.Pid}}' "${1:?}")" -n ss "${@:2}" }
if [ ! -x "$(command -v docker)" ] && [ -x "$(command -v podman)" ] ; then
	alias docker='podman'
	if [ -x "$(command -v podman-compose)" ] ; then
		alias docker-compose='podman-compose'
	fi
fi
## kubectl
alias k='kubectl'
alias kc='kubectl config get-contexts'
alias kcc='kubectl config use-context'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgpp='kubectl get pods -o wide --field-selector status.phase!=Succeeded'
alias kgn='kubectl get nodes'
alias kgnn='kubectl get nodes -o wide'
alias kwd='kubectl diff --context'
alias kp='kubectl apply --context'
## ssh
dessh(){ command ssh -G "$1" | awk '$1 == "hostname" { print $2 }' } # dealias
alias issh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
## gdb
gcore(){
	local core="${1:-core}"
	local exe
	exe="$(file "$core" | sed "s/^.*core file.*execfn: '\([^']*\)'.*/\1/;t p;Q1;:p q")"
	local ret=$?
	(exit $ret) || {>&2 echo "Error: Could not find file '$core'"; return $ret}
	gdb "$exe" "$core" "${@:2}"
}

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
