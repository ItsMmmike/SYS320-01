#!/bin/bash

# HTML Report Bash Script used to format and upload suspicious logs as an HTML table on a local webserver


# Retrieve report logs from file
reportLogs="./report.txt"

# Creating new temp report.html file
:> report.html

# Formatting input report.txt information
formattedReport=$(cat "$reportLogs" | while read -r line;
do
	addTableTag=$(echo "$line" | awk '{print "<td>"$1"</td>""<td>"$2"</td>""<td>"$3"</td>"}')
	echo -e "<tr>\n$addTableTag\n</tr>"
done)

# Formatting report html file
echo -e "<html>\n<body>\n<p>Access logs with IOC indicators:<p>\n<table>\n$formattedReport\n</table>\n</body>\n</html>" > ./report.html

# Write out the updated report.html file to the "/var/www/html" directory
sudo mv ./report.html /var/www/html/
