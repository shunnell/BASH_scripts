#!/bin/bash

COUNTER=1

#TODO Determine for sure what is the source, so that the reverse of what is expected doesn't happen
   for SYNC_SRC in $(df -kh |grep dev |grep Data |cut -d% -f2); do
      for SYNC_DEST in $(df -kh |grep dev |grep Data |cut -d% -f2); do
         if [ ${COUNTER} -gt 1 ]; then
            rsync -Lruvt --delete --force ${NEXT_SOURCE}/ ${SYNC_DEST}
         fi
         NEXT_SOURCE=${SYNC_DEST}
         let "COUNTER=COUNTER+1"
      done
      break
   done
   #printf "\nSource not mounted, or not found!"

