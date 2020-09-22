#!/bin/bash

# ACTIONS
NO_SOURCES=1
NO_DESTINATIONS=3 
SYNC_AFTER=Y          # Y or N, useful if you want to rsync after the dd
HASH=Y                # Y of N, do you want a hash after syncing?

# VARIABLES

COUNTER=0
TEAM=cpt              # cpt or mdt   MUST BE LOWERCASE!!
RELEASE=3.2           # Example: 3.2, or 3.3, or 3.2.1
SRC1=/dev/sdb
SRC2=/dev/sdd

DEST1=/dev/sdc
DEST2=/dev/sde
DEST3=/dev/sdd

# DO NOT CHANGE BELOW THIS LINE
BS=262144
DEST=(${DEST1} ${DEST2} ${DEST3})

if [ "${NO_SOURCES}" == "2" ]; then
   unset SRC2
   if [ -r ${SRC1} ]; then
      echo "dd if=${SRC1} of=${DEST1} bs=${BS}"
   else
      printf "\nProblem with ${SRC1} drive!"
      exit 6
   fi
   if [ -r ${SRC2} ]; then
      echo "dd if=${SRC2} of=${DEST2} bs=${BS}"
   else
      printf "\nProblem with ${SRC2} drive!"
      exit 6
   fi
else
   for i in "${DEST[@]}"; do
      echo "dd if=${SRC1} of=$i bs=${BS}"
      echo "umount $i[12]"
   done
fi
USB=`ls /sys/bus/pci/drivers/xhci_hcd/ |grep 0000`
echo ${USB} > /sys/bus/pci/drivers/xhci_hcd/unbind
echo Pause 5 seconds...
sleep 5
echo ${USB} > /sys/bus/pci/drivers/xhci_hcd/bind
echo Pause 5 seconds...
sleep 5

if [ "${SYNC_AFTER}" == "Y" ]; then
   if [ -r /${TEAM}/${RELEASE} ]; then
      SYNC_NOW=`df -kh |grep ${SRC1} |grep Data |cut -d% -f2`
      rsync -Lruvt --delete --force --dry-run /${TEAM}/${RELEASE}/ ${SYNC_NOW}
      for i in "${DEST[@]}"; do
         SYNC_NOW=`df -kh |grep ${i} |grep Data |cut -d% -f2`
         echo "rsync -Lruvt --delete --force --dry-run /${TEAM}/${RELEASE}/ ${SYNC_NOW}"
      done
   fi
fi
      
exit 0

if [ "${HASH}" == "Y" ]; then
fi


HASH_SRC1=`df -kh |grep ${SRC1} |grep Data |cut -d% -f2`
HASH_SRC2=`df -kh |grep ${SRC2} |grep Data |cut -d% -f2`
HASH_DEST1=`df -kh |grep ${DEST1} |grep Data |cut -d% -f2`
if [ "${NO_DESTINATIONS}" == "1" ]; then
   unset DEST2
   unset DEST3
elif [ "${NO_DESTINATIONS}" == "2" ]; then
   unset DEST3
   HASH_DEST2=`df -kh |grep ${DEST2} |grep Data |cut -d% -f2`
elif [ "${NO_DESTINATIONS}" == "3" ]; then
   HASH_DEST3=`df -kh |grep ${DEST3} |grep Data |cut -d% -f2`
fi
