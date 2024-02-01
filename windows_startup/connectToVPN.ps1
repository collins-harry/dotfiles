. "$HOME\settings.ps1"
$email = Get-Email
$access = Get-Access

Write-Output "Connecting to Work VPN" -ForegroundColor Green

function Connect-VPN {
  param(
    [Parameter(Mandatory=$true)]
    [string]$vpnName,
    [Parameter(Mandatory=$true)]
    [string]$email,
    [Parameter(Mandatory=$true)]
    [string]$access
  )
  return rasdial $vpnName $email $access
}


While ($True) {
  # Check if wifi is connected to "Purple", "Teal" or "Grey" 
  # (the names of the wifi networks at work)
  $wifiName = (netsh wlan show interfaces | findstr "SSID")
  if ($wifiName -match "Purple" -or $wifiName -match "Teal" -or $wifiName -match "Grey") {
    Write-Output "  Already complete, skipping"
    break
  }
  Write-Output "  Connecting to VPN"
  $result = Connect-VPN "Hamilton UK VPN" $email $access
  if ($result | findstr "Command completed successfully") {
    Write-Output "    Connected to VPN succesfully"
    Write-Output "    Result: $result"
    break
  }
  else {
    Write-Output "    Connection failed, trying again in 5 seconds"
    Write-Output "    Error: $result"
    Start-Sleep -Seconds 5 # wait for 5 seconds before the next attempt
  }
}

exit 0
