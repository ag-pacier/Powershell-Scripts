<#	
Created by Gage Pacier
SIDA swap script helper
#>

Write-Host "Please put in root login!"

$creds = Get-Credential

Write-Host "Starting printer install, please use IP: 10.11.66.253"

Start-Process -FilePath ".\HP_printer.exe" -Credential $creds

$Printername = Read-Host -Prompt "Name of the printer you just installed"

(Get-WMIObject -ClassName win32_printer |Where-Object -Property Name -eq "$Printername").SetDefaultPrinter()