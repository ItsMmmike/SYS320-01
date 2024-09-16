# Script file used to call functions from the previous Script File using dot notation
. (Join-Path $PSScriptRoot .\'Functions and Event Logs.ps1')

clear

# Get Login and Logoffs from the last 15 days
$loginoutsTable = GetLoginEvents -15
$loginoutsTable

# Get Start Ups and Shut Downs from the last 25 days
$startstopTable = GetPowerEvents -25
$startstopTable
