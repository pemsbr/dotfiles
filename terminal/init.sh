#!/usr/bin/env bash

# register aliases as custom oh-my-zsh plugins (automatically sourced)
echo "register aliases"
for alias in "$DOTFILES/terminal/aliases/"*; do
    filename = $(basename -- $alias .sh) # filename without extension
    mkdir -p $ZSH_CUSTOM/plugins/$filename
    ln -s "$alias" "$ZSH_CUSTOM/$filename/$filename.plugin.zsh" # convention
done
