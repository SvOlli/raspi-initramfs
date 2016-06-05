#!/bin/sh

mount LABEL=INITRAMFS /mnt
cp /var/log/bootlog.tgz /mnt
ls -l /mnt/bootlog.tgz
umount /mnt
