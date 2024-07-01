#!/bin/bash

# Install script for everything
user=$(whoami)
current=$(pwd)

# Install yay for aur
git clone https://aur.archlinux.org/yay.git $HOME/yay
cd $HOME/yay && makepkg -si
# cd $HOME/dotfiles

# Install pacman packages
$current/install_pacman.sh $current/pacman_packages.txt

# Install aur packages
$current/install_yay.sh $current/yay_packages.txt

$current/tmux-setup.sh

# Set config files
stow $HOME/dotfiles
