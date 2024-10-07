# Import necessary functions
. 'C:\Users\champuser\Documents\Week 4\Parsing_Apache_logs.ps1'
. (Join-Path $PSScriptRoot Event-Logs.ps1)
. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Users.ps1)



clear

$Prompt = "`n"
$Prompt += "Please choose your operation`n"
$Prompt += "1 - Display the last 10 Apache Logs`n"
$Prompt += "2 - Display the last 10 failed logins for all users`n"
$Prompt += "3 - Display at Risk Users`n"
$Prompt += "4 - Start/Stop Champlain.edu Chrome Tab`n"
$Prompt += "5 - Exit`n"



$menu_open = $true

while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 5){
        Write-Host "Thank you for using the menu, Goodbye" | Out-String
        exit
        $operation = $false 
    }

    # Display the last 10 Apache Logs
    elseif($choice -eq 1){
        $ApacheLogs = ApacheLogs1 
        Write-Host ($ApacheLogs[-10..-1] | Format-Table -Autosize -Wrap | Out-String)
        continue
    }

    # Display the last 10 failed logins for all user
    elseif($choice -eq 2){

        $Days = Read-Host -Prompt "Please input the number of days to check for failed user logins"
        $FailedLogins = getFailedLogins($Days)
 
        Write-Host "Here are the results from the FailedLogin Search:"
        Write-Host ($FailedLogins | Select -Last 10 | Format-Table | Out-String)
        continue
    }

    # Display at Risk Users
    # Gets days to check from user prompt
    elseif($choice -eq 3) {
        $Days = Read-Host -Prompt "Please enter the number of past days to check for 'At Risk Users'"
        
        # Grabs all failed user logins/logouts
        $riskUsers = getFailedLogins($Days)
        Write-Host "The following user(s) have more than 10 unsuccessful login attemps within the past $Days Days and may be at Risk."
        Write-Host ($riskUsers | Group User | Select Count,Name | Where-Object {$_.Count -gt 10} | Select Name | Out-String)
    }

    #Start/Stop Champlain.edu Chrome Tab
    elseif($choice -eq 4){
        . 'C:\Users\champuser\Documents\Week 2\Script_4.ps1'
    }

    # Catch for invalid menu inputs
    else {
        Write-Host "Option not found, please select an item from the following menu list"
        continue
    }

}

