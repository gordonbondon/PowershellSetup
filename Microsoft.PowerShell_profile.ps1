
#=================================================
#Search history
#=================================================
$MaximumHistoryCount = 32767

# $HistoryDirPath = "${env:USERPROFILE}\.powershell\"
# $HistoryFileName = "history.clixml"

# if (!(Test-Path $HistoryDirPath -PathType Container)) { New-Item $HistoryDirPath -ItemType Directory }

# Register-EngineEvent PowerShell.Exiting -Action { Get-History -Count $MaximumHistoryCount | Export-Clixml ($HistoryDirPath + $HistoryFileName) } | out-null
# if (Test-path ($HistoryDirPath + $HistoryFileName)) {
#     $history = Import-Clixml ($HistoryDirPath + $HistoryFileName)
#     Add-History $history
#     }

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
#Import my modules
#=================================================
Import-Module Functions -ErrorAction SilentlyContinue

#==================================================
#Import different modules
#==================================================
Import-Module Posh-Git -ErrorAction SilentlyContinue
Import-Module TabExpansionPlusPlus -ErrorAction SilentlyContinue

#==================================================
#Import Zlocation https://github.com/vors/ZLocation
# jumpstat -scan . to scan your folder with subfolders
#==================================================
Import-Module ZLocation -ErrorAction SilentlyContinue

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
Set-Alias mc "C:\Program Files (x86)\Midnight Commander\mc.exe" -option readonly
Set-Alias ghlp Get-Help
Set-Alias gcmd Get-Command
Set-Alias is Start-ISEPreview


#==================================================
#Functions
#==================================================

#Edit prompt via Posh-Git and http://markembling.info/2009/09/my-ideal-powershell-prompt-with-git-integration
function global:prompt {
	# $path = ""
	# $pathbits = ([string]$pwd).split("\", [System.StringSplitOptions]::RemoveEmptyEntries)
	# if($pathbits.length -eq 1) {
	# 	$path = $pathbits[0] + "\"
	# } else {
	# 	$path = $pathbits[$pathbits.length - 1]
	# }
	$realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    $userLocation = $env:username + '@' + [System.Environment]::MachineName + ' ' + $pwd.ProviderPath
    Write-Host($userLocation) -Nonewline -Foregroundcolor Cyan

    #Posh-Git integration
    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE

    #Check if elevated or not
	if ((whoami /all | select-string S-1-16-12288) -ne $null) {
        Write-Host ("`n#") -Nonewline -Foregroundcolor White
    } else {
        Write-Host ("`n$") -Nonewline -Foregroundcolor White
    }
	return " "
}

#Add "cd to previous directory" via http://windows-powershell-scripts.blogspot.com/2009/07/cd-change-to-previous-working-directory.html
Remove-Item Alias:cd

function cd {
    if ($args[0] -eq '-') {
        $pwd=$OLDPWD;
    } else {
        $pwd=$args[0];
    }

    $tmp=pwd;

    if ($pwd) {
        Set-Location $pwd;
    }

    Set-Variable -Name OLDPWD -Value $tmp -Scope global;
}

#==================================================
#Set Location
#==================================================
Set-Location D:\Dropbox\Work\Scripts

Start-SshAgent -Quiet