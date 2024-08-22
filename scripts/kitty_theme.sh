#!/bin/bash

if [ "$1" == "tokyo-night" ]; then
    kitten themes --reload-in=all "Tokyo Night"
elif [ "$1" == "gruvbox-dark" ]; then
    kitten themes --reload-in=all "Gruvbox Dark"
fi
