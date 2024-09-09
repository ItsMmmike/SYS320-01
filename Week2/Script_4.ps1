# PowerShell Script used to run an instance of Chrome.exe and navigates to "champlain.edu" if it isn't already running, if an instance is running - the script stops it.

# Var checks status of chrome.exe
$ChromeStatus = (Get-Process -Name "chrome" -ea SilentlyContinue)

# if statement used to perform action depending on whether Chrome is running or not
if ($ChromeStatus -eq $null) {
  Write-Host "Chrome is not running, Starting Chrome..."
  Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" '--new-window https://www.champlain.edu'
  } else {
  Write-Host "Chrome is running, Stopping..."
  Stop-Process -Name "chrome"
  }
