#!/bin/sh
set -e

if [ "$EUID" = '0' ]; then
	echo "This script can't be run as root.  Whenever root is needed, the script will use sudo." >&2
	exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo "Running apt-get update" >&2
sudo apt-get update


# ebtables fix
# Credit to russalex: https://github.com/Microsoft/WSL/issues/143#issuecomment-209072634
# Credit to nuclearmistake: https://github.com/Microsoft/WSL/issues/143#issuecomment-209075558

echo "Implementing udev workaround (https://github.com/Microsoft/WSL/issues/143#issuecomment-209072634)" >&2
sudo tee /usr/sbin/policy-rc.d > /dev/null <<EOF
#!/bin/sh
exit 101
EOF
sudo chmod +x /usr/sbin/policy-rc.d
sudo dpkg-divert --local --rename --add /sbin/initctl
sudo ln -fs /bin/true /sbin/initctl


# Upgrade as much as we can
# Credit to heldchen: https://github.com/Microsoft/WSL/issues/1878#issuecomment-338401388

echo "Placing hold on bash (https://github.com/Microsoft/WSL/issues/1878#issuecomment-338401388)" >&2
sudo apt-mark hold bash
echo "Upgrade everything except bash" >&2
sudo apt-get dist-upgrade -y


# Fix bash preinst

echo "Creating temporary working directory" >&2
dir="`mktemp -d`"
pushd "$dir" > /dev/null
echo "Temp dirctory: $dir" >&2

package=bash
while echo "Downloading deb file for $package" >&2 && ! apt-get download "$package"; do
	yn=
	while [ "$yn" != 'y' ]; do
		if ! read -rn1 -p "It looks like bash didn't download successfully.  Do you want to try manually specifying a version? [y/n]: " yn; then
			echo >&2
			echo "Oops; there's no STDIN to read from, so assuming there's no interactive user to provide a version specifier" >&2
			exit 1
		fi
		echo >&2

		if [ "$yn" = 'n' ]; then
			echo "Alright; fix whatever you need to fix, then rerun the script." >&2
			exit 1
		fi
	done

	version=
	while [ -z "$version" ]; do
		read -rp "Enter the version specifier (e.g., 4.4-5ubuntu1): " version
	done
	package="bash=$version"
done

echo "Locating downloaded deb file" >&2
deb="`echo bash_*.deb`"
if [ -z "$deb" -o "$deb" = 'bash_*.deb' ]; then
	echo "Failed to find downloaded deb file for bash in $dir.  Leaving temp directory for inspection.  (Got: deb=$deb)" >&2
	exit 1
fi

echo "Extracting $PWD/$deb to $PWD/deb" >&2
sudo dpkg-deb -x "$deb" deb
echo "Extracting $PWD/$deb metadata to $PWD/deb/DEBIAN" >&2
sudo dpkg-deb -e "$deb" deb/DEBIAN

echo "Replacing preinst binary with a WSL-friendly shell script" >&2
sudo tee deb/DEBIAN/preinst > /dev/null <<'EOD'
#!/bin/sh
set -e

backup() {
	if exists "$1"; then
		cp -dp "$1" "$2" || return $?
	fi
	return 0
}

exists() {
	[ -e "$1" ] || return 1
}

force_symlink() {
	if [ -e "$3" ] && ! unlink "$3"; then
		echo "cannot create symlink $2 -> $1 (unlink)" >&2
		exit 1
	fi

	if ! symlink "$1" "$3"; then
		echo "cannot create symlink $2 -> $1 (symlink)" >&2
		exit 1
	fi

	if ! rename "$3" "$2"; then
		echo "cannot create symlink $2 -> $1 (rename)" >&2
		exit 1
	fi

	return 0
}

symlink() {
	ln -s "$1" "$2" || return $?
}

rename() {
	mv -fT "$1" "$2" || return $?
}

reset_diversion() {
	dpkg-divert --package bash --remove "$2" || return $?
	dpkg-divert --package "$1" --divert "$3" --add "$2" || return $?
}

has_binsh_line() {
	while read -r item; do
		if [ "$item" = '/bin/sh' ]; then
			return 0
		fi
	done
	return 1
}

binsh_in_filelist() {
	dpkg-query -L "$1" 2> /dev/null | has_binsh_line || return $?
}

undiverted() {
	in="`dpkg-divert --listpackage "$1"`" || return $?
	[ -z "$in" -o "$in" = 'bash' ] || return 1
}

access() {
	# This isn't perfectly accurate, but it's sufficient for our purposes.  The syscall is a little different.
	[ -e "$1" ] || return 1
}

main() {
	if access /bin/sh; then
		backup /bin/sh /bin/sh.distrib || return $?
		backup /usr/share/man/man1/sh.1.gz /usr/share/man/man1/sh.distrib.1.gz || return $?

		force_symlink bash /bin/sh /bin/sh.temp || return $?
		force_symlink bash.1.gz /usr/share/man/man1/sh.1.gz /usr/share/man/man1/sh.1.gz.temp || return $?

		if ! binsh_in_filelist bash; then
			return 0
		fi
	fi

	if undiverted /bin/sh; then
		reset_diversion dash /bin/sh /bin/sh.distrib || return $?
	fi
	if undiverted /usr/share/man/man1/sh.1.gz; then
		reset_diversion dash /usr/share/man/man1/sh.1.gz || return $?
	fi

	return 0
}

main || exit $?
EOD
sudo chmod +x deb/DEBIAN/preinst

echo "Repackaging $PWD/$deb" >&2
sudo dpkg-deb -b deb "$deb"

echo "Releasing hold on bash" >&2
sudo apt-mark unhold bash
echo "Installing $PWD/$deb" >&2
sudo dpkg -i "$deb"


echo "Ensuring that everything worked" >&2
sudo apt-get dist-upgrade -y

echo "Cleaning up" >&2
popd > /dev/null
sudo rm -rf -- "$dir"

echo "You're good to go!" >&2
