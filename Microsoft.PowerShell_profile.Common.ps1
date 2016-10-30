#=================================================
#Import my modules
#=================================================
Import-Module PSFunctions -ErrorAction SilentlyContinue

#==================================================
#Import different modules
#==================================================
Import-Module Posh-Git -ErrorAction SilentlyContinue
Import-Module TabExpansionPlusPlus -ErrorAction SilentlyContinue
Import-Module ZLocation -ErrorAction SilentlyContinue
Import-Module PoShFuck -ErrorAction SilentlyContinue

#==================================================
#Set aliases
#==================================================

#Removing nix command aliases because i use git bash
foreach ($nxCommand in @('cat','cp','curl','diff','echo','kill','ls','man','mount','mv','ps','pwd','rm','sleep','tee','type','wget')) {
    if (Test-Path -LiteralPath alias:${nxCommand}) {
        Remove-Item -LiteralPath alias:${nxCommand} -Force
    }
}

Set-Alias npp -value "C:\Program Files (x86)\Notepad++\notepad++.exe" -option readonly
Set-Alias subl "C:\Program Files\Sublime Text 3\sublime_text.exe" -option readonly
Set-Alias winscp "C:\Program Files (x86)\WinSCP\WinSCP.exe" -option readonly
Set-Alias mc "C:\Program Files (x86)\Midnight Commander\mc.exe" -option readonly
Set-Alias charm "C:\Program Files (x86)\JetBrains\PyCharm Community Edition 2016.2.3\bin\pycharm64.exe" -Option ReadOnly
Set-Alias ghlp Get-Help
Set-Alias gcmd Get-Command
Set-Alias is Start-ISEPreview
Set-Alias gac Get-ADComputer
Set-Alias gau Get-ADUser
Set-Alias gag Get-ADGroup
Set-Alias test Invoke-Pester


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

    $userLocation = $env:username + '@' + [System.Environment]::MachineName
    $userPath = $PWD.ProviderPath

    Write-Host "`n"
    Write-Host $userLocation -Nonewline -Foregroundcolor Cyan -BackgroundColor Black
    Write-Host " $userPath" -NoNewline -ForegroundColor DarkBlue

    #Posh-Git integration
    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE

    #Check if elevated or not
	if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
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

    $tmp=Get-Location;

    if ($pwd) {
        Set-Location $pwd;
    }

    Set-Variable -Name OLDPWD -Value $tmp -Scope global;
}

#==================================================
#Set Location
#==================================================
$dropBoxFolder = (Get-Content "${env:LOCALAPPDATA}\Dropbox\info.json" | ConvertFrom-Json).personal.path

Set-Location -Path "$dropBoxFolder\Dev"

#==================================================
#Manage SSH agent
#==================================================
#Start-SshAgent -Quiet
#Register-EngineEvent PowerShell.Exiting -Action { Stop-SshAgent } -SupportEvent