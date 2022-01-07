# ***************************************************************************
# ***************************************************************************
# SQL FULL DB backup
# 
# Author : Jiri Gartner
# Version: 1.0
# Notes:
#
# history:
# 1.0  - Initial Version
# 2.0  - change for klobsrv
# ***************************************************************************
# Script for sql backup  - db named "dbname" & copy output file to netstorage
# & delete oldest backups
# ***************************************************************************

$TimeStamp = get-date -f yyyyMMddhhmm
$destination = "\\netstorage\full\"
$localfolder = "pathforbackup\full\"
$limit= (Get-Date).AddMonths(-3)
$limit1= (Get-Date).AddDays(-1)
$filename = "fullbackup_$TimeStamp.bak"

Write-Host "full backup of db dbname"
Backup-SqlDatabase -ServerInstance "localhost" -Database "dbname" -BackupFile $localfolder$filename

Write-Host "copy backup into netstorage..."
Copy-Item $localfolder$filename -Destination $destination -force

write-host "delete backup older 1 day from local"
Get-ChildItem -Path $localfolder -Recurse -Force | Where-Object { $_.LastWriteTime -lt $limit1 } | Remove-Item -Force

write-host "delete backup older 3 months from netstorage"
Get-ChildItem -Path $destination -Recurse -Force | Where-Object { $_.LastWriteTime -lt $limit } | Remove-Item -Force

exit
