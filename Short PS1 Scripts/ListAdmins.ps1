$admins = Get-LocalGroupMember -Group "Administrators"

$admins | ForEach-Object {
    [PSCustomObject]@{
        Name            = $_.Name
        ObjectClass     = $_.ObjectClass
        PrincipalSource = $_.PrincipalSource
    }
} | Format-Table -AutoSize

Write-Host "Total admins found: $($admins.Count)" -ForegroundColor Yellow

Read-Host "Press Enter to exit"