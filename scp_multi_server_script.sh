#!/bin/bash

# scp_multi_server_script
# Created by Michael Purcell
# Version 1.0
# March 16, 2020
# Purpose: Enter IP addresses to send a file to multple servers.


IP_ARRAY=()

echo -e "\nThis script will send a file to multiple IP addresses via SCP.\nThe file will be placed in the destination's /tmp/ directory\n"

while read -rp "Please enter a server IP or type \"Done\" when all server IPs have been entered: " SERVER_IP; do
     if [ $SERVER_IP = "Done" ]; then
     break
     fi

     if /bin/ipcalc -c $SERVER_IP; then
        if /bin/ping -w 10 -c 1 $SERVER_IP > /dev/null 2>&1; then
          IP_ARRAY+=($SERVER_IP)
        else echo -e "\nUnable to reach $SERVER_IP.  Please try again.\n"
        fi
      else echo -e "\nNot a valid IP address.\n"
      fi
done

read -rp "What is the full path to the file you want to transfer?  Example: /tmp/example_filename : " FILE_SOURCE
  while [ ! -f "$FILE_SOURCE" ]; do
  read -p "File not found!  Please enter the full path to the file again: " FILE_SOURCE
  done

for ITEM in "${IP_ARRAY[@]}"; do
     /usr/bin/scp $FILE_SOURCE idirect@$ITEM:/tmp/
done
