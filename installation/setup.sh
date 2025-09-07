#!/usr/bin/env bash
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.ssh"
stow -d "$HOME/dotfiles" .
