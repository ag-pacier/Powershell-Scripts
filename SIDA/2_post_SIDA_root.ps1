<#
Gage Pacier's root SIDA script
#>

#Requires -RunAsAdministrator

Write-Host "Setting connection to PRIVATE"
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

Write-Host "Starting printer install, please use IP: 10.11.66.253 if in the SIDA Training Room"
Start-Process -FilePath ".\upd-pcl6-x64-7.0.0.24832.exe"

Write-Host "Ensure you make a note of what you named the printer for the last step!"
Write-Host "Enabling Remote Desktop..."
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-Name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

Write-Host "Please reboot the PC. Once the training account comes up, please run the final script 3_post_SIDA_train.ps1"
Start-Sleep -Seconds 3