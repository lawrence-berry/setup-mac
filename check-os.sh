#!/bin/sh
# Stops the install on a macOS that Homebrew no longer supports. There are no
# prebuilt bottles there, so every formula compiles from source (LLVM alone can
# take hours). Asks Homebrew itself, so there's no version number to keep current.
#   sh check-os.sh /opt/homebrew/bin/brew
# Set SETUP_ALLOW_OLD_OS=1 to build from source anyway.
set -e
brew="${1:-brew}"

[ -n "${SETUP_ALLOW_OLD_OS:-}" ] && exit 0
# An unknown check name would fail too: if this brew lacks the check, don't block.
"$brew" doctor --list-checks 2>/dev/null | grep -qx check_for_unsupported_macos || exit 0

if ! out="$("$brew" doctor check_for_unsupported_macos 2>&1)"; then
  printf '%s\n\n' "$out" >&2
  echo "Stopping: this macOS has no Homebrew bottles, so the install would compile everything." >&2
  echo "Update macOS and re-run, or set SETUP_ALLOW_OLD_OS=1 to build from source anyway." >&2
  exit 1
fi
