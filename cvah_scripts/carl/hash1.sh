#!/bin/bash
SAVE=~/Documents

if [[ "$1" == "" || "$2" == "" || "$3" == "" ]] ; then
  echo "No DATA path and/or disk and/or serial number specified"
else
  if [[ -e ${SAVE} ]] ; then
    mkdir ${SAVE}
  fi
  echo $$ > ${SAVE}/${2}_lock
  if [[ $(df -h | grep "$1" > /dev/null; echo $?) -eq 0 ]]; then
    cd ${1}
    FILE="${SAVE}/CVAH-${2}-${3}.csv"

    # Creates Headers
    echo 'Hash (md5),File' > $FILE

    # Gets any other images on root of data drive
    find -type f -exec md5sum {} + 2>/dev/null | sed 's/  /,/g' >> $FILE

    #md5sum $(find . -name \* -type f 2>/dev/null | grep -v "System Volume" | grep -v '.Trash' | grep -v '$RECYCLE.BIN' | sed -e "s/^.\///" | grep -v '^\.') | sed 's/  /,/g' >> $FILE
    echo "Finished with ${2} Serial number ${3} - File is ${FILE}" 
  fi
  rm -fr ${SAVE}/${2}_lock
fi
