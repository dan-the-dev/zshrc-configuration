#!/usr/bin/env bash
set -euo pipefail

# Check if already bootstrapped
if [ -f ~/.bootstrapped.txt ]; then
  cat << EOF
~/.bootstrapped.txt FOUND!
This laptop has already been bootstrapped
Exiting. No changes were made.
EOF
  exit 0
fi

# Setup variables
CURRDIR=`pwd`
BREWINSTALLED=`which brew || true`

# Install Brew
if [[ ${BREWINSTALLED} == "" ]]; then
  echo "Installing Brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#Installer App
brew install wget

# Rosetta is only needed on Apple Silicon
if [[ $(uname -m) == "arm64" ]]; then
  softwareupdate --install-rosetta --agree-to-license
fi

#App installed via brew
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
brew install --cask bruno
brew install --cask visual-studio-code
brew install --cask google-chrome
brew install --cask brave-browser
brew install --cask notion
brew install --cask spotify
brew install --cask ghostty
brew install --cask dbeaver-community
brew install --cask rectangle
brew install --cask displaylink

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

#Create bootstrapped file to track execution
touch ~/.bootstrapped.txt

#Done, opening Ghostty to finish the setup
open -n -a Ghostty || true
