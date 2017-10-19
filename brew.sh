#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Go through the Brewfile
brew bundle

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# We installed the new shell, now we have to activate it
echo "Adding the newly installed shell to the list of allowed shells"
# Prompts for password
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
# Change to the new shell, prompts for password
chsh -s /usr/local/bin/bash

echo "install rvm"
curl -L https://get.rvm.io | bash -s stable --ignore-dotfiles
source ~/.rvm/scripts/rvm
echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
source ~/.bashrc

if brew list | grep --silent "qt@5.5"; then
  echo "Symlink qmake binary to /usr/local/bin for Capybara Webkit..."
  brew unlink qt@5.5
  brew link --force qt@5.5
fi

echo "Update heroku binary..."
brew unlink heroku
brew link --force heroku

# Lxml and Libxslt
brew link libxml2 --force
brew link libxslt --force

# Remove outdated versions from the cellar.
brew cleanup

mackup restore
