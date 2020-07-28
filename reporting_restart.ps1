#Restart the reporting service and log the process

#Make sure argument is valid
if ($null -eq (Get-Service -Name $args[0] -ErrorAction SilentlyContinue)){
    throw "Service name not found matching " + $args[0]
}
elseif ((Get-Service -Name $args[0]).Status -notcontains "Running"){
    throw "Cannot restart a service not currently running"
}
else {
    $ServiceName = $args[0]
}

#Setup the info for the log file
$DateStamp = Get-Date -Format "yyyyMMdd"
$LogFile = "C:\" + $ServiceName + "_" + $DateStamp + ".txt"

#Hashtable used to generate the log
$FinalOutput = @{ OldStatus = "Not Found"; NewStatus = "Not Found"; StartTime = "none"; FinishTime = "none"; Conclusion = "None" }

#Time the script started to make sure it didn't get stuck
$FinalOutput["StartTime"] = Get-Date -Format "HH:mm:ss"

#Pull the current status of the service
$FinalOutput["OldStatus"] = (Get-Service -Name $ServiceName).Status

#Take action on the service and pull the new status
$FinalOutput["NewStatus"] = (Restart-Service -Force -Name $ServiceName -PassThru).Status

#Make sure the service is running
if ($FinalOutput["NewStatus"] -contains "Running") {
    $FinalOutput["Conclusion"] = "Service running normally."
} else {
    $FinalOutput["Conclusion"] = "Error restarting service. For further information, please check the event log at the times between this script's start and end."
}

#Get the time the bulk of the work is complete
$FinalOutput["FinishTime"] = Get-Date -Format "HH:mm:ss"

#Output to the log file
$FinalOutput | Out-String | Add-Content $LogFile