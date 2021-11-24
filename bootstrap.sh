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
APPSTORE_USERNAME=''
APPSTORE_PASSWORD=''

# Install Xcode
if [[ ${XCODEINSTALLED} == "" ]]; then
  echo "Installing Xcode"
  xcode-select --install
fi

# Install Brew
if [[ ${BREWINSTALLED} == "" ]]; then
  echo "Installing Brew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

#Required App
brew tap homebrew/cask
brew install mas-cli/tap/mas

#List your preferred applications
brew install git
brew install docker
brew install httpie
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

#Install from Mac App Store via Mas
mas signin $APPSTORE_USERNAME $APPSTORE_PASSWORD

mas install 419332741 #XMenu
mas install 553245401 #Friendly Streaming Browser
mas install 1017470484 #Next Meeting
mas install 408981434 #iMovie

mas signout

#Install iTerm2
wget https://iterm2.com/downloads/stable/iTerm2-3_4_13.zip
unzip -X iTerm2-3_4_13.zip
mv iTerm.app ~/Applications/.

#Install Oh My Zsh
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    rm ~/.zshrc
    cat $CURRDIR/.zshrc > ~/.zshrc
fi

#Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' > ~/.zshrc

#Create bootstrapped file to track execution
touch ~/.bootstrapped.txt

#Done, opening iTerm to trigger powerlevel10k config
open -n ./iTerm.app 