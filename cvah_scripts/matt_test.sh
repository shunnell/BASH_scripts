#!/bin/bash

read -p "What Drive? (sdd or sde): " DRIVE
read -p "What is the Release Candidate Number? " RC


HASH_FILE=/mnt/hashes/"$VER"-"$VAR"-RC"$RC"-hash.txt-test
VAL_FILE=/mnt/hashes/"$VER"-"$VAR"-RC"$RC"-Validation-hash.txt-test
DATE=$(date +%m-%d-%y:%H:%M)
DIR=/mnt/"$VAR"/"$VER"/
SLACK="/usr/local/sbin/slack.sh > /dev/null"


until [[ "$DRIVE" == +(sdd|sde) ]]; do
    unset $DRIVE
    lsblk
    echo
    read -p "sdd or sde not set, which is the target drive? " DRIVE
done

echo $DRIVE
