# Q1.) Get login and logogg records from Windows Events
# Get-EventLog System -source Microsoft-Windows-Winlogon

# Q2.) Get login and logoff records from Windows Events and save to a variable
#      Get the last 14 days
#$loginouts = Get-EventLog system -source Microsoft-Windows-WinLogon -After (Get-Date).AddDays(-14)
#
#$loginoutsTable = @() # Empty array to fill customly
#for ($i=0; $i -lt $loginouts.Count; $i++){
#
## Creating event property value
#$event = ""
#if ($loginouts[$i].InstanceID -eq 7001) {$event="Logon"}
#if ($loginouts[$i].InstanceID -eq 7002) {$event="Logoff"}
#
#
## Creating user property value
#$user = $loginouts[$i].ReplacementStrings[1]
#
## Adding each new line (in form of a custom object) to our empty array
#$loginoutsTable += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated;
#                                       "Id" = $loginouts[$i].EventID;
#                                    "Event" = $event;
#                                     "User" = $User;
#                                     }
#} # End of for
#
#$loginoutsTable
                                   
# Q3.) Similar script to Q2, except we translate the User SID to a Username
#$loginouts = Get-EventLog system -source Microsoft-Windows-WinLogon -After (Get-Date).AddDays(-14)

#$loginoutsTable = @() # Empty array to fill customly
#for ($i=0; $i -lt $loginouts.Count; $i++){

# Creating event property value
#$event = ""
#if ($loginouts[$i].InstanceID -eq 7001) {$event="Logon"}
#if ($loginouts[$i].InstanceID -eq 7002) {$event="Logoff"}


# Creating user property value
#$user = $loginouts[$i].ReplacementStrings[1]

# Takes SID String and converts it into a new object
#$UserID = (New-Object System.Security.Principal.SecurityIdentifier("$user")).Translate([System.Security.Principal.NTAccount])

# Adding each new line (in form of a custom object) to our empty array
#$loginoutsTable += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated;
#                                       "Id" = $loginouts[$i].EventID;
#                                    "Event" = $event;
#                                     "User" = $UserID.Value;
#                                     }
#} # End of for
#
#$loginoutsTable

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



# Q5.) Similar script to Q4, except we display the EventID information for computer Start and Shutdown times

function GetPowerEvents ([int]$numDays) {

    $startstop = Get-EventLog system -source EventLog -After (Get-Date).AddDays($numDays)

    $startstopTable = @() # Empty array to fill customly
    for ($i=0; $i -lt $startstop.Count; $i++){

    # Creating event property value
    $event = ""
    if ($startstop[$i].EventID -eq 6005) {$event="Startup"}
    
    elseif ($startstop[$i].EventID -eq 6006) {$event="Shutdown"}

    # Skips to next event if neither EventID matches
    else {continue}


    # Creating user property value
    $user = "System"

    # Adding each new line (in form of a custom object) to our empty array
    $startstopTable += [pscustomobject]@{"Time" = $startstop[$i].TimeGenerated;
                                           "Id" = $startstop[$i].EventID;
                                        "Event" = $event;
                                         "User" = $user;
                                         }
    } # End of for

    return $startstopTable
}
