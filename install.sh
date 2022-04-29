#! /bin/bash -e

BASE=build_dir/target-powerpc_8540_uClibc/linux-mpc85xx_p1020wlan_fem
BIN=bin/targets/mpc85xx/p1020wlan_fem-uClibc
if [[ "$1" == "stable" ]]; then
	DEST_DIR="/opt/openwrt/tftproot/stage1"
else
	#Send to devel directory
	DEST_DIR="/opt/openwrt/tftproot/stage1/$1"
fi

mkdir -p "$DEST_DIR"

cp -vf $BIN/openwrt-mpc85xx-p1020wlan_fem-femap-fdt.bin ${DEST_DIR}/openwrt-mpc85xx-p1020wlan.fdt
cp -vf $BIN/openwrt-mpc85xx-p1020wlan_fem-femap-uImage ${DEST_DIR}/openwrt-mpc85xx-uImage
cp -vf $BASE/vmlinux.elf ${DEST_DIR}/openwrt-mpc85xx-vmlinux.elf
cp -vf $BASE/root.squashfs ${DEST_DIR}/openwrt-mpc85xx-root.squashfs
cp -vf $BASE/root.jffs2-64k ${DEST_DIR}/root.jffs2-64k
cp -vf $BASE/root.jffs2-128k ${DEST_DIR}/root.jffs2-128k

./staging_dir/host/bin/mkimage -A ppc -O linux -T ramdisk -C none -a 0x2d000000 -e 0x2d000000 -d $BIN/openwrt-mpc85xx-p1020wlan_fem-rootfs.cpio.xz ${DEST_DIR}/openwrt-mpc85xx-rootfs-uImage
cp -vf $BIN/openwrt-mpc85xx-p1020wlan_fem-rootfs.cpio.xz ${DEST_DIR}/openwrt-mpc85xx-rootfs-initrd

