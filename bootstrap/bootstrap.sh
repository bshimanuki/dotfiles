#!/bin/sh -e

# no readlink -f option on Darwin
readlink_f(){ perl -MCwd -e 'print Cwd::abs_path shift' "$1"; }

# no grep -P option on Darwin
grep_P(){ perl -ne 'print if $1'; }

# fails if called as a symlink
BOOTSTRAP_DIR="$(dirname $(readlink_f $0))"
DOTFILES="$(dirname $BOOTSTRAP_DIR)"
GLOBAL_IGNORE_LIST=~/.stow-global-ignore
STOW_IGNORE_LIST="$DOTFILES"/stow/.stow-global-ignore
TARGET=~
PACKAGES="$(ls $DOTFILES)"

GNU_STOW=true
FORCE=false
SIZE=large
PROTOCOL=default
SHALLOW=false
LARGE_SUBMODULES_LIST=

for arg in "$@"; do
	shift
	case "$arg" in
		"--https") PROTOCOL=https ;;
		"--shallow") SHALLOW=true ;;
		"--small") SIZE=small ;;
		*) set -- "$@" "$arg" ;;
	esac
done

OPTIND=1
while getopts :ft: opt; do
	case $opt in
		f) FORCE=true ;;
		t) TARGET="$OPTARG" ;;
	esac
done
shift $((OPTIND-1))

if [ "$@" ]; then
	PACKAGES="$@"
fi

cd "$DOTFILES"

stow_files() {
	global_ignore_list="$GLOBAL_IGNORE_LIST"
	OPTIND=1
	while getopts :s opt; do
		case $opt in
			# Use the global ignore file we are about to stow rather than the pre-existing one
			s) global_ignore_list="$STOW_IGNORE_LIST" ;;
		esac
	done
	shift $((OPTIND-1))
	local_ignore_list=.stow-local-ignore
	for package in $PACKAGES; do
		if [ -e "$package" ]; then
			if [ -f "$package/$local_ignore_list" ]; then
				ignore_list="$package/$local_ignore_list"
			else
				ignore_list="$global_ignore_list"
			fi
			for file in "$package"/* "$package"/.[!.]* "$package"/..?*; do
				base="${file#$package/}"
				if [ -e "$file" ] && [ "$base" != "$local_ignore_list" ]; then
					ignore=false
					if [ -f "$ignore_list" ]; then
						while read ignore_line; do
							ignore_regex=${ignore_line%% *}
							if [ "$ignore_regex" ] && [ "${ignore_regex%${ignore_regex#?}}" != "#" ]; then
								ignore_regex="/$ignore_regex/"
								ignore_regex="$(echo "$ignore_regex" | sed 's:^/^:^:')"
								ignore_regex="$(echo "$ignore_regex" | sed 's:$/$:/$:')"
								if [ $(echo "/$base/" | grep_P "$ignore_regex") ]; then
									ignore=true
									break
								fi
							fi
						done < "$ignore_list"
					fi
					if ! $ignore; then
						echo "$file"
					fi
				fi
			done
		fi
	done
}

echo Gathering files...
STOW_FILES="$(stow_files -s)"

stow_targets() {
	for file in $STOW_FILES; do
		target_file="$TARGET/$(basename $file)"
		if [ -e  "$target_file" ]; then
			echo "$target_file"
		fi
	done
}

stow_target_exists() {
	verbose=false
	OPTIND=1
	while getopts :v opt; do
		case $opt in
			v) verbose=true ;;
		esac
	done
	shift $((OPTIND-1))
	target_files=$(stow_targets)
	if $verbose; then
		for file in $target_files; do
			echo $file already exists.
		done
	fi
	[ "$target_files" ]
}

stow_clone() {
	nop=false
	OPTIND=1
	while getopts :n opt; do
		case $opt in
			n) nop=true ;;
		esac
	done
	shift $((OPTIND-1))
	for file in $STOW_FILES; do
		if $nop; then
			echo ln -srt "$TARGET" "$file"
		else
			if ! [ -e "$TARGET/$(basename $file)" ]; then
				mkdir -p "$TARGET"
				ln -srt "$TARGET" "$file"
			fi
		fi
	done
}

git submodule init
if [ "$SIZE" = "small" ]; then
	for skip in $LARGE_SUBMODULES_LIST; do
		git submodule deinit $(git config --file .gitmodules submodule."$skip".path)
	done
fi
GIT_SUBMODULE_UPDATE_OPTIONS=""
if $SHALLOW; then
	GIT_SUBMODULE_UPDATE_OPTIONS="--depth 1"
fi
git submodule update $GIT_SUBMODULE_UPDATE_OPTIONS
git submodule foreach "git submodule update --init --recursive $GIT_SUBMODULE_UPDATE_OPTIONS"

if ! [ $(command -v stow) ]; then
	if ! $FORCE; then
		read -rp "GNU stow not installed. Symlink directly? [y/N] " yn
		[ "$yn" = "Y" ] || [ "$yn" = "y" ] || exit
	fi
	GNU_STOW=false
fi

if [ -f "$TARGET/vimrc" ]; then
	rm -f "$TARGET/vimrc"
fi
if [ -f "$TARGET/.vimrc" ]; then
	rm -f "$TARGET/.vimrc"
fi

if stow_target_exists -v; then
	if ! $FORCE; then
		read -rp "Target files exist. Remove them? [y/N] " yn
		[ "$yn" = "Y" ] || [ "$yn" = "y" ] || exit
	fi
	rm -rf $(stow_targets)
	if stow_target_exists; then
		if ! $FORCE; then
			if $GNU_STOW; then
				echo "Could not remove all files."
				read -rp "Continue without GNU stow and symlink directly? [Y/n] " yn
			else
				read -rp "Could not remove all files. Continue? [Y/n] " yn
			fi
			[ "$yn" = "N" ] || [ "$yn" = "n" ] || exit
		fi
		GNU_STOW=false
	fi
fi

if $GNU_STOW; then
	stow -t "$TARGET" stow
	stow -t "$TARGET" $PACKAGES
else
	stow_clone
fi
echo Dotfiles stowed.

if [ $(command -v vim) ]; then
	vim -c "PlugUpdate | qa"
fi
