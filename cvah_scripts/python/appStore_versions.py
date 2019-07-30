#!/usr/bin/python3

APP_DIR = str(/cm/AppStore/appStore_3.2.1)
PREV_APP_DIR = str(/cm/AppStore/appStore_3.2)
TEAMS = ["cpt", "mdt"]

for TEAM in range(len(TEAMS)):
   print "Application, Version" > ${APP_DIR}/${TEAM}AppStoreListing.txt
   print "Application, Version, Old Version" > ${APP_DIR}/${TEAM}AppStoreListingChangeLog.txt

   cd ${APP_DIR}/${TEAM}
   for LIST in `ls`; do
      if [ -d "${LIST}" ]; then
         cd ${LIST}
         if [ -f version.txt ]; then
            sed -i "s/\r//g" version.txt
         else
            echo "${LIST} version file not found...creating it with N/A"
            printf "N/A\n" > version.txt
         fi
         if [ -f releaseNotes.txt ]; then
            sed -i "s/\r//g" releaseNotes.txt
         else
            echo ${LIST} releaseNotes not found...creating.
            touch releaseNotes.txt
         fi
         VERSION=`head -1 version.txt`
         cd ..
         echo "${LIST}, ${VERSION}" >> ../${TEAM}AppStoreListing.txt
         sed -i "s/\r//g" ${PREV_APP_DIR}/${TEAM}/${LIST}/version.txt
         OLD_VERSION=`head -1 ${PREV_APP_DIR}/${TEAM}/${LIST}/version.txt`
         if [ "${VERSION}" != "${OLD_VERSION}" ]; then
            echo "${LIST}, ${VERSION}, ${OLD_VERSION}" >> ../${TEAM}AppStoreListingChangeLog.txt
         fi
      fi
   done
done

