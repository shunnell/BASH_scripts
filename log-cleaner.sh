#!/bin/bash

# This will clean up a log file

# Put the maximum size you want the log file to be.  If you want 10M, put
# Default size is 10M, as listed in the following line:
# MAXSIZE=10485760

MAXSIZE=10485760

# Enter the location and filename of the log file here:

LOCATION=~/development/practice/logs
FILENAME=logfile

# The following variable is the total number of backup files you want to keep

MAXNUMBACKUPFILES=9

cd ${LOCATION}
LOGSIZE=`du -b ${FILENAME} |awk '{print $1}'`
FILECOUNT=`ls |grep ${FILENAME} |wc -l`

if [[ ${FILECOUNT} < ${MAXNUMBACKUPFILES} ]]; then
    MAXNUMBACKUPFILES=$((FILECOUNT + 1))
fi
((MAXNUMBACKUPFILES-=1))

if [[ ${LOGSIZE} -ge ${MAXSIZE} ]]; then
    for (( COUNTER=${MAXNUMBACKUPFILES}; COUNTER>1; COUNTER-=1 )); do
        mv ${FILENAME}${COUNTER} ${FILENAME}$((COUNTER + 1))
    done
    mv ${FILENAME} ${FILENAME}2
fi
        

    
