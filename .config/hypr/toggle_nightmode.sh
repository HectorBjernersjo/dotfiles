#!/usr/bin/env bash

if pgrep -x "wlsunset" > /dev/null
then
	killall wlsunset
else
	wlsunset -t 3000 -T 8000
fi
