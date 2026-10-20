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

Installs Homebrew, adds it to the `~/.zprofile` PATH (Apple Silicon or Intel), runs `brew bundle`, then applies the [macOS settings](#macos-settings). Re-runnable; anything already installed is skipped.

## What it installs

See `Brewfile`, grouped into sections:

- **Core** — the tools the other `setup-*` repos depend on (`git`, `gh`, `neovim`, `htop`, `nmap`).
- **CLI tools** — other command-line formulae.
- **Apps (casks)** — GUI apps.

New entries go under the right heading; each line is just `brew "name"` or `cask "name"`.

### Old macOS check

Before installing anything, `install.sh` asks Homebrew (`brew doctor check_for_unsupported_macos`) whether the installed macOS is still supported. On an unsupported release Homebrew has no prebuilt bottles, so every formula compiles from source, and a full install can take multiple hours (LLVM alone, pulled in by `node` and `ripgrep`, accounts for much of that). The install stops with a message instead; updating macOS and re-running avoids the wait.

To build from source anyway:

```sh
SETUP_ALLOW_OLD_OS=1 ./install.sh
# or, through the bootstrap:
curl -fsSL https://lawrence-berry.github.io/setup | SETUP_ALLOW_OLD_OS=1 sh
```

`sh os-current-test.sh` tests the check with fake `brew`s, so it passes on any macOS.

## macOS settings

```sh
./macos-settings.sh
```

Applies system preferences with `defaults write`: dark mode and accent colour, tabs always in windows, the menu bar clock, screenshots to `~/Desktop/Screenshots`, the Dock (autohide, icon size, and its apps in order via `dockutil`, skipping any that aren't installed) and Finder. It then restarts the Dock, Finder and menu bar to apply them. `install.sh` runs it after the Brewfile (which installs `dockutil` and the apps), and a failure there doesn't fail the install. Re-runnable on its own; add new settings under the right heading.

## Keeping it current

```sh
./refresh.sh
```

Lists what is installed with Homebrew but missing from the `Brewfile`, as lines to paste under the right section. The file is never edited; how it works is in the header of `refresh.sh`.

Apps installed from a `.dmg` (not via Homebrew), such as a downloaded Chrome or VS Code, cannot be captured, because Homebrew does not know about them. Adopting them into Homebrew once makes them appear from then on:

```sh
brew install --cask --adopt google-chrome visual-studio-code
```

## Tests

CI lints every script with ShellCheck and runs `os-current-test.sh` (fake `brew`s) on Ubuntu and macOS. It also runs the full `install.sh` on a throwaway macOS 15 runner and checks Homebrew's `PATH` line, the Core tools and the dark-mode setting.

Part of the [`setup-*`](https://lawrence-berry.github.io/setup) family; on a blank machine, `curl -fsSL https://lawrence-berry.github.io/setup | sh` installs them all (setup-mac and setup-iterm on macOS only).
