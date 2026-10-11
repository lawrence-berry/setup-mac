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

# Don't abort on a partial failure (e.g. an app not yet adopted, or App Store
# not signed in). bundle still installs everything else; just flag it.
"$brew" bundle --file="$dir/Brewfile" || echo "note: some Brewfile entries were skipped or failed above — see the summary"
# Deluge has no working cask, so it has its own installer. Skip if present.
[ -d /Applications/Deluge.app ] || "$dir/deluge.sh"
echo "done"
