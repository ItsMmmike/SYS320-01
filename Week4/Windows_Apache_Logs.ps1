# Q1.) List all of the apache logs of xampp
Get-Content C:\xampp\apache\logs\access.log

# Q2.) Script used to list the last 5 apache logs of xampp
Get-Content C:\xampp\apache\logs\access.log -Tail 5

# Q3.) Display only logs that contain 404 (Not Found) or 400 (Bad Request)
Get-Content C:\xampp\apache\logs\access.log | Select-String ' 404 ',' 400 '

# Q4.) Display only logs that contain 404 (Not Found) or 400 (Bad Request)
Get-Content C:\xampp\apache\logs\access.log | Select-String ' 200 ' -NotMatch

# Q5.) From every .log file in the directory, only get logs that contains the word 'error'
$A = Get-ChildItem -Path C:\xampp\apache\logs\*.log | Select-String 'error'
$A[-5..-1]

# Q6.) Get only logs that contain 404, save into $notfounds
$notfounds = Get-Content C:\xampp\apache\logs\access.log | Select-String ' 404 '

# Define a regex for IP address
$regex = [regex] "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"

# Get $notfounds recrods that match to the regex
$ipsUnorganized = $regex.Matches($notfounds)

# Get ips as pscustonboject
$ips = @()
for($i=0; $i -lt $ipsUnorganized.Count; $i++){
 $ips += [pscustomobject]@{ "IP" = $ipsUnorganized[$i].Value}
}

# Q7.) Similar script to Q6, except we cound the number of IPs from the output 
#      (**Note: This is also using the previous script above)
$ipsoftens = $ips | Where-Object { $_.IP -ilike "10.*" }
$counts = $ipsoftens | Group IP
$counts | Select-Object Count, Name
