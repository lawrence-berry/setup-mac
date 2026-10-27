#!/bin/sh
# Installs iTerm and Claude Code into the current user's home, for a standard user
# on a Mac whose Homebrew belongs to another account. Neither needs admin. Safe to re-run.
set -e

# iTerm: the app from iterm2.com into ~/Applications, unless it is already in either Applications folder.
if [ ! -d /Applications/iTerm.app ] && [ ! -d "$HOME/Applications/iTerm.app" ]; then
  tmp="$(mktemp -d)"
  mkdir -p "$HOME/Applications"
  curl -fsSL https://iterm2.com/downloads/stable/latest -o "$tmp/iterm.zip"
  unzip -q "$tmp/iterm.zip" -d "$HOME/Applications"
  rm -rf "$tmp"
  echo "installed iTerm in ~/Applications"
fi

# Claude Code: the native installer puts `claude` in ~/.local/bin and adds it to PATH.
if [ ! -x "$HOME/.local/bin/claude" ]; then
  curl -fsSL https://claude.ai/install.sh | bash
fi
