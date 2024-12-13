#!/bin/bash

# Runs the ip addr command to retrive the current system's IP Configuration
# Output is piped to grep to filter results that contain both an IPv4 Address and Broadcast Address
ip_result=$(ip a | grep "brd" | grep "inet")

filtered_ip=$(echo $ip_result | cut -d ' ' -f 2 | cut -d '/' -f 1)

echo $filtered_ip
