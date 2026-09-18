# zshrc-configuration

My personal Mac setup: shell config plus a bootstrap script to get a new machine (personal or work, same script for both) ready in one run.

## What is this

- `.zshrc`: my zsh config — [zinit](https://github.com/zdharma-continuum/zinit) as plugin manager, [Starship](https://starship.rs) as prompt, plus a set of Git aliases and functions I use every day, including shortcuts for [Conventional Commits](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13).
- `bootstrap.sh`: installs Homebrew, [Ghostty](https://ghostty.org) as terminal and [Fresh](https://getfresh.dev) as terminal IDE (with starter configs for both), Starship, a handful of dev/brew apps, [Claude Code](https://claude.com/claude-code) and [opencode](https://opencode.ai) as coding agents, then installs this repo's `.zshrc` as `~/.zshrc`.
- `AGENTS.md`: a tool-inventory file for coding agents (what CLI tools are actually installed, which to prefer over classic Unix tools, git helper functions to reuse). Not installed anywhere automatically — see below.

## How to use it

### Use the bootstrap script

1. Clone this repository
2. Run `bootstrap.sh`

The script backs up any existing `~/.zshrc`, `~/.config/ghostty/config`, and `~/.config/fresh/config.json` (as `<file>.bak.<timestamp>`) before installing this repo's versions.

### Using AGENTS.md

`AGENTS.md` isn't copied anywhere by `bootstrap.sh` — wire it in yourself if/when you want a coding agent to see it:

- opencode: copy or symlink it to `~/.config/opencode/AGENTS.md`
- Claude Code: reference it from `~/.claude/CLAUDE.md` with `@~/projects/zshrc-configuration/AGENTS.md`

### Not automated

A few things `bootstrap.sh` deliberately doesn't handle:

- **Xcode Command Line Tools**: Homebrew's installer will pop up its own GUI prompt for this on a fresh Mac — one click, left alone rather than relying on a fragile silent-install trick.
- **Rectangle / DisplayLink permissions**: macOS requires manually granting Accessibility / Screen Recording in System Settings on first launch — this can't be scripted.
- **[Headroom](https://github.com/headroomlabs-ai/headroom)**: a token-compression proxy for coding agents. Promising, but young/third-party enough that it's worth trying by hand first (`pip install "headroom-ai[all]"`, `headroom wrap claude` or `headroom wrap opencode`) before deciding whether to script it in.

### Simply use the .zshrc file config

If you want to use my `.zshrc` on its own, feel free to. A couple of ways to do it:

1. Clone this repository in your `~` folder, then add the following line to your `.zshrc`: `source ~/zshrc-configuration/.zshrc`
2. Just copy paste the aliases or anything else you like from this repo into your own `.zshrc`

Either way, `.zshrc` bootstraps zinit itself on first run (it clones it if missing), but you still need Starship installed separately: `brew install starship`.
