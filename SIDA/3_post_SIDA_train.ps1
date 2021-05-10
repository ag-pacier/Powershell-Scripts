<#	
Created by Gage Pacier
SIDA swap script helper
#>

$Printername = Read-Host -Prompt "Name of the printer you just installed"
(Get-WMIObject -ClassName win32_printer |Where-Object -Property Name -eq "$Printername").SetDefaultPrinter()

Write-Host "All set! Please reach out to IET to double check the work after you have rebooted one more time."
Start-Sleep -Seconds 3