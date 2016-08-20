#!/bin/sh -e

# fails if called as a symlink
BOOTSTRAP_DIR="$(dirname "$0")"
DOTFILES="$(dirname "$BOOTSTRAP_DIR")"
GLOBAL_IGNORE_LIST=~/.stow-global-ignore
STOW_IGNORE_LIST="$DOTFILES"/stow/.stow-global-ignore
TARGET=~
PACKAGES="$DOTFILES"/*
GNU_STOW=true

OPTIND=1
while getopts :t: opt; do
	case $opt in
		t) TARGET="$OPTARG" ;;
	esac
done
shift $((OPTIND-1))

if [ "$@" ]; then
	PACKAGES="$@"
fi

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
	for package in "$@"; do
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
								if [ $(echo "/$base/" | grep -P "$ignore_regex") ]; then
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

stow_targets() {
	target="$TARGET"
	packages=$PACKAGES
	OPTIND=1
	while getopts :t: opt; do
		case $opt in
			t) target="$OPTARG" ;;
		esac
	done
	shift $((OPTIND-1))
	if [ "$@" ]; then
		packages="$@"
	fi
	for package in $packages; do
		for file in $(stow_files -i "$package"); do
			target_file="$target${file#$package}"
			if [ -e  "$target_file" ]; then
				echo "$target_file"
			fi
		done
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
	# no shift, forward all args
	target_files=$(stow_targets "$@")
	if $verbose; then
		for file in $target_files; do
			echo $file already exists.
		done
	fi
	[ "$target_files" ]
}

stow_clone() {
	nop=false
	target=..
	OPTIND=1
	while getopts :nt: opt; do
		case $opt in
			n) nop=true ;;
			t) target="$OPTARG" ;;
		esac
	done
	shift $((OPTIND-1))
	for file in $(stow_files "$@"); do
		if $nop; then
			echo ln -srt "$target" "$file"
		else
			mkdir -p "$target"
			ln -srt "$target" "$file"
		fi
	done
}

if ! [ $(command -v stow) ]; then
	read -rp "GNU stow not installed. Symlink directly? [y/N] " yn
	[ "$yn" = "Y" ] || [ "$yn" = "y" ] || exit
	GNU_STOW=false
fi

if stow_target_exists -v; then
	read -rp "Target files exist. Remove them? [y/N] " yn
	[ "$yn" = "Y" ] || [ "$yn" = "y" ] || exit
	rm -f $(stow_targets)
	if stow_target_exists; then
		if $GNU_STOW; then
			echo "Could not remove all files."
			read -rp "Continue without GNU stow and symlink directly? [Y/n] " yn
		else
			read -rp "Could not remove all files. Continue? [Y/n] " yn
		fi
		[ "$yn" = "N" ] || [ "$yn" = "n" ] || exit
	fi
fi

if ! $GNU_STOW; then
	alias stow=stow_clone
fi
stow -t "$TARGET" $PACKAGES
