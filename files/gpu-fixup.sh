#!/bin/sh
set -x
echo 's 0 1201 875' >  /sys/class/drm/card0/device/pp_od_clk_voltage
echo 'c' >  /sys/class/drm/card0/device/pp_od_clk_voltage
echo manual > /sys/class/drm/card0/device/power_dpm_force_performance_level
echo '1 2 3' >  /sys/class/drm/card0/device/pp_dpm_mclk
