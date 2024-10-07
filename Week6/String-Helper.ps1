<# String-Helper
*************************************************************
   This script contains functions that help with String/Match/Search
   operations. 
************************************************************* 
#>


<# ******************************************************
   Functions: Get Matching Lines
   Input:   1) Text with multiple lines  
            2) Keyword
   Output:  1) Array of lines that contain the keyword
********************************************************* #>
function getMatchingLines($contents, $lookline){

$allines = @()
$splitted =  $contents.split([Environment]::NewLine)

for($j=0; $j -lt $splitted.Count; $j++){  
 
   if($splitted[$j].Length -gt 0){  
        if($splitted[$j] -ilike $lookline){ $allines += $splitted[$j] }
   }

}

return $allines
}

# Function used to check to see if a password meets the complexity requirements
function checkPassword($password){

# Takes password and converts it to plain text - stores value in a var

$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
$plain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

$regex1 = [regex] "[A-Za-z]" # 1 or more letters
$regex2 = [regex] "[0-9]" # 1 or more numbers
$regex3 = [regex] "[^A-Za-z0-9]" # 1 or more special chars

    if (($plain.length -ge 6) -and ($plain -cmatch $regex1) -and ($plain -cmatch $regex2) -and ($plain -cmatch $regex3)) {
        return $true
    }
    else {
        return $false
    }
}