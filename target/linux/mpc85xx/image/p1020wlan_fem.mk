define Device/femap
  DEVICE_TITLE := FeM P1020 WLAN AP
  DEVICE_PACKAGES := 
  DEVICE_DTS := p1020wlan
  BLOCKSIZE := 128k
  KERNEL := kernel-bin | gzip | uImage gzip
  #KERNEL_INITRAMFS := copy-file $(KDIR)/vmlinux-initramfs | uImage none
  KERNEL_INSTALL := 1
  KERNEL_SUFFIX := -uImage
  SUPPORTED_DEVICES := femap
  ARTIFACTS := fdt.bin
  ARTIFACT/fdt.bin := append-dtb
endef
TARGET_DEVICES += femap

