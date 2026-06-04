#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)

for command in dpkg-buildpackage dpkg-checkbuilddeps; do
	if ! command -v "$command" >/dev/null 2>&1; then
		echo "Missing build command: $command" >&2
		echo "Install build dependencies with:" >&2
		echo "  sudo apt install dh-dkms debhelper devscripts dpkg-dev fakeroot" >&2
		exit 1
	fi
done

cd "$REPO_ROOT"

if ! dpkg-checkbuilddeps; then
	echo "Install build dependencies with:" >&2
	echo "  sudo apt install dh-dkms debhelper devscripts dpkg-dev fakeroot" >&2
	exit 1
fi

exec dpkg-buildpackage -us -uc -b
