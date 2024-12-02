#! /bin/bash

# Adding all auth logs into one file
logDir="/var/log/"

gatherLogs=$(ls "${logDir}" | grep "auth.log" | grep -v "gz")

# Temp File
:> tmpfile.txt

# Send log results to temp file
for logs in ${gatherLogs}; do
	cat "${logDir}${logs}" >> tmpfile.txt
done

# Point var to new logfile location
authfile="./tmpfile.txt"


function getLogins(){
 logline=$(cat "$authfile" | grep "systemd-logind" | grep "New session")
 dateAndUser=$(echo "$logline" | cut -d' ' -f1,3,12 | tr -d '\.')
 echo "$dateAndUser" 
}

# Todo -1
# Function used to gather failed login attempts onto the local system
function getFailedLogins(){
 logline=$(cat "$authfile" | grep "authentication failure")
 dateAndUser=$(echo "$logline" | cut -d' ' -f1,3,17 | sed 's/user=/''/g' | tr -d '\.')
 echo "$dateAndUser"
}

# Sending logins as email --> Sending to my own email account
echo "To: <email_address_goes_here@email.com>" > emailform.txt
echo "Subject: Logins" >> emailform.txt
getLogins >> emailform.txt
cat emailform.txt | ssmtp <email_address_goes_here@email.com>

# Todo - 2
# Send failed logins as email to yourself.
echo "To: <email_address_goes_here@email.com>" > emailform.txt
echo "Subject: FailedLogins" >> emailform.txt
getFailedLogins >> emailform.txt
cat emailform.txt | ssmtp <email_address_goes_here@email.com>
