# setup-mac

Homebrew bootstrap for a Mac: installs Homebrew if it's missing, then the tools in the `Brewfile`.

## Install

```sh
./install.sh
```

Installs Homebrew, adds it to your `~/.zprofile` PATH (Apple Silicon or Intel), and runs `brew bundle`. Re-runnable — it skips what's already there.

## What it installs

See `Brewfile`, grouped into sections:

- **Core** — the tools the other `setup-*` repos depend on (`git`, `gh`, `neovim`, `htop`, `nmap`).
- **CLI tools** — other command-line formulae.
- **Apps (casks)** — GUI apps.

Add your own under the right heading; each line is just `brew "name"` or `cask "name"`.

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

### Old macOS check

Before installing anything, `install.sh` asks Homebrew (`brew doctor check_for_unsupported_macos`) whether this macOS is still supported. On an unsupported one there are no prebuilt bottles, so every formula compiles from source and a full install can take hours (LLVM alone, pulled in by `node` and `ripgrep`). The install stops with a message; update macOS and re-run.

To build from source anyway:

```sh
SETUP_ALLOW_OLD_OS=1 ./install.sh
# or, through the bootstrap:
curl -fsSL https://lawrence-berry.github.io/setup | SETUP_ALLOW_OLD_OS=1 sh
```

`sh check-os-test.sh` tests it with fake `brew`s, so it passes on any macOS.
