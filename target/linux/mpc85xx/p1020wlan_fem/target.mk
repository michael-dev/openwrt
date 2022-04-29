BOARDNAME:=P1020WLAN-FEM

DEFAULT_PACKAGES += \
-  kmod-booke-wdt spi-bitbang rtc-core-3.x usb-serial-ftdi

define Target/Description
	Build firmware images for Freescale P1020-WLAN based boards using FeM settings.
endef

