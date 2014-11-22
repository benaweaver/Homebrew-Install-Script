#!/bin/sh

# Laptop reboot Script to install dev tools (Node, npm, Ruby, ...) and applications (Spotify, Google Chrome, Eclipse, ...)

if [[ ! -d "$HOME/.bin/" ]]; then
  mkdir "$HOME/.bin"
fi

if [[ ":$PATH:" != *":$HOME/.bin:"* ]]; then
  printf 'export PATH="$HOME/.bin:$PATH"\n' >> ~/.zshrc
  export PATH="$HOME/.bin:$PATH"
fi

if ! command -v brew >/dev/null; then
  echo "Installing Homebrew"
  ruby <(curl -fsS https://raw.githubusercontent.com/Homebrew/install/master/install)
  export PATH="/usr/local/bin:$PATH"
else
  echo "Homebrew already installed"
fi

# Functions used to install dev tools using Homebrew

installed() {
  local NAME=$(brew_expand_alias "$1")

  brew list -1 | grep -Fqx "$NAME"
}


brew_launchctl_restart() {
  local NAME=$(brew_expand_alias "$1")
  local DOMAIN="homebrew.mxcl.$NAME"
  local PLIST="$DOMAIN.plist"

  mkdir -p ~/Library/LaunchAgents
  ln -sfv /usr/local/opt/$NAME/$PLIST ~/Library/LaunchAgents

  if launchctl list | grep -q $DOMAIN; then
    launchctl unload ~/Library/LaunchAgents/$PLIST >/dev/null
  fi
  launchctl load ~/Library/LaunchAgents/$PLIST >/dev/null
}

upgrade()) {
	if installed "$1"; then
    brew upgrade "$@"
  else
    brew install "$@"
  fi
}

# Start Homebrew install of dev tools

echo "Installing Github CLI"
brew upgrade 'gh'

echo "Installing Postgres"
brew upgrade 'postgres'

node_version="0.10.13" #Set version of node to be installed

echo "Installing NVM, node.js, NPM for javascript"
brew upgrade 'nvm'
export PATH="$PATH:/usr/local/lib/node_modules"
nvm install "$node_version"
echo "Set global default for node.js as $node_version"
nvm alias default "$node_version"

echo "Installing Heroku CLI"
brew upgrade 'heroku-toolbelt'


# Homebrew applications install

echo "Start installation of applications"

brew cask install google-chrome
brew cask install sublime-text
brew cask install spotify
brew cask install eclipse-java
brew cask install coconutbattery
brew cask install crashplan
brew cask install handbrake
brew cask install dropbox
brew cask install caffeine
brew cask install jdownloader
brew cask install vlc
brew cask install skype
brew cask install clipmenu
brew cask install firefox
brew cask install skim
brew cask install evernote
