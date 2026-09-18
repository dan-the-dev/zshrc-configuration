# AGENTS.md

Tool inventory for coding agents (Claude Code, opencode, etc.) running on a machine set up with this repo's `bootstrap.sh`. This file is **not installed anywhere automatically** — copy or symlink it to `~/.config/opencode/AGENTS.md`, or reference it with `@path` from `~/.claude/CLAUDE.md`, if you want an agent to pick it up.

This is a tool inventory, not personal/workflow rules — those belong in the user's own `~/.claude/CLAUDE.md` (secrets handling, artifact conventions, notification rules, etc.), not here.

## Prefer these over the classic Unix tools

- `rg` (ripgrep) over `grep`
- `fd` over `find`
- `bat` over `cat` when the output is for a human to read (syntax highlighting); plain `cat` is still fine for piping into other commands
- `eza` over `ls` — already aliased as `ls`, `ll`, `la`, `lt` in `.zshrc`
- Diffs already go through `git-delta` (`core.pager` and `interactive.diffFilter` are set globally) — don't pipe `git diff` through anything else

## Other installed CLI tools

- `jq` — JSON processing
- `httpie` (`http`) — alternative to `curl` for quick manual requests
- `tlrc` — tldr-style quick command reference
- `glow` — render Markdown in the terminal
- `lazygit` (`lg`) — interactive TUI git client; not scriptable, don't shell out to it non-interactively
- `btop` — interactive process monitor; same caveat as lazygit

## Session and workspace tools

- `herdr` — background agent-session multiplexer. Agent sessions it manages can outlive the current terminal/attach. Don't assume a process's lifetime matches the lifetime of the terminal you're currently attached from.
- `fresh` — a terminal IDE with its own agent Orchestrator (can run `claude`/`opencode`/`aider`/`codex` in workspaces). Informational only — an agent shouldn't shell out to `fresh` itself.

## Git helpers defined in `.zshrc`

Prefer these over raw `git commit -m "..."` when committing on this machine, for consistency with the user's Conventional Commits convention:

- `gcmfeat "msg" [scope]`, `gcmfix`, `gcmrefactor`, `gcmperf`, `gcmstyle`, `gcmtest`, `gcmdocs`, `gcmbuild`, `gcmops`, `gcmchore`, `gcmci`, `gcmrevert` — each wraps `git commit -m "type(scope): msg"`
- `gsquash` — squashes all local commits ahead of upstream/main into one `feat: ...` commit and pushes
- `local_rebase_merge <branch> [target=main]` / `local_rebase_squash_merge <branch> "<message>" [target=main]` — local rebase-then-merge workflows

## Node

`node`, `npm`, `npx`, `yarn` are lazy-loaded via `nvm` on first invocation in a shell — a first call being slightly slower than subsequent ones is expected, not an error.
