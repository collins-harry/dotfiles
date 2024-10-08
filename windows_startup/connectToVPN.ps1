. "$HOME\settings.ps1"
$email = Get-Email
$access = Get-Access

Write-Host "Connecting to Work VPN" -ForegroundColor Green

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

$vpns = @('Hamilton IE VPN', 'Hamilton UK VPN')
$vpnIndex = 0

While ($True) {
    if (Get-NetIpConfiguration | Out-String | Select-String "hamiltongroupuk.com") {
        Write-Host "  Already connected to Work VPN/WIFI/LAN, skipping"
        break
    }

    $currentVpn = $vpns[$vpnIndex]
    Write-Host "  Attempting to connect to $currentVpn"
    Write-Host "Connect-VPN $currentVpn $email $access"
    $result = Connect-VPN $currentVpn $email $access
    

    if ($result | Select-String "Command completed successfully") {
        Write-Host "    Connected to $currentVpn successfully"
        Write-Host "    Result: $result"
        break
    }
    else {
        Write-Host "    Connection to $currentVpn failed, trying the other VPN in 5 seconds"
        Write-Host "    Error: $result"
        Start-Sleep -Seconds 2 # wait for 5 seconds before the next attempt
        $vpnIndex = ($vpnIndex + 1) % 2 # Switch to the other VPN
    }
}

exit 0
