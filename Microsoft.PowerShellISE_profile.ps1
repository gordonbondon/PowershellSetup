#Source common settings
$dir = Split-Path $MyInvocation.MyCommand.Definition
. "$dir\Microsoft.PowerShell_profile.Common.ps1"

#Import ISE modules
Import-Module PsISEProjectExplorer