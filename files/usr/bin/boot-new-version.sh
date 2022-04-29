#! /bin/sh -e
cd /tmp

atftp -g -r stage2/openwrt-mpc85xx-vmlinux.elf -l openwrt-mpc85xx-vmlinux.elf 10.26.254.16
atftp -g -r stage2/openwrt-mpc85xx-rootfs-initrd -l openwrt-mpc85xx-rootfs-initrd 10.26.254.16
kexec -u || true
/etc/init.d/network stop
for i in $(lsmod | awk '{print $1}' | grep -v booke_wdt); do rmmod $i; done
kexec -l openwrt-mpc85xx-vmlinux.elf --append "$(cat /proc/cmdline)" --initrd openwrt-mpc85xx-rootfs-initrd
kexec -e

