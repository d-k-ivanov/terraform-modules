<powershell>

$InterfaceInfo  = Get-NetConnectionProfile

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine

Write-Output "Running User Data Script"
Write-Host "(host) Running User Data Script"

# Supress network location Prompt
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force | Out-Null

# TimeZone
Write-Output "Setting TZ"
tzutil /s \"UTC\"

# Firewall settings
New-NetFirewallRule -DisplayName "Allow-RDP-9833-TCP" -Direction Inbound -LocalPort 9833 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow-RDP-9833-UDP" -Direction Inbound -LocalPort 9833 -Protocol UDP -Action Allow
Set-NetConnectionProfile -InterfaceIndex $InterfaceInfo.InterfaceIndex -NetworkCategory Private

# RDP settings
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Terminal*Server\WinStations\RDP-TCP\ -Name PortNumber -Value 9833

Write-Output "Finished"

Restart-Computer -Force

</powershell>
