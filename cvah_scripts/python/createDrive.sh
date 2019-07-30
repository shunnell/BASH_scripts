#!/bin/bash

BS=262144
SOURCE_DIR=/data/CM/MULTIBOOT/
SOURCE_BOOT=${SOURCE_DIR}`ls -t ${SOURCE_DIR} |head -1`

DEST_DRIVE=/`ls -lart /dev/sd* |tail -1 |cut -d/ -f2,3 |cut -c -7`
                                         # CAUTION: If you're actively using an 
                                         # external drive...this might pick that up
if [ -r ${SOURCE_BOOT} ]; then
   dd if=${SOURCE_BOOT} of=${DEST_DRIVE} bs=${BS}
else
   printf "\nSource not mounted, or not found!\n"
   exit 1
fi

sleep 5   
umount /dev/sd[bcde][12]
sleep 5
USB=`ls /sys/bus/pci/drivers/xhci_hcd/ |grep 0000`
echo ${USB} > /sys/bus/pci/drivers/xhci_hcd/unbind
sleep 10
echo ${USB} > /sys/bus/pci/drivers/xhci_hcd/bind
sleep 5

df -kh |grep dev|grep sd
