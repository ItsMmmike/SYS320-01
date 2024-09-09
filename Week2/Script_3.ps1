# PowerShell Script used to list every stopped service, ordered alphabetically, and saves the results to a csv file
$filePath = "$PSScriptRoot\outfolder\results.csv"
Get-Service | Where-Object { $_.Status -eq "Stopped" } | Select-Object Name | Export-Csv $filePath -NoType
