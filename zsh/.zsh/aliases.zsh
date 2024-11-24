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
alias sl='ls'
setopt rm_star_silent
alias mmv='noglob zmv -W'
rg(){command rg -p "$@" | less -FRX}
# tmux
alias tpwd='[ -n "$TMUX" ] && tmux set-option default-command "cd \"$PWD\" && $SHELL -l"'
alias tw='tmux new -A -s work'
alias tp='tmux new -A -s puzzle'
alias tcl='clear && tmux clear-history'
alias te='export SSH_AUTH_SOCK="$(tmux show-env SSH_AUTH_SOCK | cut -sd= -f2)" && export DISPLAY="$(tmux show-env DISPLAY | cut -sd= -f2)"'
## vim
v(){if [ $# -eq 0 ]; then vi -c "if exists(':Fzfvimfiles') | :Fzfvimfiles"; else vi "$@"; fi}
alias vv='vi -X'
get_available_port() {
	min_port="${1:?args: min_port max_port}"
	max_port="${2:-65535}"

	declare -A ports
	for hex_port in $(grep -Eo ':[0-9A-F]{4}\b' /proc/net/tcp | grep -Eo '[0-9A-F]{4}'); do
		ports["$((0x${hex_port}))"]=1
	done

	for port in $(seq "$min_port" "$max_port"); do
		if [[ -z "${ports["$port"]:-}" ]]; then
			echo "$port"
			return
		fi
	done

	>&2 echo "Error: no available port in range $min_port-$max_port"
	return 1
}
nv(){
	(
	if [ -e /proc ]; then
		export NEOCODEIUM_CHAT_WEB_SERVER_PORT=$(get_available_port "${CODEIUM_PORT_MIN:-51234}" "${CODEIUM_PORT_MAX:-65535}")
		export NEOCODEIUM_CHAT_CLIENT_PORT=$(get_available_port "$(($NEOCODEIUM_CHAT_WEB_SERVER_PORT + 1))" "${CODEIUM_PORT_MAX:-65535}")
	fi
	nvim "$@"
	)
}
## git
alias gt='git status'
alias gtt='git status -uno'
if alias gcm &> /dev/null; then
	unalias gcm
fi
gcm(){git commit -m "$*"}
glgl(){git log --topo-order --graph --pretty=format:"${_git_log_oneline_format}" HEAD $(git show-ref $(git for-each-ref --format='%(refname:short) %(upstream:short)' refs/heads) | cut -d' ' -f2)}
alias gcod='git checkout --detach'
alias gfp='git fetch --prune'
alias gff='git pull --ff-only'
alias gmf='git merge --ff-only'
alias gpcf="${aliases[gpc]} --force-with-lease"
alias gpn="${aliases[gp]} --no-verify"
alias gpcn="${aliases[gpc]} --no-verify"
alias gpfn="${aliases[gpf]} --no-verify"
alias gpcfn="${aliases[gpcf]} --no-verify"
git_master_or_main(){ {echo master; git branch -l main master --format '%(refname:short)'} | tail -n 1 }
gmm() { git merge "$(git_master_or_main)" "$@" }
grm() { git rebase "$(git_master_or_main)" "$@" }
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
gcom(){ git switch "$(git_master_or_main)" "$@" }
gcomd(){ git switch "$(git_master_or_main)" --detach "$@" }
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
alias kdp='kubectl describe pod'
alias kdd='kubectl describe deployment'
alias kdn='kubectl describe node'
alias kds='kubectl describe service'
alias ke='kubectl exec -it'
alias kg='kubectl get'
alias kgd='kubectl get deployment'
alias kgp='kubectl get pods'
alias kgpp='kubectl get pods -o wide --field-selector status.phase!=Succeeded'
alias kgppn='kubectl get pods -o wide --field-selector status.phase!=Succeeded --sort-by=.spec.nodeName'
alias kgpip="kubectl get pods -o jsonpath='{.status.podIP}'"
alias kgn='kubectl get nodes'
alias kgnn='kubectl get nodes -o wide'
alias kgs='kubectl get service'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias klp='kubectl logs -p'
alias kr='kubectl rollout restart deployment'
alias kwd='kubectl diff --context'
alias kp='kubectl apply --context'
# nvidia
alias smi='nvidia-smi'
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