#!/bin/bash
#Dateinamen für die Dateien
FROM=missimfis_$(date +%Y%m)01_backup.tar.bz2
TO=missimfis_$(date +%Y%m)_backup.tar.bz2
# Copy first of the month into monthly backups
cp /home/missimfis/extData/backup/$FROM /home/missimfis/extData/backup/monthly/$TO
#destroy all backups of this month in the normal folder
rm /home/missimfis/extData/backup/missimfis_$(date +%Y%m)*
