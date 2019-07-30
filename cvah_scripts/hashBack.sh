#!/bin/bash

HASH_PATH=${1}
FILE=${2}

cd ${HASH_PATH}
touch ${FILE}_LOCK
echo 'Hash (md5),File' > ${FILE}
find . -name \* -type f -not -path "./System Volume Information/*" \
                        -not -path './.Trash/*' \
                        -not -path './$RECYCLE.BIN/*' \
                        -exec md5sum {} \; >> ${FILE}
sed -i 's/  /,/g' ${FILE}
sleep 2
rm -f ${FILE}_LOCK
