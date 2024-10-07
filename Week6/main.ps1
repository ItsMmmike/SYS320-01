. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

clear

$Prompt = "`n"
$Prompt += "Please choose your operation`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - List at Risk Users`n"
$Prompt += "10 - Exit`n"



$operation = $true

while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 10){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }

    elseif($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    }


    # Create a user
    elseif($choice -eq 3){ 

        $name = Read-Host -Prompt "Please enter the username for the new user"
        $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"
        
        # Uses the "checkUser" function to verify if the user exists
        $userStatus = checkUser $name
        if ($userStatus -eq $true){
            Write-host "User exists, stopping function"
            continue
        } 
        elseif ($userStatus -eq $false) {
            # Uses the "checkPassword" function to check to see if the password meets the complexity requriements
            $passStatus = checkPassword $password
            if ($passStatus -eq $false) {
                Write-Host "Password does not meet complexity requirements, please try again"
                continue
            }
            elseif ($passStatus -eq $true) {
                createAUser $name $password
                Write-Host "User $name is created." | Out-String
                continue
            }
        } 
    }


    # Remove a user
    elseif($choice -eq 4){

        $name = Read-Host -Prompt "Please enter the username for the user to be removed"

        # Check the given username with the checkUser function.
        $userStatus = checkUser $name
        if ($userStatus -eq $true){
            removeAUser $name
            Write-Host "User $name Removed." | Out-String
            continue
        } 
        elseif ($userStatus -eq $false) {
            Write-host "User doesn't exist, stopping function"
            continue
        }
    }


    # Enable a user
    elseif($choice -eq 5){

        $name = Read-Host -Prompt "Please enter the username for the user to be enabled"

        # Check the given username with the checkUser function.
        $userStatus = checkUser $name
        if ($userStatus -eq $true){
            enableAUser $name
            Write-Host "User $name Enabled." | Out-String
            continue
        } 
        elseif ($userStatus -eq $false) {
            Write-host "User doesn't exist, stopping function"
            continue
        }
    }


    # Disable a user
    elseif($choice -eq 6){

        $name = Read-Host -Prompt "Please enter the username for the user to be disabled"

        # Check the given username with the checkUser function.
        $userStatus = checkUser $name
        if ($userStatus -eq $true){
            disableAUser $name
            Write-Host "User $name Disabled." | Out-String
            continue
        } 
        elseif ($userStatus -eq $false) {
            Write-host "User doesn't exist, stopping function"
            continue
        }
    }

    # Get Login Logs
    elseif($choice -eq 7){

        $name = Read-Host -Prompt "Please enter the username for the user logs"

        # TODO Check the given username with the checkUser function.
        $userStatus = checkUser $name
        if ($userStatus -eq $true){
            $userLogins = getLogInAndOffs 90
            # TODO Change the above line in a way that, the days 90 should be taken from the user
            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
        } 
        elseif ($userStatus -eq $false) {
            Write-host "User doesn't exist, stopping function"
            continue
        }

        
    }

    # Get Failed Logins
    elseif($choice -eq 8){

        $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"

        # TODO Check the given username with the checkUser function.
        $userStatus = checkUser $name
        if ($userStatus -eq $true){
            # Retrieves all failed user logins from the past 90 days w/ filter for specified user
            $userLogins = getFailedLogins 90
            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
        } 
        elseif ($userStatus -eq $false) {
            Write-host "User doesn't exist, stopping function"
            continue
        }
    }

    # List at Risk Users
    elseif($choice -eq 9){
        
        # Gets days to check from user prompt
        $Days = Read-Host -Prompt "Please enter the number of past days to check for 'At Risk Users'"
        
        # Grabs all failed user logins/logouts
        $riskUsers = getFailedLogins($Days)
        Write-Host "The following user(s) have more than 10 unsuccessful login attemps within the past $Days Days and may be at Risk."
        Write-Host ($riskUsers | Group User | Select Count,Name | Where-Object {$_.Count -gt 10} | Select Name | Out-String)

    }

    # Catch for incorrect user input at menu
    else {
        Write-Host "Option not found, please select an item from the following menu list"
        continue
    }

}