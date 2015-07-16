
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

#Function to search throught history
function hgrep {
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [string]$Regex,
        [Parameter(Mandatory=$false)]
        [switch]$Full
    )
    $commands = get-history |?{$_.commandline -match $regex}
    if ($full) {
        $commands |ft *
    }
    else {
        foreach ($command in ($commands |select -ExpandProperty commandline)) {
            # This ensures that only the first line is shown of a multiline command
            # You can always get the full command using get-history or you can fork and remove this from the gist
            if ($command -match '\r\n') {
                ($command -split '\r\n')[0] + " ..."
            }
            else {
                $command
            }
        }
    }
}

function Search-ADUser {
    param(
        [String]$SearchString
    )

    $Match = Get-ADUser -Filter "samaccountname -like '*$($SearchString)*' -or name -like '*$($SearchString)*' -or givenname -like '*$($SearchString)*' -or surname -like '*$($SearchString)*' -or userprincipalname -like '*$($SearchString)*'"

    if($Match -eq $null) {
        # Nothing was found
        Write-Host "No matching accounts were found."
    } else {
        $Match
    }
}

function Search-ADComputer {
    param(
        [String]$SearchString
    )

    $Match = Get-ADComputer -Filter "samaccountname -like '*$($SearchString)*' -or name -like '*$($SearchString)*'"

    if($Match -eq $null) {
        # Nothing was found
        Write-Host "No matching accounts were found."
    } else {
        $Match
    }
}

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
    	Write-Host($userLocation) -foregroundcolor Cyan

	if ((whoami /all | select-string S-1-16-12288) -ne $null) {
        Write-Host('#') -nonewline -foregroundcolor White
    } else {
        Write-Host('$') -nonewline -foregroundcolor White
    }
	return " "
}
