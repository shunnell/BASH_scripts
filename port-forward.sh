#!/bin/bash

TUN_USER=shunnel

create-string () {
    L_IP=`echo ${lines[$n]} |cut -d, -f1`
    LPORT=`echo ${lines[$n]} |cut -d, -f2`
    R_IP=`echo ${lines[$n]} |cut -d, -f3`
    RPORT=`echo ${lines[$n]} |cut -d, -f4`
}

tunnel-forward () {
    ssh -f -N ${TUN_USER}@${L_IP} -R ${LPORT}:${R_IP}:${RPORT}
}

IFS=$'\n' read -d '' -r -a lines < port-data

for (( n=0; n<${#lines[@]}; n++ ))
do
    create-string
    tunnel-forward
done
