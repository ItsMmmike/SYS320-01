# Write a PowerShell Script that lists every process for which ProcesssName starts with 'C'.
Get-Process | Where-Object { $_.ProcessName -ilike "C*" }
