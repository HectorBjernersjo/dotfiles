#!/usr/bin/env bash

if pgrep -x "wlsunset" > /dev/null
then
	killall wlsunset
else
	wlsunset -t 4000 -T 4001
fi
