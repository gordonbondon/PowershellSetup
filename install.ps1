$profiles = @( "Microsoft.PowerShell_profile.ps1", "Microsoft.PowerShellISE_profile.ps1" )
#$profiles = @( "Microsoft.PowerShellISE_profile.ps1" )
foreach ($name in $profiles)
{
    $profilepath = (Split-Path $PROFILE -Parent) + '\' + $name
    $string = '. ' + (Get-Item $name).FullName
    if (Test-Path $profilepath)
    {
        Set-Content -Path $profilepath -Value $string
    }
    else
    {
        New-Item -Path $profilepath -ItemType File -Force -Value $string
    }
}