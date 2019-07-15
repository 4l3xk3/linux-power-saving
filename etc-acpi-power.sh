#!/bin/bash

# AstraLinux SE 1.6, AstraLinux CE 2.12, Ubuntu 18.04, power saving script 
# put it instead /etc/acpi/power.sh
# add intel_pstate=disable to GRUB_CMDLINE_LINUX_DEFAULT in /etc/default/grub and run update-grub command
# =======================================================================================================
# Author: Alexey Kovin <4l3xk3@gmail.com>
# All rights reserved
# Russia, Electrostal, 2019

if `cat /sys/class/power_supply/A*/online | grep -q 1`; 
then
    echo "AC"
    for cpudir in /sys/devices/system/cpu/cpu[0-9]*
    do
	echo ${cpudir}
	cat ${cpudir}/cpufreq/scaling_available_governors
	cat ${cpudir}/cpufreq/scaling_governor
	if grep -q "ondemand" ${cpudir}/cpufreq/scaling_available_governors
	then 
	    echo "ondemand" > ${cpudir}/cpufreq/scaling_governor
	else
	    echo "performance" > ${cpudir}/cpufreq/scaling_governor
	fi
	cat ${cpudir}/cpufreq/scaling_governor
    done
    echo "BRIGHTNESS"
    for brdir in /sys/class/backlight/*
    do
	echo $brdir
	maxbr=`cat ${brdir}/max_brightness`
	echo $maxbr
	echo $maxbr > ${brdir}/brightness
    done
else 
    echo "BATTERY"
    for cpudir in /sys/devices/system/cpu/cpu[0-9]*
    do
	echo ${cpudir}
	cat ${cpudir}/cpufreq/scaling_available_governors
	echo "old:"
	cat ${cpudir}/cpufreq/scaling_governor
	echo "powersave" > ${cpudir}/cpufreq/scaling_governor
	echo "new:"
	cat ${cpudir}/cpufreq/scaling_governor
    done
    echo "BRIGHTNESS"
    for brdir in /sys/class/backlight/*
    do
	echo $brdir
	maxbr=`cat ${brdir}/max_brightness`
	echo $maxbr
	newbr=`echo $maxbr*0.7 | bc | cut -f 1 -d "."`
	echo $newbr > ${brdir}/brightness
    done
fi
