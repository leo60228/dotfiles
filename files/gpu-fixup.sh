#!/bin/sh

PERF='/sys/class/drm/card0/device/power_dpm_force_performance_level'
MCLK='/sys/class/drm/card0/device/pp_dpm_mclk'
SCLK='/sys/class/drm/card0/device/pp_dpm_sclk'
echo "Waiting for AMDGPU device to initialize..."

while true; do
	if [ -w "$PERF" ]; then
		break
	fi
	sleep 1
done

echo "Device Online. Enabling GPU Powersave Workaround."
echo "manual" > "$PERF"
echo "2 3" > "$MCLK"
echo "3 4 5 6" > "$SCLK"
