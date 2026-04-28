$paths = @($env:TEMP, "C:\Windows\Temp", "C:\Windows\Prefetch")
$before = 0

foreach ($path in $paths) {
    Get-ChildItem $path -Recurse -ErrorAction SilentlyContinue |
        ForEach-Object {
            $before += $_.Length
            $_ | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        }
}

Write-Host "Cleaned approx $([math]::Round($before / 1MB, 2)) MB of temp files." -ForegroundColor Green
Read-Host "Press Enter to exit"