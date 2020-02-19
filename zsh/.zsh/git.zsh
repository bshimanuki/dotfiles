function insub() {(
	if [ $1 ] ; then
		for dir in */ ; do
			# skip directories starting with a dot
			if [[ "$dir" =~ ^[^.] ]] ; then
				(echo "$dir" && cd "$dir" && eval "$@" && echo)
			fi
		done
	fi
)}

alias gsts='insub git status -sb'

function git-track-sub() {(
	set -e
	local GIT_SUB=".git_sub"
	local function move-sub() {(
		if [ ! -L "$1" ] ; then
			[ $# -eq 2 ] || exit 1
			mv -nT "$1" "$2"
			ln -srT "$2" "$1"
		fi
	)}
	[ -d "$GIT_SUB" ] || (>&2 echo "error: $GIT_SUB directory does not exist" && exit 1)
	mkdir -p ".git/hooks"
	if [ ! -f ".git/hooks/post-checkout" ] ; then
		cat <<EOM > ".git/hooks/post-checkout"
#!/bin/bash
for dir in ${GIT_SUB}/*/ ; do
	dir="\${dir#${GIT_SUB}/}"
	dir="\${dir%/}"
	# skip directories starting with a dot
	if [[ "\$dir" =~ ^[^.] ]] ; then
		mkdir -p "\$dir/.git/refs"
		mkdir -p "\$dir/.git/objects"
		if [ -f "${GIT_SUB}/\$dir/config" ] && [ ! -e "\$dir/.git/config" ] ; then
			ln -srT "${GIT_SUB}/\$dir/config" "\$dir/.git/config"
			>&2 echo "info: linked config for \$dir"
		fi
		if [ -d "${GIT_SUB}/\$dir/refs/heads" ] && [ ! -e "\$dir/.git/refs/heads" ] ; then
			ln -srT "${GIT_SUB}/\$dir/refs/heads" "\$dir/.git/refs/heads"
			>&2 echo "info: linked refs/heads for \$dir"
		fi
		if [ -f "${GIT_SUB}/\$dir/HEAD" ] ; then
			cp -T "${GIT_SUB}/\$dir/HEAD" "\$dir/.git/HEAD"
			>&2 echo "info: updated HEAD for \$dir"
		else
			>&2 echo "warning: no HEAD found for \$dir"
		fi
		if [ -f "${GIT_SUB}/\$dir/stage-index" ] ; then
			rel_path="\$(realpath --relative-to="\$dir" "${GIT_SUB}/\$dir")/stage-index"
			(cd \$dir && cat "\$rel_path" | git update-index --index-info)
		else
			>&2 echo "warning: no stage index found for \$dir"
		fi
	fi
done
EOM
		>&2 echo "info: wrote post-checkout hook"
	else
		>&2 echo "warning: post-checkout hook already exists, skipping"
	fi
	chmod +x ".git/hooks/post-checkout"
	for dir in "$@" ; do
		if [ -d "$dir/.git" ] ; then
			# if [ -d "$dir/.git/refs/heads" ] && [ ! -L "$dir/.git/refs/heads" ] ; then
			if true ; then
				mkdir -p "$GIT_SUB/$dir/refs"
				move-sub "$dir/.git/refs/heads" "$GIT_SUB/$dir/refs/heads"
				move-sub "$dir/.git/config" "$GIT_SUB/$dir/config"
				# this requires git 2.22.0+
				mkdir -p "$dir/.git/hooks"
				cat <<-EOM >! "$dir/.git/hooks/post-index-change"
				#!/bin/bash
				git ls-files --stage > "$(realpath --relative-to="$dir" "$GIT_SUB/$dir/stage-index")"
				>&2 echo "info: updated index for $(basename $dir)"
				EOM
				chmod +x "$dir/.git/hooks/post-index-change"
				cat <<-EOM >! "$dir/.git/hooks/post-checkout"
				#!/bin/bash
				cp -T ".git/HEAD" "$(realpath --relative-to="$dir" "$GIT_SUB/$dir/HEAD")"
				>&2 echo "info: updated HEAD for $(basename $dir)"
				EOM
				chmod +x "$dir/.git/hooks/post-checkout"
				>&2 echo "info: linked $dir heads to $GIT_SUB/$dir"
				(cd "$dir" && ./.git/hooks/post-checkout && ./.git/hooks/post-index-change)
			else
				>&2 echo "warning: skipping $dir because it is already symlinked"
			fi
		else
			>&2 echo "error: $dir is not a git repo" && exit 1
		fi
	done
)}
