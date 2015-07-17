
#=================================================
#Search history
#=================================================
$HistoryDirPath = "D:\Dropbox\Work\Setup\Powershell\History\"
$HistoryFileName = "history.clixml"

if (!(Test-Path $HistoryDirPath -PathType Container)) { New-Item $HistoryDirPath -ItemType Directory }

Register-EngineEvent PowerShell.Exiting –Action { Get-History | Export-Clixml ($HistoryDirPath + $HistoryFileName) } | out-null
if (Test-path ($HistoryDirPath + $HistoryFileName)) { Import-Clixml ($HistoryDirPath + $HistoryFileName) | Add-History }

#=================================================
#Install and configure PSReadLine
#=================================================
if (!(Get-Module -ListAvailable | ? { $_.name -like 'psreadline' })) {
        Install-Module PsReadLine
    }
if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadline -ErrorAction SilentlyContinue

    Set-PSReadlineKeyHandler -Key UpArrow   -Function HistorySearchBackward
    Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
    }

#=================================================
#Import my module
#=================================================
Import-Module D:\Dropbox\Work\Scripts\Modules\Functions.psm1

#=================================================
#Install TabExpansion
#=================================================
if (!(Get-Module -ListAvailable | ? { $_.name -like 'TabExpansion++' })) {
        Install-Module -ModuleUrl https://github.com/lzybkr/TabExpansionPlusPlus/zipball/master/ -ModuleName TabExpansion++ -Type ZIP
    }
if ($host.Name -eq 'ConsoleHost') {
    Import-Module TabExpansion++ -ErrorAction SilentlyContinue
    }


#==================================================
#Import different modules
#==================================================
#Import-Module ActiveDirectory -ErrorAction SilentlyContinue
#Import-Module Posh-SSH -ErrorAction SilentlyContinue
#Import-Module PSCX -ErrorAction SilentlyContinue

#==================================================
#Add snapins
#==================================================
#Add-PSSnapin vmware.vimautomation.core -ErrorAction SilentlyContinue

#==================================================
#Set aliases
#==================================================
Set-Alias npp -value "C:\Program Files (x86)\Notepad++\notepad++.exe" -option readonly
Set-Alias subl "C:\Program Files\Sublime Text 3\sublime_text.exe" -option readonly
Set-Alias winscp "C:\Program Files (x86)\WinSCP\WinSCP.exe" -option readonly
Set-Alias ssh "D:\Tools\plink.exe" -option readonly
Set-Alias ghlp Get-Help
Set-Alias gcmd Get-Command


#==================================================
#Functions
#==================================================

#Edit prompt
function prompt {
	# $path = ""
	# $pathbits = ([string]$pwd).split("\", [System.StringSplitOptions]::RemoveEmptyEntries)
	# if($pathbits.length -eq 1) {
	# 	$path = $pathbits[0] + "\"
	# } else {
	# 	$path = $pathbits[$pathbits.length - 1]
	# }
	$userLocation = $env:username + '@' + [System.Environment]::MachineName + ' ' + $pwd
	$host.UI.RawUi.WindowTitle = $userLocation
    	Write-Host($userLocation) -Foregroundcolor Cyan

	if ((whoami /all | select-string S-1-16-12288) -ne $null) {
        Write-Host('#') -Nonewline -Foregroundcolor White
    } else {
        Write-Host('$') -Nonewline -Foregroundcolor White
    }
	return " "
}

#==================================================
#Set Location
#==================================================
Set-Location D:\Dropbox\Work\Scripts