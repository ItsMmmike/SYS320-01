# Function used to take 3 inputs (Page visited, HTTP code returned, Name of Web Browser)
# and returns a filter of all IP Addresses that accessed the webpage using the input vars

Function FilterRequestIP ([string]$pageVisited,[string]$codeReturned, [string]$Browser) {
    
    # Retrieves all apache logs that contain the specified information (webpage, HTTP Status Code, Browser Type)
    $query = Get-Content C:\xampp\apache\logs\access.log | Select-String $pageVisited | Select-String $codeReturned | Select-String $Browser

    # Define a regex for IP address
    $regex = [regex] "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"

    # Get $query records that match to the regex
    $ipsUnorganized = $regex.Matches($query)

    # Get ips as pscustonboject
    $ips = @()
    for($i=0; $i -lt $ipsUnorganized.Count; $i++){
     $ips += [pscustomobject]@{ "IP" = $ipsUnorganized[$i].Value}
    }

    # Filter IPs within the 10.X.X.X range
    $ipsoftens = $ips | Where-Object { $_.IP -ilike "10.*" }
    $counts = $ipsoftens | Group IP

    # Function outputs a table containing IPs matching the search query + count number
    return $counts | Select-Object Count, Name
}