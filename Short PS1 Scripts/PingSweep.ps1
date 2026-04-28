param([string]$Subnet = "192.168.1")

1..254 | ForEach-Object {
    $ip = "$Subnet.$_"
    if (Test-Connection -ComputerName $ip -Count 1 -Quiet -TimeoutSeconds 1) {
        [PSCustomObject]@{ IP = $ip; Status = "Online" }
    }
} | Format-Table -AutoSize

Read-Host "Press Enter to exit"