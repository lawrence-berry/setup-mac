#!/bin/sh
# Applies macOS settings. Re-runnable; add new settings under the right heading.
# Check a current value with: defaults read <domain> <key>
# Replaces the Dock's apps: it removes everything in the Dock first, so edit the
# app list below, not the Dock, if you want a change to stick.
set -e

# Appearance: dark mode, green accent, tinted-dark icons, Liquid Glass tint
defaults write NSGlobalDomain AppleInterfaceStyle Dark
defaults write NSGlobalDomain AppleAccentColor -int 3
defaults write NSGlobalDomain AppleIconAppearanceTheme TintedDark
defaults write NSGlobalDomain NSGlassTintAmount -float 0.119966

# Windows: tabs always, no minimise on title-bar double-click
defaults write NSGlobalDomain AppleWindowTabbingMode always
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false

# Menu bar clock: weekday and AM/PM, no date
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowAMPM -bool true
defaults write com.apple.menuextra.clock ShowDate -int 0

# Screenshots and screen recordings go to ~/Desktop/Screenshots. The Screenshot app
# keeps a folder per kind next to the plain `location`, so all three are set.
mkdir -p ~/Desktop/Screenshots
defaults write com.apple.screencapture location ~/Desktop/Screenshots
defaults write com.apple.screencapture location-screenshot ~/Desktop/Screenshots
defaults write com.apple.screencapture location-screenrecording ~/Desktop/Screenshots

# Dock: autohide, 72pt icons, magnification, minimise into the app icon
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 72
defaults write com.apple.dock largesize -int 72
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock mineffect genie
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock mru-spaces -bool false   # keep Spaces in a fixed order

# Dock apps, in order (needs dockutil from the Brewfile; skips apps not installed)
dockutil --no-restart --remove all >/dev/null
for app in \
  "/Applications/Google Chrome.app" "/Applications/Visual Studio Code.app" \
  "/Applications/GitHub Desktop.app" "/Applications/Slack.app" \
  "/Applications/WhatsApp.app" "/Applications/1Password.app" \
  "$HOME/Applications/iTerm.app" "/Applications/iTerm.app" \
  "/Applications/UTM.app" "/System/Applications/System Settings.app" \
  "/Applications/Wispr Flow.app" "/System/Applications/Apps.app" \
  "/Applications/Safari.app" "/System/Applications/Mail.app" \
  "/System/Applications/Calendar.app" "/System/Applications/Notes.app" \
  "/System/Applications/App Store.app"; do
  [ -e "$app" ] || continue
  dockutil --find "$(basename "$app" .app)" >/dev/null 2>&1 || dockutil --no-restart --add "$app" >/dev/null
done
dockutil --no-restart --add ~/Downloads --view fan --display stack --sort dateadded >/dev/null

# Finder: list view; show external drives and removable media on the desktop, not the internal disk
defaults write com.apple.finder FXPreferredViewStyle Nlsv
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

# Restart the processes that read the settings above
killall SystemUIServer Dock Finder
