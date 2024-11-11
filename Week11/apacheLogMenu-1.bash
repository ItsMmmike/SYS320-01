#! /bin/bash

# Gather all log entries into one file
logDirectory="/var/log/apache2/"

gatherLogs=$(ls "${logDirectory}" | grep "access.log" | grep -v "other_vhosts" | grep -v "gz")

# Temp file
:> tmpfile.txt

# send log results to tempfile
for logs in ${gatherLogs}
do
	cat "${logDirectory}${logs}" >> tmpfile.txt
done

logFile="./tmpfile.txt"


function displayAllLogs(){
	cat "$logFile"
}

function displayOnlyIPs(){
        cat "$logFile" | cut -d ' ' -f 1 | sort -n | uniq -c
}

# function: displayOnlyPages:
function displayOnlyPages(){
	cat "$logFile" | cut -d ' ' -f 7 | sort -n | uniq -c
}

function histogram(){

	local visitsPerDay=$(cat "$logFile" | cut -d " " -f 4,1 | tr -d '['  | sort \
                              | uniq)
	# This is for debugging, print here to see what it does to continue:
	# echo "$visitsPerDay"

        :> newtemp.txt  # what :> does is in slides
	echo "$visitsPerDay" | while read -r line;
	do
		local withoutHours=$(echo "$line" | cut -d " " -f 2 \
                                     | cut -d ":" -f 1)
		local IP=$(echo "$line" | cut -d  " " -f 1)
          
		local newLine="$IP $withoutHours"
		echo "$IP $withoutHours" >> newtemp.txt
	done 
	cat "newtemp.txt" | sort -n | uniq -c
}

# function: frequentVisitors: 
# Sorts and displays logged IPs that have more than 10 visits
function frequentVisitors(){
	# Grabs filtered input from the Histogram function
	local filteredInput=$(histogram | awk '{print $1 " " $2 " " $3}')

	# Takes filtered input, looks at count, then displays results if greater than 10
	echo "$filteredInput" | while read -r line
	do
		if [ $(echo "$line" | cut -d " " -f 1)  -ge 10 ]; then
			echo "$line"
		fi
	done
}



# function: suspiciousVisitors
# Filter and sort logs that contain indicators of compromise, uses a provided ioc pattern file to determine if file should be counted

function suspiciousVisitors(){
	# Uses a provided pattern file to search through logs, then sorts + displays output
	grep -f "./ioc.txt" $logFile | cut -d " " -f 1 | sort -n | uniq -c
}


while :
do
	echo "PLease select an option:"
	echo "[1] Display all Logs"
	echo "[2] Display only IPS"
	echo "[3] Display only Pages"
	echo "[4] Histogram"
	echo "[5] Frequent visitors"
	echo "[6] Suspicious visitors"
	echo "[7] Quit"

	read userInput
	echo ""

	if [[ "$userInput" == "7" ]]; then
		echo "Goodbye"		
		break

	elif [[ "$userInput" == "1" ]]; then
		echo "Displaying all logs:"
		displayAllLogs

	elif [[ "$userInput" == "2" ]]; then
		echo "Displaying only IPS:"
		displayOnlyIPs

	# Display only pages visited
	elif [[ "$userInput" == "3" ]]; then
		echo "Displaying only pages:"
		displayOnlyPages

	elif [[ "$userInput" == "4" ]]; then
		echo "Histogram:"
		histogram

        # Display frequent visitors
	elif [[ "$userInput" == "5" ]]; then
		echo "Displaying frequent visitors:"
		frequentVisitors

	# Display suspicious visitors
	elif [[ "$userInput" == "6" ]]; then
		echo "Displaying suspicious visitors:"
		suspiciousVisitors

	# Display a message, if an invalid input is given
	else
		echo "Invalid input, please try again"

	fi
done
