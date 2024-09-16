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
