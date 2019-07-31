#!/bin/bash

HASH_PATH=${1}
FILE=${2}
FILE_ERROR=${3}

printf "\nHashing ${HASH_PATH}...\n\n"

cd ${HASH_PATH}
touch ${FILE}_LOCK
echo 'Hash (md5),File' > ${FILE}
find . -name \* -type f -not -path "./System Volume Information/*" \
                        -not -path './.Trash/*' \
                        -not -path './$RECYCLE.BIN/*' \
                        -exec md5sum {} \; 3>&1 1>&2 2>&3 1>> ${FILE} |tee -a ${FILE}
sed -i 's/  /,/g' ${FILE}
sleep 2
rm -f ${FILE}_LOCK


if grep "Input/output error" ${FILE}; then
   printf "\n${HASH_PATH} has Input/output error(s) in ${FILE}\n" 
else
   printf "\nHash results of ${HASH_PATH} located at ${FILE}\n"
fi

