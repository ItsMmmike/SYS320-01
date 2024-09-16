# Q3.) Similar script to Q2, except we translate the User SID to a Username
$loginouts = Get-EventLog system -source Microsoft-Windows-WinLogon -After (Get-Date).AddDays(-14)

$loginoutsTable = @() # Empty array to fill customly
for ($i=0; $i -lt $loginouts.Count; $i++){

# Creating event property value
$event = ""
if ($loginouts[$i].InstanceID -eq 7001) {$event="Logon"}
if ($loginouts[$i].InstanceID -eq 7002) {$event="Logoff"}


# Creating user property value
$user = $loginouts[$i].ReplacementStrings[1]

# Takes SID String and converts it into a new object
$UserID = (New-Object System.Security.Principal.SecurityIdentifier("$user")).Translate([System.Security.Principal.NTAccount])

# Adding each new line (in form of a custom object) to our empty array
$loginoutsTable += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated;
                                      "Id" = $loginouts[$i].EventID;
                                   "Event" = $event;
                                    "User" = $UserID.Value;
                                    }
} # End of for

$loginoutsTable
