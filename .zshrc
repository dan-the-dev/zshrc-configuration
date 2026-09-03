# zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Plugins (git/docker/wd reuse the oh-my-zsh plugins without the full framework)
zinit snippet OMZP::git
zinit snippet OMZP::docker
zinit snippet OMZP::wd

zinit light zsh-users/zsh-autosuggestions

autoload -Uz compinit
# Rebuild the completion cache at most once a day; -C skips the checks otherwise
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# syntax-highlighting must be loaded last
zinit light zsh-users/zsh-syntax-highlighting

# Starship prompt
eval "$(starship init zsh)"

# zoxide (smarter cd, jump to a dir by partial name with `z`)
eval "$(zoxide init zsh)"

# fzf (fuzzy finder: ctrl+r history, ctrl+t files, alt+c cd)
eval "$(fzf --zsh)"

# User configuration

export PATH="$HOME/.local/bin:$PATH"

export EDITOR="nvim"
export VISUAL="$EDITOR"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Generic Aliases
alias help='cat ~/.zshrc'
alias vim='nvim'
alias vi='nvim'
alias cat='bat'
alias ls='eza'
alias ll='eza -l'
alias la='eza -la'
alias lt='eza --tree'
alias lg='lazygit'

# Git Aliases
alias gco='git checkout'
alias gcom='git checkout main'
alias gcomst='git checkout master'
alias gcb='git checkout -b'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gaap='git add -p .'
alias gaaa='git add . -A'
alias gaaap='git add . -A -p'
alias gd='git diff'
alias gdc='git diff --cached'
alias gp='git pull'
alias gps='git push'
alias gpsf='git push --force'
alias gpsfl='git push --force-with-lease'
alias gpst='git push --tags'
alias gcm='git commit -m'
alias gcme='git commit --allow-empty -m'
alias gcma='git commit -am'
alias gcam='git commit --amend'
alias gb='git branch'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gl='git log'
alias glog='git log --oneline --graph --decorate'
alias gm='git merge'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias grlst='git reset --soft HEAD~1'
alias grbc='git rebase --continue'
alias grba='git rebase --abort'
alias gsta='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gt='git tag'

function current_branch() {
  git branch --show-current
}

## these aliases take advantage of the previous function
alias gpssu='git push --set-upstream origin $(current_branch)'

## these functions are shortcuts for Git commits using Conventional Commits (https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13)
## usage: gcm<type> "message" ["scope"]  ->  "type(scope): message" (scope is optional)
function __conventional_commit() {
	local type="$1" message="$2" scope="$3"
	git commit -m "${type}${scope:+($scope)}: ${message}"
}

function gcmfeat()     { __conventional_commit feat "$1" "$2"; }      ## adds a new feature
function gcmfix()      { __conventional_commit fix "$1" "$2"; }       ## fixes a bug
function gcmrefactor() { __conventional_commit refactor "$1" "$2"; }  ## rewrites/restructures code without changing behaviour
function gcmperf()     { __conventional_commit perf "$1" "$2"; }      ## improves performance
function gcmstyle()    { __conventional_commit style "$1" "$2"; }     ## formatting only, no meaning change
function gcmtest()     { __conventional_commit test "$1" "$2"; }      ## adds/fixes tests
function gcmdocs()     { __conventional_commit docs "$1" "$2"; }      ## documentation only
function gcmbuild()    { __conventional_commit build "$1" "$2"; }     ## build tool, ci pipeline, dependencies, project version, ...
function gcmops()      { __conventional_commit ops "$1" "$2"; }       ## infrastructure, deployment, backup, recovery, ...
function gcmchore()    { __conventional_commit chore "$1" "$2"; }     ## misc, e.g. modifying .gitignore
function gcmci()       { __conventional_commit ci "$1" "$2"; }        ## CI configuration/scripts
function gcmrevert()   { __conventional_commit revert "$1" "$2"; }    ## reverts a previous commit

function lint-commit() {
  echo "File che verranno aggiunti e amendati nell'ultimo commit:"
  git status --short
  git add -A
  git commit --amend --no-edit
}

# Merge locale con rebase (mantiene tutti i commit del branch)
# Uso: local_rebase_merge nome-branch [main]
local_rebase_merge() {
  local branch="$1"
  local target="${2:-main}"

  if [ -z "$branch" ]; then
    echo "Uso: local_rebase_merge <branch> [target=main]"
    return 1
  fi

  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Ci sono modifiche non committate: fai commit o stash prima di continuare"
    return 1
  fi

  git checkout "$branch" || return 1
  git rebase "$target" || { echo "Rebase fallito, risolvi i conflitti e rilancia 'git rebase --continue'"; return 1; }

  git checkout "$target" || return 1
  git merge --ff-only "$branch" || return 1
  git push origin "$target" || return 1

  echo "✅ $branch mergiato su $target con rebase. Ora puoi eliminarlo con: git branch -d $branch"
}

# Merge locale con squash (un solo commit riassuntivo)
# Uso: local_rebase_squash_merge nome-branch "messaggio commit" [main]
local_rebase_squash_merge() {
  local branch="$1"
  local message="$2"
  local target="${3:-main}"

  if [ -z "$branch" ] || [ -z "$message" ]; then
    echo "Uso: local_rebase_squash_merge <branch> \"<messaggio commit>\" [target=main]"
    return 1
  fi

  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Ci sono modifiche non committate: fai commit o stash prima di continuare"
    return 1
  fi

  git checkout "$branch" || return 1
  git rebase "$target" || { echo "Rebase fallito, risolvi i conflitti e rilancia 'git rebase --continue'"; return 1; }

  git checkout "$target" || return 1
  git merge --squash "$branch" || return 1
  git commit -m "$message" || return 1
  git push origin "$target" || return 1

  echo "✅ $branch squashato su $target con commit: \"$message\". Ora puoi eliminarlo con: git branch -d $branch"
}

# Squash di tutti i commit locali del branch corrente in un solo commit "feat: ...",
# chiedendo il messaggio a runtime, e lo pusha (force-with-lease se il branch ha già
# un upstream, altrimenti primo push con --set-upstream). Utile dopo un flusso TDD
# con tanti commit intermedi. Uso: gsquash
function gsquash() {
  local base=""

  base=$(git merge-base HEAD '@{u}' 2>/dev/null)
  if [ -z "$base" ]; then
    if git show-ref --verify --quiet refs/heads/main; then
      base=$(git merge-base HEAD main)
    elif git show-ref --verify --quiet refs/heads/master; then
      base=$(git merge-base HEAD master)
    fi
  fi

  if [ -z "$base" ]; then
    echo "Impossibile determinare il branch di base (nessun upstream, nessun main/master locale)"
    return 1
  fi

  if [ "$base" = "$(git rev-parse HEAD)" ]; then
    echo "Nessun commit locale da squashare"
    return 1
  fi

  echo "Commit che verranno squashati in un solo 'feat: ...':"
  git log --oneline "$base"..HEAD
  echo ""
  echo -n "Messaggio del commit (verrà categorizzato come feat): "
  read -r message

  if [ -z "$message" ]; then
    echo "Messaggio vuoto, operazione annullata"
    return 1
  fi

  git reset --soft "$base" || return 1
  git commit -m "feat: $message" || return 1

  if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
    if ! git push --force-with-lease; then
      echo ""
      echo "Push rifiutato: il branch remoto è cambiato dal tuo ultimo fetch (qualcuno ha pushato nel frattempo)."
      echo "Il commit squashato è comunque salvo in locale. Per andare avanti:"
      echo "  1. git fetch origin"
      echo "  2. git log HEAD..origin/$(current_branch)   # guarda cosa c'è di nuovo sul remoto"
      echo "  3. se va tenuto: git rebase origin/$(current_branch), poi ripeti gsquash o il push"
      echo "     se è superato ed è tua certezza scartarlo: git push --force"
      return 1
    fi
  else
    git push --set-upstream origin "$(current_branch)"
  fi
}

export NVM_DIR="$HOME/.nvm"

# Lazy-load nvm: sourcing nvm.sh on every shell start is slow. These stubs load
# it for real only the first time nvm/node/npm/npx/yarn is actually used.
_load_nvm() {
  unset -f nvm node npm npx yarn
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm()  { _load_nvm; nvm "$@"; }
node() { _load_nvm; node "$@"; }
npm()  { _load_nvm; npm "$@"; }
npx()  { _load_nvm; npx "$@"; }
yarn() { _load_nvm; yarn "$@"; }
