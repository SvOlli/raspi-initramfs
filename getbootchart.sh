#!/bin/sh

set -e
bootchart /media/pi/INITRAMFS/bootlog.tgz
epiphany bootlog.png
