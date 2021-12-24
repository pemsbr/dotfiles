#!/usr/bin/env bash

echo "Hello $(whoami)! Let's get you set up."

# ask for the administrator password upfront
sudo -v

# 1. brew
# 2. macos
# 3. npm packages

export DEVELOPER="$HOME/Developer"
export DOTFILES="$DEVELOPER/dotfiles"

echo "create $DEVELOPER"
mkdir -p "$DEVELOPER"

echo "symlink dotfiles"
# gh repo clone pemsbr/dotfiles "$DOTFILES"
ln -s "$DOTFILES/terminal/.hushlogin" "$HOME/.hushlogin"
ln -s "$DOTFILES/terminal/zsh/.zshenv" "$HOME/.zshenv"
ln -s "$DOTFILES/terminal/zsh/.zshrc" "$HOME/.zshrc"
ln -s "$DOTFILES/git/.gitattributes" "$HOME/.gitattributes"
ln -s "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
ln -s "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore_global"

echo "install global npm packages"
npm install --global pnpm npm-check-updates

source "$DOTFILES/terminal/init.sh"