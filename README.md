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
  <a href="https://github.com/lawrence-berry/setup-mac/actions/workflows/macos.yml"><img src="https://img.shields.io/github/actions/workflow/status/lawrence-berry/setup-mac/macos.yml?branch=main&style=for-the-badge&logo=apple&logoColor=white&label=macOS%2015" alt="macOS 15 CI status" /></a>
  <a href="https://github.com/lawrence-berry/setup-mac/actions/workflows/linux.yml"><img src="https://img.shields.io/github/actions/workflow/status/lawrence-berry/setup-mac/linux.yml?branch=main&style=for-the-badge&logo=ubuntu&logoColor=white&label=Ubuntu%2024.04" alt="Ubuntu 24.04 CI status" /></a>
</p>

Homebrew bootstrap for a Mac: installs Homebrew if it's missing, then the tools in the `Brewfile`.

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

Before installing anything, `install.sh` stops on a macOS Homebrew no longer supports (everything would compile from source). `SETUP_ALLOW_OLD_OS=1` overrides it; see the header of `os-current.sh`.

## macOS settings

```sh
./macos-settings.sh
```

Applies system preferences with `defaults write`: dark mode and accent colour, tabs always in windows, the menu bar clock, screenshots to `~/Desktop/Screenshots`, the Dock (autohide, icon size, and its apps in order via `dockutil`, skipping any that aren't installed) and Finder. It then restarts the Dock, Finder and menu bar to apply them. `install.sh` runs it after the Brewfile (which installs `dockutil` and the apps), and a failure there doesn't fail the install. Re-runnable on its own; add new settings under the right heading.

## Keeping it current

```sh
./refresh.sh
```

Lists what you've installed with Homebrew that isn't in the `Brewfile` yet, as lines to paste under the right section. It never edits the file; how it works, and how to adopt apps installed from a `.dmg`, is in the header of `refresh.sh`.

## Tests

CI lints every script with ShellCheck and runs `os-current-test.sh` (fake `brew`s) on Ubuntu and macOS. It also runs the full `install.sh` on a throwaway macOS 15 runner and checks Homebrew's `PATH` line, the Core tools and the dark-mode setting.

Part of the [`setup-*`](https://lawrence-berry.github.io/setup) family; on a blank machine, `curl -fsSL https://lawrence-berry.github.io/setup | sh` installs them all (setup-mac and setup-iterm on macOS only).
