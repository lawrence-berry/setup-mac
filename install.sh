#!/bin/sh
# Installs Homebrew (if missing) and everything in the Brewfile. Safe to re-run.
# If another user already owns Homebrew, adds it to PATH, installs iTerm and Claude Code in this home
# (user-apps.sh) and applies the macOS settings.
set -e
dir="$(cd "$(dirname "$0")" && pwd)"

# Homebrew's location is set by CPU arch.
[ "$(uname -m)" = arm64 ] && brew=/opt/homebrew/bin/brew || brew=/usr/local/bin/brew

# Homebrew already there but owned by another user (a second account on a shared Mac):
# it can't be installed into or updated from here, so only put it on PATH and set preferences.
# Checked by path, not `command -v`: a new user's PATH doesn't have brew yet.
shared=
if [ -x "$brew" ] && [ "$(stat -f %u "$brew")" != "$(id -u)" ]; then shared=1; fi

if [ -z "$shared" ] && ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Add it to future shells' PATH.
line="eval \"\$($brew shellenv)\""
grep -qsF "$brew shellenv" "$HOME/.zprofile" || echo "$line" >> "$HOME/.zprofile"

if [ -n "$shared" ]; then
  echo "Homebrew belongs to another user: added to PATH, installing iTerm and Claude Code in this home only."
  sh "$dir/user-apps.sh" || echo "note: user-apps.sh failed — see above"
  PATH="$(dirname "$brew"):$PATH" sh "$dir/macos-settings.sh" || echo "note: macos-settings.sh failed — see above"
  echo "done"
  exit 0
fi

# Stop early on a macOS Homebrew no longer supports (no bottles: everything compiles).
# SETUP_ALLOW_OLD_OS=1 overrides.
sh "$dir/os-current.sh" "$brew"

# Don't abort on a partial failure (e.g. an app not yet adopted, or App Store
# not signed in). bundle still installs everything else; just flag it.
"$brew" bundle --file="$dir/Brewfile" || echo "note: some Brewfile entries were skipped or failed above — see the summary"
# Deluge has no working cask, so it has its own installer. Skip if present.
[ -d /Applications/Deluge.app ] || "$dir/deluge.sh"
# macOS preferences (needs dockutil from the Brewfile). Don't abort the install if it fails.
sh "$dir/macos-settings.sh" || echo "note: macos-settings.sh failed — see above"
echo "done"
