#!/bin/bash

# Retrieve content from class website to be scraped
link="10.0.17.6/Assignment.html"
webPage=$(curl -sL "$link")

# Scrapes temp table data
tempOutput=$(echo "$webPage" | xmlstarlet format --html --recover 2>/dev/null | \
xmlstarlet sel -t -v "//html//body//table[@id='"temp"']" 2>/dev/null | sed 's/&#13;//g' | awk '(NF>0){print $1}' | \
awk '{ if (NR%2 == 1) {line = $0} else { print line " " $0 } }' | tail -n +2 )

# Scrapes pressure table data
pressOutput=$(echo "$webPage" | xmlstarlet format --html --recover 2>/dev/null | \
xmlstarlet sel -t -v "//html//body//table[@id='"press"']" 2>/dev/null | sed 's/&#13;//g' | awk '(NF>0){print $1}' | \
awk '{ if (NR%2 == 1) {line = $0} else { print line " " $0 } }' | cut -d' ' -f1 | tail -n +2)

# Set counter for press output
counter=1

# Output combined data
echo "$tempOutput" | while read -r temp; do
	indv_pressOutput=$(echo "$pressOutput" | head -$counter | tail -1)
	echo "$indv_pressOutput $temp"
	counter=$((counter+1))
done
