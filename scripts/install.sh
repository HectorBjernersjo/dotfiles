#!/bin/bash

# Install script for everything
user=$(whoami)

# Install yay for aur
git clone https://aur.archlinux.org/yay.git $HOME/yay
cd $HOME/yay && makepkg -si

# Install pacman packages
./install_pacman.sh pacman_packages.txt

# Install aur packages
./install_yay.sh yay_packages.txt

./tmux-setup.sh

# Set config files
stow $HOME/dotfiles
