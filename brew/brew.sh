#!/usr/bin/env zsh

# install homebrew
if exists brew; then
  echo "Skipping homebrew install. It is already installed"
else
  echo "install homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install and upgrade (by default) all dependencies from the Brewfile.
brew bundle
# TODO how to upgrade all at once

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# TODO won't this override the .zshrc file?
