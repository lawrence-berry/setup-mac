#!/bin/sh
# Lists things installed via Homebrew that aren't in the Brewfile yet, as ready
# -to-paste lines. Non-destructive — it never edits the Brewfile; you paste the
# lines under the right section. Basis is `brew leaves` (top-level formulae) and
# installed casks, so transitive dependencies aren't listed.
#
# Apps installed from a .dmg (not brew) can't appear here — adopt them first:
#   brew install --cask --adopt <token>
set -e
dir="$(cd "$(dirname "$0")" && pwd)"
bf="$dir/Brewfile"

missing() {  # $1 = keyword (brew|cask); reads installed items on stdin
  have=$(grep "^$1 " "$bf" | sed -E "s/^$1 \"([^\"]+)\".*/\1/")
  while IFS= read -r item; do
    [ -n "$item" ] || continue
    printf '%s\n' "$have" | grep -qxF "$item" || echo "$1 \"$item\""
  done
}

out=$( { brew list --cask | missing cask; brew leaves | missing brew; } )
if [ -n "$out" ]; then
  echo "# Installed but not in the Brewfile — paste under the right section:"
  echo "$out"
else
  echo "Brewfile is up to date with what's installed."
fi
