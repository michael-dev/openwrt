BOARDNAME:=P1020WLAN-FEM

FEATURES += squashfs nand rtc jffs2 spe_fpu

# NAND_BLOCKSIZE is page size : block size
# FIXME page size unknown, see https://www.micron.com/support/~/media/74C3F8B1250D4935898DB7FE79EB56E7.ashx
# NAND_BLOCKSIZE := 2048-128k
# FEATURES += jffs2_nand

DEFAULT_PACKAGES += \
-  kmod-booke-wdt spi-bitbang rtc-core-3.x usb-serial-ftdi kmod-i2c-mpc

define Target/Description
	Build firmware images for Freescale P1020-WLAN based boards using FeM settings.
endef

