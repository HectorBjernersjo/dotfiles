#!/usr/bin/env bash

virt-manager --connect qemu:///system --show-domain-console win11 &

# Wait for virt-manager to start
while ! hyprctl clients | grep win11; do
  sleep 0.1
done

hyprctl dispatch setfloating title:win11
sleep 0.1
hyprctl dispatch settiled title:win11
# virt-viewer -c qemu:///system --attach win11
# xfreerdp3 -grab-keyboard /v:192.168.122.148 /u:hector /p:FilipSnygg /size:100% /d: /dynamic-resolution
