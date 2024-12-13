#!/bin/bash

# Script used to obtain a list of IOCs from a given web page, then saves the list to the "IOC.txt" file

# Retrieving IOC data website
link="10.0.17.6/IOC.html"
fullPage=$(curl -sL "$link")

# Scraping acquired IOC Pattern data, and formatting output results
outputResult=$(echo "$fullPage" | xmlstarlet format --html --recover 2>/dev/null | \
xmlstarlet sel -t -v "//html//body//table" 2>/dev/null | sed 's/&#13;//g' | awk '(NF>0){print $1}' | \
awk '{ if (NR%2 == 1) {line = $0} else { print line " " $0 } }' | cut -d' ' -f1 | tail -n +2)

# Output results to file
echo "$outputResult" > ./IOC.txt
