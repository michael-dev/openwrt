#!/bin/bash 

if [[ "$1" == "stable" ]]; then
  SRC_DIR="/opt/openwrt/tftproot/stage1"
  DEST_DIR_SUFFIX="stage1"
elif [[ -n "$1" ]]; then
  SRC_DIR="/opt/openwrt/tftproot/stage1/$1"
  DEST_DIR_SUFFIX="stage1/$1"
else
  echo "usage: $0 [stable|devel]"
  exit 1
fi

DEST=("femwlan@wlancontroller-fallback:/var/www/" "femwlan@ray-controller:/var/www/tftproot/")

for d in "${DEST[@]}"; do
    echo "copy to $d$DEST_DIR_SUFFIX"
    scp -r -P 22 ${SRC_DIR} "$d$(dirname $DEST_DIR_SUFFIX)/"
done

cd $SRC_DIR && git add . && git commit -a -m 'automatic commit before scp'

