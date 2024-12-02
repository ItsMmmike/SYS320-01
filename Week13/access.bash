#! /bin/bash

# Record the current date and time
dateTime=$(date +"%a %b %d %I-%M-%S %p")

# Output results to file
echo "$dateTime" >> fileaccesslog.txt

# Take incron file access results and send email alert
echo "To: <email_address_goes_here@email.com>" > emailform2.txt
echo "Subject: Access" >> emailform2.txt
cat fileaccesslog.txt  >> emailform2.txt
cat emailform2.txt | ssmtp <email_address_goes_here@email.com>
