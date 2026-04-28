param([string]$Path = "C:\Users", [int]$Top = 10, [int]$MinSizeMB = 50)

Get-ChildItem -Path $Path -Recurse -ErrorAction SilentlyContinue |
    Where-Object { -not $_.PSIsContainer -and $_.Length -gt ($MinSizeMB * 1MB) } |
    Sort-Object Length -Descending |
    Select-Object -First $Top Name,
        @{N="Size_MB"; E={[math]::Round($_.Length / 1MB, 2)}},
        DirectoryName |
    Format-Table -AutoSize

Read-Host "Press Enter to exit"