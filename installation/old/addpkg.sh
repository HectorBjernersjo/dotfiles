#!/usr/bin/env bash
echo $1 >> ~/dotfiles/installation/packages.txt
sort ~/dotfiles/installation/packages.txt -u -o ~/dotfiles/installation/packages.txt
