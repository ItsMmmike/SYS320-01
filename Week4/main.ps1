<#
# Script that calls/runs functions from the Apache-Logs.ps1 file via dot notation
. (Join-Path $PSScriptRoot .\'Apache-Logs.ps1')

# Runs funciton from Apache-Logs.ps1 using the specified parameters
$Result = FilterRequestIP "index.html" "404" "Chrome"
$Result
#>

# Script that calls/runs the "ApacheLogs1" function from the "Parsing_Apache_Logs.ps1" file
. (Join-Path $PSScriptRoot .\'Parsing_Apache_Logs.ps1')

# Runs the called function and outputs the results
ApacheLogs1
