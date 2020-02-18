#!/bin/sh
set -x
echo "manual" > /sys/class/drm/card0/device/power_dpm_force_performance_level
echo "2 3" > /sys/class/drm/card0/device/pp_dpm_mclk
echo "3 4 5 6" > /sys/class/drm/card0/device/pp_dpm_sclk
