#!/usr/bin/env zsh

DEVELOPER=$HOME/Developer
DOTFILES=$DEVELOPER/dotfiles

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

symlink() {
  local file="$1"
  local link="$2"
  if [ ! -e $link ]; then
    ln -s $file $link
    echo "🔗 $link -> $file"
  fi
}

backup() {
  local file="$1"
  if [ -e $file ] && [ ! -L $file ]; then
    file_backup="$file.backup_$(date +%Y-%m-%d_%H-%M-%S)"
    echo "Found $file, renaming to $file_backup"
    mv $file $file_backup
  fi
}

setup_brew() { 
  if command_exists brew; then
    echo "\033[2mSkipping homebrew install, it is already installed.\033[m"
  else
    echo "🍺 Install homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  install_brew_packages
}

setup_ssh() {
  if command_exists gh; then
    echo "🔐 GitHub authentication"
    gh auth login
    gh auth status
  fi
}

create_symlinks() {
  local dotfiles=(
    "$DOTFILES/git/gitattributes"
    "$DOTFILES/git/gitconfig"
    "$DOTFILES/git/gitignore"
    "$DOTFILES/shell/hushlogin"
    "$DOTFILES/zsh/zprofile"
    "$DOTFILES/zsh/zshrc"
  )

  for file in "${dotfiles[@]}"; do
    link="$HOME/.$(basename $file)"
    backup $link
    symlink $file $link
  done
}

setup_sheldon() {
  mkdir -p "$HOME/.sheldon"
  symlink "$DOTFILES/zsh/sheldon.toml" "$HOME/.sheldon/plugins.toml"
}

setup_starship() {
  mkdir -p "$HOME/.config"
  symlink "$DOTFILES/zsh/starship.toml" "$HOME/.config/starship.toml"
}

install_brew_packages() {
  echo "🍻 Install brew packages"
  brew bundle --file "$DOTFILES/brew/Brewfile"
}

install_npm_packages() {
  echo "📦 Install global npm packages"
  npm install --global pnpm npm-check-updates
}

main() {
  # exit immediately if a command exits with a non-zero status
  set -e

  echo "Hello $(whoami)! Let's get you set up! 🚀"
  # ask for the administrator password upfront
  sudo -v

  # TODO: read from input
  echo "📁 mkdir $DEVELOPER"
  mkdir -p "$DEVELOPER"

  setup_brew
  setup_ssh
  setup_starship
  setup_sheldon
  create_symlinks
  install_npm_packages
  
  if [ ! -d "$DOTFILES" ]; then
    echo "👉 Cloning into $DOTFILES"
    gh repo clone pemsbr/dotfiles "$DOTFILES" -- --depth 1
  fi
  
  echo "Awesome, all set. 🌈"

  # refresh the current shell with the newly installed configuration.
  exec zsh -l
}

main "$@"