#!/bin/bash

if pgrep -x "wlsunset" > /dev/null
then
	killall wlsunset
else
	wlsunset -t 0000 -T 3000
fi
