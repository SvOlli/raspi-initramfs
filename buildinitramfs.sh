#!/bin/sh

cpioroot="root"
baseroot="base"
bootdir="$(ls -1d /media/*/INITRAMFS)"

set -e

if [ -z "${FAKEROOTKEY}" ]; then
   echo "*** restarting using fakeroot"
   exec fakeroot "$0" "$@"
fi

followlinks()
{
   d="$(dirname "${1}")"
   f="$(basename "${1}")"
   case "${d}" in
   /*) ;;
   .) d="${PWD}" ;;
   *) d="${PWD}/${d}" ;;
   esac
   echo "${d}/${f}"
   cd "${d}"
   if [ -h "${d}/${f}" ]; then
      followlinks "$(readlink "${d}/${f}")"
   fi
}

getlibs()
{
   f="${1}"
   if [ "${f}" = "busybox" -a -x "src/busybox/busybox" ]; then
      f=
   fi
   echo "${f}"
   file "${f}" | grep -q dynamically || return
   ldd "${f}" | tr ' ' '\n' | tr -d '\t' | grep ^/ | while read lib; do
      case "${lib}" in
      */libfakeroot/*) ;; # fakeroot adds a shared library we don't need
      *) followlinks "${lib}" ;;
      esac
   done
}

copy_to_target()
{
   local src="${1}"
   if [ -d "${src}" ]; then
      echo "*** processing directory ${src}"
      case "${src}" in
      /*) tar -cf - -C / "${src}" | tar -xvvf - -C "${cpioroot}" ;;
      *) tar -cf - -C "${src}" . --exclude='README*' |
         tar -xvvf - -C "${cpioroot}" ;;
      esac
   elif [ -f "${src}" ]; then
      echo "*** processing filelist ${src}"
     tar -cf - -C / -T "${src}" | tar -xvvf - -C "${cpioroot}"
   else
      echo "*** ERROR ${src} is not a directory an not a file"
      exit 1;
   fi
}

# step 0: get busybox
if [ ! -x "${baseroot}/bin/busybox" ]; then
   make -C src install
fi

# step 1: copy stuff

rm -rf "${cpioroot}"
mkdir -p "${cpioroot}/dev" "${cpioroot}/bin"
mknod "${cpioroot}/dev/null" c 1 3

copy_to_target "${baseroot}"
for arg; do
   copy_to_target "${arg}"
done
#tar -cf - -C "${baseroot}" . | tar -xvf - -C "${cpioroot}"
#for i; do
#   if [ -d "${i}" ]; then
#     tar -cf - -C "${i}" . | tar -xvf - -C "${cpioroot}"
#   fi
#   if [ -f "${i}" ]; then
#     tar -cf - -T "${i}" | tar -xvf - -C "${cpioroot}"
#   fi
#done

# step 2: locate and copy missing libraries

rm -f filelist.tmp
elfsrc="$(find "${cpioroot}" -type f | xargs file | grep 'ELF.*dynamically' | cut -f1 -d:)"
for elf in ${elfsrc}; do
   getlibs "${elf}" | tail -n +2 >>filelist.tmp
done
sort -u filelist.tmp |sed 's,^/,./,' > filelist.full
#tar -cf - -T filelist.full | tar -xvf - -C "${cpioroot}"
copy_to_target filelist.full
rm -f filelist.full filelist.tmp

# step 3: create initramfs
cd "${cpioroot}"; find .|cpio -H newc -o >../initrd;cd -
ls -l initrd
if [ -d "${bootdir}" ]; then
   gzip -9v <initrd >"${bootdir}/initrd.gz"
fi
ls -l "${bootdir}/initrd.gz"

