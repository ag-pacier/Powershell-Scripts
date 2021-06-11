<#
Gage Pacier's root SIDA script
#>

#Requires -RunAsAdministrator

Write-Host "Setting connection to PRIVATE"

$Current = Get-NetConnectionProfile -NetworkCategory
$CommandRep = 0

while ($Current -ne "Private") {
    Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
    Start-Sleep -Seconds 2
    $CommandRep ++
    if ($CommandRep -gt 2) {
        Write-Host "Unable to set the connection to private. Please check the Ethernet connection."
        Write-Host "Once resolved, please try again."
        exit
    }
}

Write-Host "Starting printer install, please use IP: 10.21.66.253 if in the SIDA Training Room"
Start-Sleep -Seconds 1
Start-Process -FilePath "upd-pcl6-x64-7.0.0.24832.exe"

Write-Host "Ensure you make a note of what you named the printer for the last step!"
Write-Host "Enabling Remote Desktop..."
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

Write-Host "Please reboot the PC. Once the training account comes up, please run the final script run_3.bat"
Start-Sleep -Seconds 3