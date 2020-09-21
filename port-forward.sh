#!/bin/bash

tunnel_user=shunnel

tunnel-forward () {
   ssh -f -N ${tunnel_user}@${local_ip} -R ${local_port}:${remote_ip}:${remote_port}
}

file=~/development/scripts/port-data
IFS=','

while read -r local_ip local_port remote_ip remote_port
do
   tunnel-forward
done < "$file"

