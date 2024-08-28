#!/bin/bash
# Detach the mouse from the VM
virsh --connect qemu:///system detach-device win11 /home/hector/vms/mouse.xml
