$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$ram = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)

[PSCustomObject]@{
    Hostname    = $env:COMPUTERNAME
    OS          = $os.Caption
    LastBoot    = $os.LastBootUpTime
    CPU         = $cpu.Name
    RAM_GB      = $ram
    CurrentUser = $env:USERNAME
} | Format-List

Read-Host "Press Enter to exit"