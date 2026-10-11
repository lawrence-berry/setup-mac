#!/bin/sh
# Installs Homebrew (if missing) and everything in the Brewfile. Safe to re-run.
set -e
dir="$(cd "$(dirname "$0")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Homebrew's location is set by CPU arch. Add it to future shells' PATH.
[ "$(uname -m)" = arm64 ] && brew=/opt/homebrew/bin/brew || brew=/usr/local/bin/brew
line="eval \"\$($brew shellenv)\""
grep -qsF "$brew shellenv" "$HOME/.zprofile" || echo "$line" >> "$HOME/.zprofile"

"$brew" bundle --file="$dir/Brewfile"
echo "done — tools installed"
