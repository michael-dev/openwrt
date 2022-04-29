#!/bin/bash

set -e

function sign() {
	echo "signing $(pwd)"
	for i in openwrt-mpc85xx-vmlinux.elf openwrt-mpc85xx-rootfs-initrd; do
  		[ -f $i.gpg ] && rm $i.gpg
		gpg --sign $i
	done
}

if [[ "$1" == "stable" ]]; then
  cd /opt/openwrt/tftproot/stage1
elif [[ -n "$1" ]]; then
  cd "/opt/openwrt/tftproot/stage1/$1"
fi

sign

