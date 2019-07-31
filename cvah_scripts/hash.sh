#!/bin/bash

COMPARE_HASHES=Y        # If you want to compare hash results at the end
SAVE=~/Documents
HASH_DIR=`date +"%F--%H.%M.%S"`
NUM_DIR=`echo $0 |sed 's/[^\/]//g' |awk '{ print length }'`
if [ ${NUM_DIR} == 1 ]; then
   CUR_PATH=`pwd`
else
   CUR_PATH=`echo $0 |cut -d/ -f-${NUM_DIR}`
fi

printf "\nExecuting...\n\n"

#sleep 15 # Just in case script is executed before system reads all external drives

if [[ ! -e ${SAVE} ]] ; then
   echo Directory Not Found...creating
   mkdir ${SAVE}
fi

mkdir ${SAVE}/${HASH_DIR}

for HASH_TARGET in `df -k |grep Data |cut -c6-8`; do
   RAW_SERIAL=`ls -la /dev/disk/by-id/usb* |grep -w ${HASH_TARGET} \
      |cut -d'/' -f5 |sed -e "s/-/_/g" |cut -d'_' -f6`
   for c in `seq 1 2 23`; do
      let d=${c}+1
      let i=(${c}-1)/2
      OLD[${i}]=$(echo ${RAW_SERIAL} | cut -c${c}-${d})
      NEW[${i}]=$(echo -e "\x${OLD[${i}]}")
   done
   DISK_SER=`echo ${NEW[*]}`
   HASH_PATH=`df -k |grep ${HASH_TARGET}2 |cut -d'%' -f2`
   cd ${HASH_PATH}
   FILE=${SAVE}/${HASH_DIR}/`ls |grep CVAH |sed -e 's/-/_/g' \
      |cut -d'_' -f2,4`_`echo ${DISK_SER} |sed -e 's/ //g'`.csv
   FILE_ERROR=${SAVE}/${HASH_DIR}/`ls |grep CVAH |sed -e 's/-/_/g' \
      |cut -d'_' -f2,4`_`echo ${DISK_SER} |sed -e 's/ //g'`.error
   ${CUR_PATH}/hashBack.sh ${HASH_PATH} ${FILE} ${FILE_ERROR} &
done

if [[ "${COMPARE_HASHES}" == "Y" ]]; then
   cd ${SAVE}/${HASH_DIR}
   while [[ `ls |grep LOCK` ]]; do     # Wait until all the hashing is complete for compares
      sleep 10
   done   
   cd ${SAVE}/${HASH_DIR}
   for LIST in `ls`; do
      if [[ "${FLAG}" == "Y" ]]; then
         NEXT_HASH=${LIST}
         if [[ "`diff -q ${FIRST_HASH} ${NEXT_HASH}`" == "" ]]; then
            echo "${FIRST_HASH} ${NEXT_HASH} are identical"
         else
            echo "${FIRST_HASH} ${NEXT_HASH} do not match!!!"
         fi
      else
         FIRST_HASH=${LIST}
         FLAG=Y
      fi
   done
fi


