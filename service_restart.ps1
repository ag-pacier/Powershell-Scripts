#Restart a service and log the process
#If an error hits, STOP RUNNING
$ErrorActionPreference = "Stop"

#Setup the info for the log file
$TimeStampFormat = "HH:mm:ss"
$DateStamp = Get-Date -Format "yyyyMMdd"
#Generically named log file up here so that errors still get logged
$LogFile = "C:\service_restarter" + "_" + $DateStamp + ".txt"

#Make sure argument is valid
#If no arguement, log that you can't do that and stop
if ($null -eq $args[0]) {
    $Timestamp = Get-Date -Format $TimeStampFormat
    $msg = $Timestamp + "  :: The service cannot be nothing."
    Add-Content -Path $LogFile -Value $msg
    throw "Need the service name as an arguement"
}
#Look for the service with that name. If nothing outputs, can't find the service
elseif ($null -eq (Get-Service -Name $args[0] -ErrorAction SilentlyContinue)){
    $Timestamp = Get-Date -Format $TimeStampFormat
    $msg = $Timestamp + " :: Unable to find a service that matches the name: " + $args[0]
    Add-Content -Path $LogFile -Value $msg
    throw "Service name not found matching " + $args[0]
}
#If the service isn't always running, you cannot restart it
elseif ((Get-Service -Name $args[0]).Status -notcontains "Running"){
    $Timestamp = Get-Date -Format $TimeStampFormat
    $msg = $Timestamp + " :: The service named " + $args[0] + " is not currently running."
    Add-Content -Path $LogFile -Value $msg
    throw "Cannot restart a service not currently running"
}
#Otherwise, set $ServiceName and rename the log file
else {
    $ServiceName = $args[0]
    $LogFile = "C:\" + $ServiceName + "_" + $DateStamp + ".txt"
}

#Hashtable used to generate the log
$FinalOutput = [ordered]@{ OldStatus = "Not Found"; NewStatus = "Not Found"; StartTime = "none"; FinishTime = "none"; Conclusion = "None" }

#Time the script started doing real stuff to aid in troubleshooting
$FinalOutput["StartTime"] = Get-Date -Format $TimeStampFormat

#Pull the current status of the service
#This will always be running for now, but just in case
$FinalOutput["OldStatus"] = (Get-Service -Name $ServiceName).Status

#Restart the service without prompting and then check the status when complete
$FinalOutput["NewStatus"] = (Restart-Service -Force -Name $ServiceName -PassThru).Status

#Make sure the service is running, if not log my advice to check the event log for issues
if ($FinalOutput["NewStatus"] -contains "Running") {
    $FinalOutput["Conclusion"] = "Service running normally."
} else {
    $FinalOutput["Conclusion"] = "Error restarting service. Check the event log between saved times."
}

#Get the time the bulk of the work is complete
$FinalOutput["FinishTime"] = Get-Date -Format $TimeStampFormat

#Output to the log file
$FinalOutput | Out-String | Add-Content $LogFile