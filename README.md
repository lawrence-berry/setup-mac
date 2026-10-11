# setup-mac

Homebrew bootstrap for a Mac: installs Homebrew if it's missing, then the tools in the `Brewfile`.

## Install

```sh
./install.sh
```

Installs Homebrew, adds it to your `~/.zprofile` PATH (Apple Silicon or Intel), and runs `brew bundle`. Re-runnable — it skips what's already there.

## What it installs

See `Brewfile` — the tools the other `setup-*` repos depend on (`git`, `gh`, `neovim`, `htop`, `nmap`). Add your own by editing the file; it's just a `brew "name"` list.
