$profiles = @( "Microsoft.PowerShell_profile.ps1", "Microsoft.PowerShellISE_profile.ps1" )

#Set my profiles
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

#Add my module folder to module path via http://tomtalks.uk/2013/06/powershell-add-a-persistent-module-path-to-envpsmodulepath/
$originalpaths = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PSModulePath).PSModulePath
$newPath = $originalpaths + ';' + (Get-Item ..\..\Scripts\Modules\).FullName
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PSModulePath -Value $newPath

#Set Get-Credential password promt co console mode
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds" -Name ConsolePrompting -Value $true