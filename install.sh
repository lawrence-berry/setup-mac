#!/bin/sh
# Installs Homebrew (if missing) and everything in the Brewfile. Safe to re-run.
set -e
dir="$(cd "$(dirname "$0")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Put brew on PATH for this run and future shells (Apple Silicon or Intel).
for p in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [ -x "$p" ] && brew_path="$p" && break
done
eval "$("$brew_path" shellenv)"
prof="$HOME/.zprofile"
line="eval \"\$($brew_path shellenv)\""
touch "$prof"
grep -qF "$brew_path shellenv" "$prof" || printf '%s\n' "$line" >> "$prof"

brew bundle --file="$dir/Brewfile"
echo "done — tools installed"
