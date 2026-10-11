#!/bin/sh
# Installs Deluge. Its Homebrew cask was disabled because the build fails
# Apple's Gatekeeper check, so this fetches the same build Homebrew pinned,
# verifies it against Homebrew's sha256, installs it, and clears the quarantine
# flag so it opens (that flag is the Gatekeeper block the disable was about).
# Re-running replaces the app. Not run by install.sh — run it yourself.
set -e
version="1.3.15.1"
url="https://ftp.osuosl.org/pub/deluge/mac_osx/deluge-${version}-macosx-x64.dmg"
sha="a78a477f0a492c96cfa3e68a6551c36c6b451fc91b19df433027ef189f757baa"

tmp="$(mktemp -d)"
trap 'hdiutil detach "$tmp/mnt" >/dev/null 2>&1 || true; rm -rf "$tmp"' EXIT

curl -fsSL "$url" -o "$tmp/deluge.dmg"
echo "$sha  $tmp/deluge.dmg" | shasum -a 256 -c -   # aborts if it doesn't match

mkdir "$tmp/mnt"
hdiutil attach "$tmp/deluge.dmg" -nobrowse -quiet -mountpoint "$tmp/mnt"
app="$(find "$tmp/mnt" -maxdepth 1 -name '*.app' | head -1)"
name="$(basename "$app")"
rm -rf "/Applications/$name"
cp -R "$app" /Applications/
xattr -dr com.apple.quarantine "/Applications/$name" 2>/dev/null || true
echo "installed $name ($version)"
