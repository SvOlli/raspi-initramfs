#!/bin/sh

magicfile="$(ls -1 /sys/module/bcm270?/parameters/reboot_part)"
bootpart="${1}"

if [ -z "${bootpart}" ]; then
   echo "usage: $0 <partitionnumber>"
   echo suggested are: $(blkid|grep '/dev/mmcblk0p.*TYPE="vfat"'|cut -f1 -d:|sed 's,/dev/mmcblk0p,,'|sort -n)
   exit 0
fi
echo "${bootpart}" > "${magicfile}"

reboot
