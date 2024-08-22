#!/bin/bash

if [ "$1" == "tokyo-night" ]; then
    kitten themes --reload-in=all "Tokyo Night"
elif [ "$1" == "gruvbox-dark" ]; then
    kitten themes --reload-in=all "Gruvbox Dark"
elif [ "$1" == "gruvbox-light" ]; then
    kitten themes --reload-in=all "Gruvbox Dark Soft"
elif [ "$1" == "solarized-dark" ]; then
    kitten themes --reload-in=all "Solarized Dark"
fi
