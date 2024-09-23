# Q1.) Get the link count from your web page
<#
$scraped_page = Invoke-WebRequest -TimeoutSec 10 http://10.0.17.18/ToBeScraped.html

# Counts the links found on the page
$scraped_page.Links.Count
#>

# Q2.) Get the links as HTML elements
<#
$scraped_page = Invoke-WebRequest -TimeoutSec 10 http://10.0.17.18/ToBeScraped.html

# Display links as HTML Elements
$scraped_page.Links
#>

# Q3.) Get the links and display only the URL and its text
<#
$scraped_page = Invoke-WebRequest -TimeoutSec 10 http://10.0.17.18/ToBeScraped.html

# Display only the URL and its text
$scraped_page.Links | Format-List -Property outerText, href
#>

# Q4.) Get the outer text of every element with the tag h2
<#
$scraped_page = Invoke-WebRequest -TimeoutSec 10 http://10.0.17.18/ToBeScraped.html

$h2s=$scraped_page.ParsedHtml.body.getElementsByTagName("h2") | Select-Object outerText

$h2s
#>

# Q5.) Print inntrText of every div element that has the class "div-1"
$scraped_page = Invoke-WebRequest -TimeoutSec 10 http://10.0.17.18/ToBeScraped.html

$divs1=$scraped_page.ParsedHtml.body.getElementsByTagName("div") | where {
$_.getAttributeNode("class").Value -ilike "div-1" } | select innerText

$divs1
