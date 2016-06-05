#!/bin/sh

magicfile="$(ls -1 /sys/module/bcm270?/parameters/reboot_part)"
bootpart="${1}"

if [ -z "${bootpart}" ]; then
   echo "usage: $0 <partitionnumber>"
   exit 0
fi
echo "${bootpart}" > "${magicfile}"

reboot
