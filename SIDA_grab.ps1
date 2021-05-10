<#	
Created by Gage Pacier
SIDA swap script helper
#>

$MAC = Get-CimInstance win32_networkadapterconfiguration | Where-Object -Property "Description" -Match "Realtek" | Select-Object -ExpandProperty macaddress
$MAC = $MAC -replace ":","-"
$Serial = Get-CimInstance win32_bios | Select-Object -ExpandProperty SerialNumber

$OutPut = "{0}.txt" -f $env:COMPUTERNAME

New-Item -Path $PWD -ItemType "file" -Name $OutPut

$Contents = "MAC: {0},, Serial: {1}" -f $MAC, $Serial

Add-Content -Path $OutPut -Value $Contents