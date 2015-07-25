#!/bin/bash
declare -i brightness=`cat /sys/class/backlight/intel_backlight/brightness`
echo $brightness
brightness=$((brightness + 100))
echo $brightness
sudo su -c "echo $brightness > /sys/class/backlight/intel_backlight/brightness"
