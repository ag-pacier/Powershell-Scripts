<#	
Created by Gage Pacier
SIDA swap script helper
#>

$Printername = Read-Host -Prompt "Name of the printer you just installed"
$message = "Setting {0} as the default printer..." -f $Printername
Write-Host $message
(Get-WMIObject -ClassName win32_printer | Where-Object -Property Name -eq "$Printername").SetDefaultPrinter()

Write-Host "Turning off Windows default printer selection"
Set-ItemProperty -Path "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows" -Name "LegacyDefaultPrinterMode" -Value 1

Write-Host "All set! Please reach out to IET to double check the work after you have rebooted one more time."
Start-Sleep -Seconds 3