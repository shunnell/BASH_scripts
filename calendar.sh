#!/bin/bash

declare -a Sunday
declare -a Monday
declare -a Tueday
declare -a Wednesday
declare -a Thursday
declare -a Friday
declare -a Saturday

file=~/development/scripts/cal-data

####################################################################
#####++ if there are only 28 days in Feb, and the 1st starts ++#####
#####++ on Sunday, then we need to account for one less row  ++#####
####################################################################
cal_length=`cal | wc -l`

if [[ $cal_length -gt 7 ]]
then
   cal |tail -7 > $file
else
   cal |tail -6 > $file
fi

i=0
IFS=''
while read "data"; do
   Sunday[$i]=`echo "$data"  |cut -b 1-2`
   Monday[$i]=`echo $data    |cut -b 4-5`
   Tueday[$i]=`echo $data    |cut -b 7-8`
   Wednesday[$i]=`echo $data |cut -b 10-11`
   Thursday[$i]=`echo $data  |cut -b 12-13`
   Friday[$i]=`echo $data    |cut -b 15-16`
   Saturday[$i]=`echo $data  |cut -b 18-19`
   echo ${Sunday[$i]}
   (( i=i+1 ))
done < $file

echo ${Sunday[2]}
