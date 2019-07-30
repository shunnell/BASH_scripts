#!/bin/bash

#
# Step 1: Update BurpSuite on a CPT MIP
# Step 2: Make sure the destination path below is where you want the tar file to go
# Step 3: Modify the variables (version #, etc.) below
# Step 4: Run this script

CPT_VER=3.2.1
BURP_VER=2.0.20  # EXAMPLE: 1.2.3
APP_DIR=/appStore/appStore_${CPT_VER}/cpt/   #EXAMPLE /data/CM/configManagement/appStore/appStore/

PREV_LOCATION=`pwd`
cd /
tar cvf BurpSuitePro_${BURP_VER}.tar /usr/share/applications/Burp\ Suite\ Professional-0.desktop /usr/local/bin/BurpSuitePro /opt/burp
gzip BurpSuitePro_${BURP_VER}.tar 
mv BurpSuitePro_${BURP_VER}.tar.gz ${APP_DIR}/burpsuitePro/.
printf "%s\n" $BURP_VER > ${APP_DIR}/burpsuitePro/version.txt
chown assessor:usaf_admin ${APP_DIR}/burpsuitePro/*
chmod 660 ${APP_DIR}/burpsuitePro/*
cd ${PREV_LOCATION}
