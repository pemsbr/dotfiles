#!/usr/bin/env zsh

ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$ZSH/custom"
DEVELOPER=$HOME/Developer
DOTFILES=$DEVELOPER/dotfiles

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

setup_color() {
  # TODO
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

create_symlinks() {
  echo "🔗 Symlink dotfiles"
  dotfiles=(
    $DOTFILES/git/gitattributes
    $DOTFILES/git/gitconfig
    $DOTFILES/git/gitignore_global
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

setup_brew() { 
  if command_exists brew; then
    echo "\033[2mSkipping homebrew install, it is already installed.\033[m"
  else
    echo "🍺 Install homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  brew bundle --file $DOTFILES/brew/Brewfile
}

setup_ohmyzsh() {
  if [ -d $ZSH ]; then
    echo "\033[2mSkipping oh-my-zsh install, it is already installed.\033[m"
  else
    echo "👥 Install oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  if [ ! -d $ZSH_CUSTOM/themes/spaceship-prompt ]; then
    echo "🚀 Install oh-my-zsh spaceship theme"
    gh repo clone spaceship-prompt/spaceship-prompt $ZSH_CUSTOM/themes/spaceship-prompt -- --depth 1
    symlink $ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme $ZSH_CUSTOM/themes/spaceship.zsh-theme
  fi
}

setup_gh() {
  if command_exists gh; then
    echo "🔐 GitHub authentication"
    gh auth login
    gh auth status
  fi
}

# TODO: read developer directory from input
# TODO: macos defaults (including terminal theme/font/size/settings)
# TODO: mas login
main() {
  # exit immediately if a command exits with a non-zero status
  set -e

  echo "Hello $(whoami)! Let's get you set up! 🚀"
  # ask for the administrator password upfront
  sudo -v

  echo "📁 mkdir $DEVELOPER"
  mkdir -p $DEVELOPER

  setup_brew
  setup_ohmyzsh
  create_symlinks

  echo "👉 Cloning into $DOTFILES"
  # gh repo clone pemsbr/dotfiles $DOTFILES -- --depth 1

  echo "🤌 Register aliases"
  # oh-my-zsh users are encouraged to define aliases within the ZSH_CUSTOM folder.
  symlink $DOTFILES/shell/aliases.sh $ZSH_CUSTOM/aliases.zsh

  echo "📦 Install global npm packages"
  npm install --global pnpm npm-check-updates

  # refresh the current shell with the newly installed configuration.
  source $HOME/.zshrc
  
  echo "Awesome, all set. 🌈"
}

main "$@"