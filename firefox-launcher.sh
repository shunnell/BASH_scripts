#!/bin/bash

# Forward local ports as appropriate
ssh -f -N shunnel@localhost -R 8080:192.168.2.152:8080 
ssh -f -N shunnel@localhost -R 8090:192.168.2.152:8090
ssh -f -N shunnel@localhost -R 8095:192.168.2.152:8095
ssh -f -N shunnel@localhost -R 8081:192.168.2.155:8081
ssh -f -N shunnel@localhost -R 7990:192.168.17.4:7990
ssh -f -N shunnel@localhost -R 8085:192.168.17.2:8085

# Launch Firefox with Jira, Confluence, and BitBucket
/bin/firefox -url  "http://localhost:8080" -url "http://localhost:8090" -url "http://localhost:7990" &

# Exit the program
exit
