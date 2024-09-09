# PowerShell Script used to list every process for which the path does not include hte string "system32"
Get-Process | Where-Object { $_.Path -inotlike "*system32*" } | Select-Object ProcessName
