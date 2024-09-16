# Q2.) Get login and logoff records from Windows Events and save to a variable
#      Get the last 14 days
$loginouts = Get-EventLog system -source Microsoft-Windows-WinLogon -After (Get-Date).AddDays(-14)

$loginoutsTable = @() # Empty array to fill customly
for ($i=0; $i -lt $loginouts.Count; $i++){

# Creating event property value
$event = ""
if ($loginouts[$i].InstanceID -eq 7001) {$event="Logon"}
if ($loginouts[$i].InstanceID -eq 7002) {$event="Logoff"}


# Creating user property value
$user = $loginouts[$i].ReplacementStrings[1]

# Adding each new line (in form of a custom object) to our empty array
$loginoutsTable += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated;
                                      "Id" = $loginouts[$i].EventID;
                                   "Event" = $event;
                                    "User" = $User;
                                    }
} # End of for

$loginoutsTable
