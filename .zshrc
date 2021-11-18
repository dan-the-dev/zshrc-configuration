# Generic Aliases
alias help='cat ~/.zshrc'

# Git Aliases
alias gco='git checkout'
alias gcom='git checkout master'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gaap='git add -p .'
alias gp='git pull'
alias gps='git push'
alias gcm='git commit -m'
alias gb='git branch'
alias gl='git log'
alias gm='git merge'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias grlst='git reset --soft HEAD~1'

function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

## these aliases take advantage of the previous function
alias gpssu='git push --set-upstream origin $(current_branch)'

## these functions are shortcuts for Git commits using Conventional Commits (https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13)
function gcmfeat() {
	## Commits, that adds a new feature
	git commit -m "feat: $1"
}
function gcmfix() {
	## Commits, that fixes a bug
	git commit -m "fix: $1"
}
function gcmrefactor() {
	## Commits, that rewrite/restructure your code, however does not change any behaviour
	git commit -m "refactor: $1"
}
function gcmperf() {
	## Commits are special refactor commits, that improves performance
	git commit -m "perf: $1"
}
function gcmstyle() {
	## Commits, that do not affect the meaning (white-space, formatting, missing semi-colons, etc)
	git commit -m "style: $1"
}
function gcmtest() {
	## Commits, that add missing tests or correcting existing tests
	git commit -m "test: $1"
}
function gcmdocs() {
	## Commits, that affect documentation only
	git commit -m "docs: $1"
}
function gcmbuild() {
	## Commits, that affect build components like build tool, ci pipeline, dependencies, project version, ...
	git commit -m "build: $1"
}
function gcmops() {
	## Commits, that affect operational components like infrastructure, deployment, backup, recovery, ...
	git commit -m "ops: $1"
}
function gcmchore() {
	## Miscellaneous commits e.g. modifying .gitignore
	git commit -m "chore: $1"
}
