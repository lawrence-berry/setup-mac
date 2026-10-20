<p align="center"><img src="public/icon.png" alt="setup-mac icon" width="128" height="128"></p>

<h1 align="center">setup-mac</h1>

<p align="center"><b>Homebrew bootstrap, Brewfile and macOS preferences for a fresh Mac. One command, safe to re-run.</b></p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-Homebrew--supported-000000?style=for-the-badge&logo=apple&logoColor=white" alt="macOS Homebrew-supported" />
  <img src="https://img.shields.io/badge/Arch-Apple%20Silicon%20%C2%B7%20Intel-555555?style=for-the-badge&logo=apple&logoColor=white" alt="Arch Apple Silicon · Intel" />
  <img src="https://img.shields.io/badge/Homebrew-Brewfile-FBB040?style=for-the-badge&logo=homebrew&logoColor=white" alt="Homebrew Brewfile" />
  <img src="https://img.shields.io/badge/Shell-POSIX%20sh-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white" alt="Shell POSIX sh" />
</p>

<p align="center">
  <a href="https://github.com/lawrence-berry/setup-mac/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/lawrence-berry/setup-mac/ci.yml?branch=main&style=for-the-badge&logo=githubactions&logoColor=white&label=CI" alt="CI status" /></a>
</p>

Homebrew bootstrap for a Mac: installs Homebrew if it's missing, then the tools in the `Brewfile`.

## Supported versions

| Component | Version | Status |
|---|---|---|
| macOS | any release Homebrew still supports; the install stops on older ones | Checked by `os-current.sh` |
| macOS | 27 (Apple Silicon) | Used daily |
| macOS | 15 | Full install in CI |
| Intel Macs | handled in the `PATH` setup | Not exercised in CI |
| Shell | `/bin/sh` (POSIX) | ShellCheck in CI |

## Install

```sh
./install.sh
```

Installs Homebrew, adds it to your `~/.zprofile` PATH (Apple Silicon or Intel), runs `brew bundle`, then applies the [macOS settings](#macos-settings). Re-runnable — it skips what's already there.

## What it installs

See `Brewfile`, grouped into sections:

- **Core** — the tools the other `setup-*` repos depend on (`git`, `gh`, `neovim`, `htop`, `nmap`).
- **CLI tools** — other command-line formulae.
- **Apps (casks)** — GUI apps.

Add your own under the right heading; each line is just `brew "name"` or `cask "name"`.

### Old macOS check

Before installing anything, `install.sh` asks Homebrew (`brew doctor check_for_unsupported_macos`) whether this macOS is still supported. On an unsupported one there are no prebuilt bottles, so every formula compiles from source and a full install can take hours (LLVM alone, pulled in by `node` and `ripgrep`). The install stops with a message; update macOS and re-run.

To build from source anyway:

```sh
SETUP_ALLOW_OLD_OS=1 ./install.sh
# or, through the bootstrap:
curl -fsSL https://lawrence-berry.github.io/setup | SETUP_ALLOW_OLD_OS=1 sh
```

`sh os-current-test.sh` tests it with fake `brew`s, so it passes on any macOS.

## macOS settings

```sh
./macos-settings.sh
```

Applies system preferences with `defaults write`: dark mode and accent colour, tabs always in windows, the menu bar clock, screenshots to `~/Desktop/Screenshots`, the Dock (autohide, icon size, and its apps in order via `dockutil`, skipping any that aren't installed) and Finder. It then restarts the Dock, Finder and menu bar to apply them. `install.sh` runs it after the Brewfile (which installs `dockutil` and the apps), and a failure there doesn't fail the install. Re-runnable on its own; add new settings under the right heading.

**It replaces the Dock's apps**: it removes everything currently in the Dock first, so edit the app list in the script, not the Dock, if you want a change to stick.

## Keeping it current

```sh
./refresh.sh
```

Lists anything you've installed via Homebrew that isn't in the `Brewfile` yet, as ready-to-paste `brew`/`cask` lines — paste them under the right section. It's non-destructive (never edits the `Brewfile`) and based on `brew leaves` + installed casks, so transitive dependencies aren't listed.

**Apps installed from a `.dmg` (not via Homebrew)** — e.g. a Chrome or VS Code you downloaded yourself — can't be captured, because Homebrew doesn't know about them. Adopt them into Homebrew once and they'll show up from then on:

```sh
brew install --cask --adopt google-chrome visual-studio-code
```

### Deluge

Deluge's cask was disabled (its build fails Apple's Gatekeeper check), so it's not in the `Brewfile`. `install.sh` installs it with `deluge.sh` when it's missing; to reinstall, run:

```sh
./deluge.sh
```

It fetches the build Homebrew pinned, verifies it against Homebrew's sha256, installs it, and clears the quarantine flag so it opens.

## Tests

CI lints every script with ShellCheck and runs `os-current-test.sh` (fake `brew`s) on Ubuntu and macOS. It also runs the full `install.sh` on a throwaway macOS 15 runner and checks Homebrew's `PATH` line, the Core tools and the dark-mode setting.

Part of the [`setup-*`](https://lawrence-berry.github.io/setup) family; on a blank machine, `curl -fsSL https://lawrence-berry.github.io/setup | sh` installs them all (setup-mac and setup-iterm on macOS only).
