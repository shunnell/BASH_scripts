#!/bin/bash

tunnel () {
    ssh -f -N ${LOCALUSER}@${LOCAL-IP} -R ${LOCAL-PORT}:${REMOTE_IP}:${REMOTE_PORT}
}

tunnel h -f -N ${LOCALUSER}@localhost -R 8080:192.168.2.152:8080 
ssh -f -N shunnel@localhost -R 8090:192.168.2.152:8090
ssh -f -N shunnel@localhost -R 8095:192.168.2.152:8095
ssh -f -N shunnel@localhost -R 8081:192.168.2.155:8081
ssh -f -N shunnel@localhost -R 7990:192.168.17.4:7990
ssh -f -N shunnel@localhost -R 8085:192.168.17.2:8085
