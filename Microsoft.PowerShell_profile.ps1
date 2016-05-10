
#=================================================
#Search history
#=================================================
$MaximumHistoryCount = 32767

#=================================================
#Install and configure PSReadLine
#=================================================
if (!(Get-Module -ListAvailable | ? { $_.name -like 'psreadline' })) {
        Install-Module PsReadLine
    }
if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadline -ErrorAction SilentlyContinue

    Set-PSReadlineOption -HistorySavePath "${env:USERPROFILE}\.powershell\history.txt"

    Set-PSReadlineKeyHandler -Key UpArrow   -Function HistorySearchBackward
    Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
    }

#=================================================
#Source common settings
#=================================================
$dir = Split-Path $MyInvocation.MyCommand.Definition
. "$dir\Microsoft.PowerShell_profile.Common.ps1"

Start-SshAgent -Quiet