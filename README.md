# zshrc-configuration

My personal Mac setup: shell config plus a bootstrap script to get a new machine (personal or work, same script for both) ready in one run.

## What is this

- `.zshrc`: my zsh config — [zinit](https://github.com/zdharma-continuum/zinit) as plugin manager, [Starship](https://starship.rs) as prompt, plus a set of Git aliases and functions I use every day, including shortcuts for [Conventional Commits](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13).
- `bootstrap.sh`: installs Xcode CLT, Homebrew, [Ghostty](https://ghostty.org) as terminal, Starship, a handful of dev/brew apps, [Claude Code](https://claude.com/claude-code) and [opencode](https://opencode.ai) as coding agents, then installs this repo's `.zshrc` as `~/.zshrc`.

## How to use it

### Use the bootstrap script

1. Clone this repository
2. If you use the Mac App Store apps in the script (`mas install ...`), make sure you're already signed in to the Mac App Store app first — `mas` can no longer sign in on its own
3. Run `bootstrap.sh`

The script backs up any existing `~/.zshrc` (as `~/.zshrc.bak.<timestamp>`) before installing this repo's version.

### Simply use the .zshrc file config

If you want to use my `.zshrc` on its own, feel free to. A couple of ways to do it:

1. Clone this repository in your `~` folder, then add the following line to your `.zshrc`: `source ~/zshrc-configuration/.zshrc`
2. Just copy paste the aliases or anything else you like from this repo into your own `.zshrc`

Either way, `.zshrc` bootstraps zinit itself on first run (it clones it if missing), but you still need Starship installed separately: `brew install starship`.
