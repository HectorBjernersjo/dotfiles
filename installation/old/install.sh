#!/usr/bin/env bash

# Install script for everything
user=$(whoami)
current=$(pwd)

# Install yay for aur
git clone https://aur.archlinux.org/yay.git $HOME/yay
cd $HOME/yay && makepkg -si
# cd $HOME/dotfiles

# Install aur packages
$current/install_yay.sh $current/packages.txt

$current/tmux-setup.sh
$current/git-setup.sh

# Set up autologin
sudo cp $current/autologin.conf  /etc/systemd/system/getty@tty1.service.d/override.conf

# Set config files
stow $HOME/dotfiles
