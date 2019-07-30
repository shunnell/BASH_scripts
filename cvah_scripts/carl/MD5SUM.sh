#!/bin/bash

#
################################################################################
#
#	Version 1.1	ceb	20181018
#	This  version of the MD5SUM script has the ability to not only be
#	able to start up to 25 hashes but it also can get the serial num‐
#	ber  for an external USB drive such that the serial number can be
#	part of the HASH filename output.  This allows for hte ability to
#	properly march a HASH output file to an external USB drive.
#
################################################################################
#

#
#	Set  up  directory where HASH files are stored, the default REPLY
#	from the user and what the current local  dirdectory  is  as  the
#	"hash1.sh"  file must be in the same directory where this scriupt
#	is located.
#

DISK_FILES=~/Documents
REPLY="1"
LOCAL_DIRECTORY=$(pwd)/

#
#	We  have  the  base  disk  names.   These  are used to create the
#	"/dev/sd?" disk device name  that  is  needed  to  determine  the
#	mounted  path  of  the  particulat  DATA directory.  Usually, the
#	first external USB drive will  get  the  path  "/run/media/asses‐
#	sor/Data".  The next external USB drives will get "/run/media/as‐
#	sessor/Data1" with Data1 becoming Data2, etc., for each  external
#	USB drive pluged in.  NOTE: If the path is not "/run/media/asses‐
#	sor/Data*", then the drive will not be looked at.
#

disk_names=(
	sdb2 sdc2 sdd2 sde2 sdf2 sdg2 sdh2 sdi2 sdj2 sdk2 sdl2 sdm2 sdn2
	sdo2 sdp2 sdq2 sdr2 sds2 sdt2 sdu2 sdv2 sdw2 sdx2 sdy2 sdz2
)

#
#	This houses the external USB serial number.  The serial nuber for
#	the external USB drives is usually listed as part  of  the  drive
#	is.     A    simple    example    would    be    "usb‐WD_My_Pass‐
#	port_25E2_575833314434384139535952‐0:0".   In  this   case,   the
#	"575833314434384139535952" piece is the actual serial number, but
#	each character is represented as it ASCII value  in  hexadecimal.
#	In  this  case,  when  converted back to actual ASCII charactersm
#	this would be "WX31D48A9SYR".
#

disk_serial=(
"" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ""
)

#575833314434384139535952
#	This  is the MOUNTED PATH name for the DATA partitions of the ex‐
#	ternal USB drives.  That is, using the  derived  names  from  the
#	"disk_names"  table the mounted DATA partitions can be found.  If
#	the mounted path for the external USB drive is "/run/media/asses‐
#	sor/Data*",  then  that  path  is recorded into this table at the
#	same index as the device name in the "disk_names" table above.’
#

disk_partitions=(
"" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ""
)

#
#	Simple external USB drive letter table.
#

disk_letter=(
	"b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q"
	"r" "s" "t" "u" "v" "w" "x" "f" "z"
)

#
#	The  PID of the hash1.sh script.  This is kept in order to keep a
#	second hash run against an external USB drive  while  a  hash  is
#	running.  The hash1.sh script will create a simple file that uses
#	the device name from the "disk_names" table and house the PID  of
#	the hash script that is running.
#

disk_PID=(
"" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ""
)

#
#	This  routine  takes  a external USB drive serial number, such as
#	"575833314434384139535952", and converts  it  to  "WX31D48A9SYR".
#	However,  if  the base disk name from the "disk_names" table does
#	not appear as symbolic link for the requested external USB drive,
#	then the serial number will be presented as "UNKNOWN".
#

get_serial(){
  Raw_Serial=$(ls -al /dev/disk/by-id/usb* | grep -w ${disk_names[${Count}]} | cut -d'/' -f5 | sed -e "s/-/_/g" | cut -d'_' -f6)
  if [[ ${Raw_Serial} == "" ]]; then
    echo "No such USB device - ${disk_names[${Count}]}"
    disk_serial[Count]=$(echo "UNKNONW")
  else
    for c in $(seq 1 2 23); do
      let d=${c}+1
      let i=(${c}-1)/2
      Piece[${i}]=$(echo ${Raw_Serial} | cut -c${c}-${d})
      New_Piece[${i}]=$(echo -e "\x${Piece[${i}]}")
    done
    disk_serial[Count]=$(echo ${New_Piece[0]}${New_Piece[1]}${New_Piece[2]}${New_Piece[3]}${New_Piece[4]}${New_Piece[5]}${New_Piece[6]}${New_Piece[7]}${New_Piece[8]}${New_Piece[9]}${New_Piece[10]}${New_Piece[11]})
  fi
}

#
#	This  routine  will  actually attempt  to  start the hash1 script
#	against the requested external USB drive.  First, it  must  check
#	to see if the requested external USB drive actually exists in the
#	"disk_partitions" list, then check to see if there is  already  a
#	hash running before it will start the actual hash.
#

Start_Hash(){
  if [ "${Answer}" == "" ]; then
    echo "The requested disk (${REPLAY}) not in list"
  elif [ "${disk_partitions[${Count}]}" == "" ] ; then
    echo "The requested disk (${REPLAY}) does not exist"
  elif [ "${disk_PID[${Count}]}" != "" ] ; then
    echo "HASH on disk ${disk_partition[${Count}]} is running as PID ${disk_PID[${Count}]}"
  else
    echo "Starting hash on ${disk_partitions[${Count}]} - ${disk_serial[${Count}]} - Disk:${disk_names[${Count}]}"
    ${LOCAL_DIRECTORY}hash1.sh ${disk_partitions[${Count}]} ${disk_names[${Count}]} ${disk_serial[${Count}]} &
  fi
}

#
#	Now  the  actual  meat of this script.  First, check to see if we
#	got an actual parameter from the user/cli.   If  so,  we  are  to
#	start any and  all  hashes against all known external USB drives.
#	This is done so that we can use this scrpt within a "at"  job  or
#	just  want  to start all hash automatically.  Otherwise, a simple
#	menu is shown to let the user see what external  USB  drives  are
#	available,  what  the serial numbers are, what the mounted parti‐
#	tions are for hte external USB drives and which ones are running.
#	The  user  can the select the external USB drive to start hashing
#	on.  This script does allow for additional external USB drives to
#	be  commected  as  each  time throught the hash selection loop it
#	will validate which external USB drives are currently available.
#

if [[ "${1}" != "" ]]; then
  let Count=0
  for name in ${disk_names[@]}; do
    disk_partitions[${Count}]=$(df -h | grep ${name} | awk {'print $6'} | grep Data)
    if [ "${disk_partitions[${Count}]}" != "" ]; then
      if [[ -e ${DISK_FILES}/${name}_lock ]] ; then
        disk_PID[${Count}]=$(cat ${DISK_FILES}/${name}_lock)
      else
        disk_PID[${Count}]=""
      fi
      get_serial
      Answer="${disk_letter[${Count}]}"
      Start_Hash
    fi
    let Count=Count+1
  done
  ${0}
else
  while [ "${REPLY}" != "0" ]; do
    let Count=0
    for name in ${disk_names[@]}; do
      disk_partitions[${Count}]=$(df -h | grep ${name} | awk {'print $6'} | grep Data)
      if [ "${disk_partitions[${Count}]}" != "" ]; then
        if [[ -e ${DISK_FILES}/${name}_lock ]] ; then
          disk_PID[${Count}]=$(cat ${DISK_FILES}/${name}_lock)
          Lock="RUNNING (${disk_PID[${Count}]})"
        else
          disk_PID[${Count}]=""
          Lock="NOT RUNNING"
        fi
        get_serial
        echo "${disk_letter[${Count}]}. ${disk_partitions[${Count}]} : ${disk_serial[${Count}]} - ${Lock} (${Count})"
      fi
      let Count=Count+1
    done
    echo "Which to start (0 to EXIT)"
    read REPLY
    [ ${REPLY} ] || REPLY="1"
    case ${REPLY} in
      '0')
        ;;
      *)
        let Count=0
        Answer=""
        for letter in ${disk_letter[@]} ; do
          if [ "${letter}" == "${REPLY}" ] ; then
            Answer=${REPLY}
            break
          else
            let Count=Count+1
          fi
        done
  	Start_Hash
    esac
  done
fi
