#!/bin/bash
# Detach the mouse from the VM
sleep 2
virsh --connect qemu:///system attach-device win11 /home/hector/vms/mouse.xml
