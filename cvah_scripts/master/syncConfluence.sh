#!/bin/bash

VERSION=3.2
SOURCE_DIR=/data/CM/ConfigManagment/confluenceScrape
SYNC_DEST=/mnt

if [ -r ${SOURCE_DIR} ]; then
   printf "\nSource found..."
   rsync -Lruvt --delete --force ${SOURCE_DIR}/cpt/ ${SYNC_DEST}/cpt/${VERSION}/CVAH-CPT_Version_${VERSION}_Release/1_Documentation/THISISCVAH
   rsync -Lruvt --delete --force ${SOURCE_DIR}/mdt/ ${SYNC_DEST}/mdt/${VERSION}/CVAH-MDT_Version_${VERSION}_Release/1_Documentation/THISISCVAH
else
   printf "\nSource not mounted, or not found!"
   exit 2
fi
