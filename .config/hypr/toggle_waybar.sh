#!/usr/bin/env bash

if pgrep -x "waybar" > /dev/null
then
	killall waybar
else
	waybar
fi
