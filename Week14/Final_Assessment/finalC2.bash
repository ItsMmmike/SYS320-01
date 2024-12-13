#!/bin/bash

# Script used to list the apache logs that contain indicators of compromise

# Help Menu/Syntax
function helpMenu(){
echo ""
echo "Invalid Syntax!"
echo "==============="
echo "Correct Syntax Format:"
echo "bash $0 <access-log-file-goes-here> <IOC.txt-file-goes-here>"
echo ""
}

if [ ! ${#} -eq 2 ]; then
helpMenu
exit;
fi

# Process User Input Files
accessLogFile="./$1"
IOCFile="./$2"

# Analyzes log file for IOCs based on the provided pattern file
results=$(grep -f $IOCFile  $accessLogFile | cut -d' ' -f1,4,7 | tr -d '[' )

# Saves output results to report.txt file
echo "$results" > ./report.txt
