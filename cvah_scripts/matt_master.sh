#!/bin/bash

#Root Check
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

read -p "What Version of the system? (3.X): " VER
read -p "What Variation of the system? (cpt or mdt): " VAR
read -p "What is the Release Candidate Number? " RC
read -p "What Drive? (sdd or sde): " DRIVE


HASH_FILE=/mnt/hashes/"$VAR"-"$VER"-RC"$RC"-hash.txt-test
VAL_FILE=/mnt/hashes/"$VAR"-"$VER"-RC"$RC"-Validation-hash.txt-test
DATE=$(date +%m-%d-%y:%H:%M)
DIR=/mnt/"$VAR"/"$VER"/
SLACK="/usr/local/sbin/slack.sh"

$SLACK "Starting the process of  makeing the "$VAR"-"$VER" Drive."

until [[ "$DRIVE" == +(sdd|sde) ]]; do
    unset $DRIVE
    lsblk
    echo
    read -p "sdd or sde not set, which is the target drive? " DRIVE 
done

unset $TMP_DIR
TMP_DIR=/mnt/"$VAR"-"$VER"-tmp
if [[ $(lsblk | grep $TMP_DIR > /dev/null ; echo $?) -eq 0 ]]; then
    $SLACK "Drive Mounted, Unmounting"
    umount $TMP_DIR
fi



#Format the drive
$SLACK "Formating the drive"
(
echo o # Create a new empty DOS partition table
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo 2048  # First sector (Accept default: 1)
echo 61722623  # Last sector (Accept default: varies)
echo n # Add a new partition
echo p # Primary partition
echo 2 # Make it 2nd Parition
echo   # Accept default 1st sector
echo   # Accept default last sector
echo w # Write changes
) | fdisk /dev/"$DRIVE" > /dev/null

#Reload parition table
#partprobe
$SLACK "Simulating Unpluging and Re-pluging in the drive"
USB=$(ls /sys/bus/pci/drivers/xhci_hcd/ |grep 0000)
echo ${USB} > /sys/bus/pci/drivers/xhci_hcd/unbind
sleep 5s
echo ${USB} > /sys/bus/pci/drivers/xhci_hcd/bind
sleep 5s


#This is starting the restor of the MULTIBOOT PARTITION
$SLACK "Copying the Multiboot Image, This takes roughly 45 Minutes."
dd if=/mnt/drive.img | pv -s 29G | sudo dd of=/dev/"$DRIVE"1
$SLACK "Creating 2nd partition"
mkfs.xfs -f /dev/"$DRIVE"2

#This will create the archive of the last drive hash.
if [[ -e $HASH_FILE ]]; then
    echo "File exists, making backup with timestamp of $DATE"
    mv "$HASH_FILE" "$HASH_FILE"-"$DATE"
fi

#Directory Check based on variables
if [[ ! -d $DIR ]]; then
    echo "$DIR is not a directory, exiting"
    exit 1
fi

#Running the hash master drive
pushd $DIR
COUNT=$(find . -type f | wc -l)
COUNTER=0
#read -n 1 -s -r -p "Press any key to continue"

$SLACK "Generating md5 for master located at: $HASH_FILE"
#clear
find . -type f | sed 's/[^a-zA-Z0-9]/\\&/g' | while read X; do 
    md5sum "${X}" >> $HASH_FILE
    COUNTER=$(expr $COUNTER + 1)
    if ! (( $COUNTER %50 )) ; then
        echo "Progress: $COUNTER of $COUNT"
    fi
done
popd

#This block mounts the 2nd partition.
if [[ ! -d $TMP_DIR ]]; then
    mkdir "$TMP_DIR"
fi

if [[ $(lsblk | grep "$TMP_DIR"2 > /dev/null; echo $?) -eq 1 ]]; then
    mount /dev/"$DRIVE"2 "$TMP_DIR"
    $SLACK "Mounting \"$DRIVE\" at \"$TMP_DIR\""
else
    $SLACK "\"$DRIVE\" is already mounted at \"$TMP_DIR\"" 
fi

#Syncing Master to new drive
$SLACK "Syncing Master to New Drive"
pushd "$TMP_DIR"
rsync --progress -Lruvth --delete --force "$DIR" .

#Validate new Drive.
$SLACK "Starting the Validation of Synced Drive"
md5sum -c $HASH_FILE | tee -a "$VAL_FILE"
popd


#Sets STATUS based on MD5 comparisons of Master/New Drive
MASTER_MD5=$(wc -l $HASH_FILE)
SYNCED_MD5=$(grep OK $VAL_FILE | wc -l | awk '{print $1}')

if [[ "$MASTER_MD5" == "$SYNCED_MD5" ]]; then
    if [[ $(grep FAILED $VAL_FILE > /dev/null ; echo $?) = 1 ]]; then
        STATUS="Synced drive Hashed and validated"
    else
	STATUS="Synced drive failed validation"
    fi
else
    STATUS="Synced Failed"
fi

#Unmount and remove drive.
umount "$TMP_DIR"
rmdir "$TMP_DIR"

$SLACK "$STATUS"

#Unmount drive once Script is completed
if [[ $(lsblk | grep $TMP_DIR > /dev/null ; echo $?) -eq 0 ]]; then
    $SLACK "Drive Mounted, Unmounting"
    umount $TMP_DIR
fi
