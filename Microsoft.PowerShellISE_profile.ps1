#=================================================
#Install and configure ISEGit
#=================================================
if (!(Get-Module -ListAvailable | ? { $_.name -like 'ISEGit' })) {
        Powershellget\Install-Module ISEGit
    }
Import-Module ISEGit

Set-Location D:\Dropbox\Work\Scripts