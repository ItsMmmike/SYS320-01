# Script that calls/runs the "gatherClasses" function from the "Scraping_Champlain_Classes.ps1" file
. (Join-Path $PSScriptRoot .\'Scraping_Champlain_Classes.ps1')

# Runs the function "gatherClasses" and outputs the results into the "$FullTable" variable
$FullTable = gatherClasses

# Q1.) List all the classes of Instructor Furkan Paligu
#$FullTable | Select-Object "Class Code", Instructor, Location, Days, "Time Start", "Time End" |
#             Where { $_."Instructor" -ilike "Furkan*" }

# Q2.) List all the classes of JOYC 310 on Mondays, only display Class Code and Times
# Sort by Start Time
#$FullTable | Where-Object { ($_.Location -ilike "JOYC 310") -and ($_.days -contains "Monday") } |
#             Sort-Object "Time Start" |
#             Format-Table "Time Start", "Time End", "Class Code"

# Q3.) Make a list of all the instructors that teach at least 1 course in
# SYS, SEC, NET, FOR, CSI, DAT
# Sort by name, and make it unique
$ITSInstructors = $FullTable | Where-Object { ($_."Class Code" -ilike "SYS*") -or `
                                              ($_."Class Code" -ilike "SEC*") -or `
                                              ($_."Class Code" -ilike "NET*") -or `
                                              ($_."Class Code" -ilike "FOR*") -or `
                                              ($_."Class Code" -ilike "CSI*") -or `
                                              ($_."Class Code" -ilike "DAT*") } `
#                             | Select-Object "Instructor" `
#                             | Sort-Object "Instructor" -Unique

# Q4.) Group all the instructors by the number of classes they are teaching (Uses the query script from the prev question)
$FullTable | Where { $_.Instructor -in $ITSInstructors.Instructor } `
           | Group-Object "Instructor" | Select-Object Count,Name | Sort-Object Count -Descending