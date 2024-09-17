# Script that calls/runs functions from the Apache-Logs.ps1 file via dot notation
. (Join-Path $PSScriptRoot .\'Apache-Logs.ps1')

# Runs funciton from Apache-Logs.ps1 using the specified parameters
$Result = FilterRequestIP "index.html" "404" "Chrome"
$Result