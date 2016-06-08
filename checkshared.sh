#!/bin/sh

cd root
find -type f | xargs file | grep ELF.*dyn | cut -f1 -d: | while read i; do
   echo $i
   ldd $i
   echo
done
