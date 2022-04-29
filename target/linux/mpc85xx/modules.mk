#
# Copyright (C) 2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define KernelPackage/booke-wdt
  SUBMENU:=$(OTHER_MENU)
  TITLE:=PowerPC Book-E Watchdog Timer
  DEPENDS:=@TARGET_mpc85xx
  KCONFIG:=CONFIG_BOOKE_WDT
  FILES:=$(LINUX_DIR)/drivers/$(WATCHDOG_DIR)/booke_wdt.ko
  AUTOLOAD:=$(call AutoLoad,50,booke_wdt)
endef

define KernelPackage/booke-wdt/description
  Kernel module for PowerPC Book-E Watchdog Timer.
endef

$(eval $(call KernelPackage,booke-wdt))