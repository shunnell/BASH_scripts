#!/bin/bash

VERSION=3.2
SOURCE_DIR=/mdt/${VERSION}/
COUNTER=1

if [ -r ${SOURCE_DIR}${RELEASE} ]; then
   printf "\nSource found..."
   for SYNC_DEST in $(df -kh |grep dev |grep Data |cut -d% -f2); do
      if [ ${COUNTER} -eq 1 ]; then
        rsync -Lruvt --delete --force ${SOURCE_DIR} ${SYNC_DEST}
      else
        rsync -Lruvt --delete --force ${NEXT_SOURCE}/ ${SYNC_DEST}
      fi
      NEXT_SOURCE=${SYNC_DEST}
      let "COUNTER=COUNTER+1"
   done
else
   printf "\nSource not mounted, or not found!"
   exit 6
fi

