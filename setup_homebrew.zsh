#!/usr/bin/env zsh

# Install Homebrew
if exists brew; then
  echo "Skipping Homebrew install. It is already installed."
else
  echo "Installing Homebrew."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install and upgrade (by default) all dependencies from the Brewfile.
brew bundle