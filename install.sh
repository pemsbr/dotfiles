#!/usr/bin/env zsh

DEVELOPER=$HOME/Developer
DOTFILES=$DEVELOPER/dotfiles

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

symlink() {
  local file=$1
  local link=$2
  if [ ! -e $link ]; then
    ln -s $file $link
    echo "$link -> $file"
  fi
}

backup() {
  local file=$1
  if [ -e $file ] && [ ! -L $file ]; then
    mv $file $file.backup
    echo "Moved old $file to $file.backup"
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

install_brew_packages() {
  echo "🍻 Install brew packages"
  brew bundle --file $DOTFILES/brew/Brewfile
}

setup_gh() {
  if command_exists gh; then
    echo "🔐 GitHub authentication"
    gh auth login
    gh auth status
  fi
}

setup_ohmyzsh() {
  if [ -d $HOME/.oh-my-zsh ]; then
    echo "\033[2mSkipping oh-my-zsh install, it is already installed.\033[m"
  else
    echo "👥 Install oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

install_ohmyzsh_plugins() {
  # TODO
}

create_symlinks() {
  echo "🔗 Symlink dotfiles"
  local dotfiles=(
    $DOTFILES/git/gitattributes
    $DOTFILES/git/gitconfig
    $DOTFILES/git/gitignore
    $DOTFILES/shell/hushlogin
    $DOTFILES/zsh/zprofile
    $DOTFILES/zsh/zshrc
  )

  for file in $dotfiles; do 
    link=$HOME/.$(basename $file)
    backup $link
    symlink $file $link
  done
}

setup_starship() {
  mkdir -p $HOME/.config
  symlink $DOTFILES/zsh/starship.toml $HOME/.config/starship.toml
}

# TODO: macos defaults (including terminal theme/font/size/settings)
main() {
  # exit immediately if a command exits with a non-zero status
  set -e

  echo "Hello $(whoami)! Let's get you set up! 🚀"
  # ask for the administrator password upfront
  sudo -v

  # TODO: read from input
  echo "📁 mkdir $DEVELOPER"
  mkdir -p $DEVELOPER

  setup_brew
  setup_gh
  setup_ohmyzsh
  setup_starship
  create_symlinks

  # echo "👉 Cloning into $DOTFILES"
  # TODO
  # gh repo clone pemsbr/dotfiles $DOTFILES -- --depth 1

  echo "📦 Install global npm packages"
  npm install --global pnpm npm-check-updates

  echo "Awesome, all set. 🌈"

  # refresh the current shell with the newly installed configuration.
  source $HOME/.zshrc
}

main "$@"