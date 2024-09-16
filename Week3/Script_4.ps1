# Q4.) Similar script to Q3, except we turn the script into a function that takes 
#      1 input variable (number of days to take logs) and retruns a table of results.

function GetLoginEvents ([int]$numDays) {

    $loginouts = Get-EventLog system -source Microsoft-Windows-WinLogon -After (Get-Date).AddDays($numDays)

    $loginoutsTable = @() # Empty array to fill customly
    for ($i=0; $i -lt $loginouts.Count; $i++){

    # Creating event property value
    $event = ""
    if ($loginouts[$i].InstanceID -eq 7001) {$event="Logon"}
    elseif ($loginouts[$i].InstanceID -eq 7002) {$event="Logoff"}
    else {continue}


    # Creating user property value
    $user = $loginouts[$i].ReplacementStrings[1]

    # Takes SID String and converts it into a User ID
    $UserID = (New-Object System.Security.Principal.SecurityIdentifier("$user")).Translate([System.Security.Principal.NTAccount])


    # Adding each new line (in form of a custom object) to our empty array
    $loginoutsTable += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated;
                                           "Id" = $loginouts[$i].EventID;
                                        "Event" = $event;
                                         "User" = $SID.Value;
                                         }
    } # End of for

    return $loginoutsTable
}
