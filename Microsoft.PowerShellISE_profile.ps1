Set-Location D:\Dropbox\Work\Scripts

Import-Module PSReadline -ErrorAction SilentlyContinue
Set-PSReadlineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward