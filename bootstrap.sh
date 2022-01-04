#!/usr/bin/env bash

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
BREWINSTALLED=`which brew`
XCODEINSTALLED=`which xcode-select`

#Load configuration
. $CURRDIR/bootstrap.config

# Install Xcode
if [[ ${XCODEINSTALLED} == "" ]]; then
  echo "Installing Xcode"
  xcode-select --install
fi

# Install Brew
if [[ ${BREWINSTALLED} == "" ]]; then
  echo "Installing Brew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#Installer App
brew install wget
brew tap homebrew/cask
brew install mas-cli/tap/mas
sudo softwareupdate --install-rosetta

#App installed via brew
brew install git
brew install docker
brew install httpie
brew install php
brew install composer
brew install --cask slack
brew install --cask postman
brew install --cask phpstorm
brew install --cask intellij-idea
brew install --cask visual-studio-code
brew install --cask background-music
brew install --cask muzzle
brew install --cask cheatsheet
brew install --cask google-chrome
brew install --cask notion
brew install --cask spotify
brew install --cask zoom
brew install --cask steam
brew install --cask discord
brew install --cask audacity

#App installed from Mac App Store via Mas
mas signin $APPSTORE_USERNAME $APPSTORE_PASSWORD

mas install 419332741 #XMenu
mas install 553245401 #Friendly Streaming Browser
mas install 1017470484 #Next Meeting
mas install 408981434 #iMovie

mas signout

#Install iTerm2
if [ ! -f ~/Applications/iTerm.app ]; then
  wget https://iterm2.com/downloads/stable/iTerm2-3_4_15.zip
  unzip -X iTerm2-3_4_15.zip
  mv iTerm.app /Applications/.
  rm -f iTerm2-3_4_15.zip
fi

#Install Oh My Zsh
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    rm ~/.zshrc
    cat $CURRDIR/.zshrc > ~/.zshrc
fi

#Install powerlevel10k
if [ ! -d ~/powerlevel10k ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
fi

#Create bootstrapped file to track execution
touch ~/.bootstrapped.txt

#Done, opening iTerm to trigger powerlevel10k config
open -n /Applications/iTerm.app
