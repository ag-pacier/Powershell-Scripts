#Setting IExplorer settings
Write-Verbose "Now configuring IE"
#Add a website as a trusted Site/Domain
$WebSite = "safe.lcs.massport-acs.com"
#Array of items that need to be enabled
[string[]]$Enabled_Items = 2702, 1208, 1209, 2201, 2000, 1001, 1004, 1201, 1200, 1803, 1604, 2600, 1406, 1608, 2102, 2300, 2104, "1A04", 1802, "160A", 1804, 1607, 1601, 1606, 2101, 1400, 1407, 2105, 1409, 1402
[int32[]]$Disabled_Items = 1809
[int32[]]$Prompt_Items = 1609, 1806
#Navigate to the domains folder in the registry
set-location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
set-location ZoneMap\Domains

#Create a new folder with the website name
new-item $WebSite -Force
set-location ($WebSite + '\')
new-itemproperty . -Name * -Value 2 -Type DWORD -Force
new-itemproperty . -Name http -Value 2 -Type DWORD -Force
new-itemproperty . -Name https -Value 2 -Type DWORD -Force

#Navigate to the trusted domains folder in the registry:

#Go to registry folder for Trusted Domains
Set-Location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\zones\2"
foreach ($key in $Enabled_Items){
    New-ItemProperty . -Name $key -Value 0 -Type DWORD -Force
}
foreach ($key in $Disabled_Items){
    New-ItemProperty . -Name $key -Value 1 -Type DWORD -Force
}
foreach ($key in $Prompt_Items){
    New-ItemProperty . -Name $key -Value 3 -Type DWORD -Force
}