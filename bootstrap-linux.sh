#!/usr/bin/env bash
set -euo pipefail

# Terminal-only bootstrap for headless Ubuntu machines (VPS). No GUI apps here —
# see bootstrap.sh for the macOS version with the full desktop app list.

# Check if already bootstrapped
if [ -f ~/.bootstrapped.txt ]; then
  cat << EOF
~/.bootstrapped.txt FOUND!
This machine has already been bootstrapped
Exiting. No changes were made.
EOF
  exit 0
fi

# Setup variables
CURRDIR=`pwd`
BREWINSTALLED=`command -v brew || true`

# Prerequisites for Homebrew on Linux + zsh itself
sudo apt-get update
sudo apt-get install -y build-essential procps curl file git zsh

# Install Homebrew (same package manager as the macOS setup, so the CLI tool
# list below stays close to identical between the two scripts)
if [[ ${BREWINSTALLED} == "" ]]; then
  echo "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

#Terminal toolkit installed via brew (mirrors bootstrap.sh, minus every cask/GUI app)
brew install wget
brew install git
brew install httpie
brew install jq
brew install node
brew install starship
brew install neovim
brew install ripgrep
brew install bat
brew install eza
brew install zoxide
brew install fzf
brew install git-delta
brew install lazygit
brew install git-lfs
brew install herdr
brew install fd
brew install tlrc
brew install glow
brew install btop

#Git global defaults
git config --global init.defaultBranch main
git config --global core.editor nvim
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git lfs install

#App installed via npm
npm install --global yarn

#Coding agents
npm install --global @anthropic-ai/claude-code
brew install opencode

#App installed via curl
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

#Install zinit (zsh plugin manager)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

#Install this repo's .zshrc, backing up any existing one
if [ -f ~/.zshrc ]; then
  cp ~/.zshrc ~/.zshrc.bak.$(date +%Y%m%d%H%M%S)
fi
cat $CURRDIR/.zshrc > ~/.zshrc

#Make zsh the login shell (Ubuntu defaults to bash)
if [ "$(basename "$SHELL")" != "zsh" ]; then
  sudo chsh -s "$(command -v zsh)" "$(whoami)"
  echo "Shell di default impostata su zsh: serve una nuova sessione SSH perché diventi effettiva."
fi

#Create bootstrapped file to track execution
touch ~/.bootstrapped.txt

echo "Bootstrap completato. Apri una nuova sessione (o esegui 'exec zsh') per usare la shell configurata."
