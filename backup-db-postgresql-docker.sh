#!/bin/bash

########################################################################################################

#name:gomgom silalahi
#date:202307025
#SCRIPT UNTUK BACKUP DATABASE POSTGREE DI DALAM CONTAINER, COMPRESS DAN COPY KE DIR ROOT DI HOST

#########################################################################################################

#DEC PARAMETER UNTUK COPY FILE DARI DALAM CONTAINER KE ROOT DIRECTORY 
container_name="api-myebenefit-cms-01_db_1"
dest_path="/data/backup-db/myebenefit"
db_name="db_myebenefit"
backup_folder="/backup/$(date +%Y)/$(date +%m)"
backup="$backup_folder/$(date +%d-%m-%Y)-$db_name.bak"
tar_backup="/backup/compress/$(date +%d-%m-%Y)-$db_name.zip"

#MASUK KE CONTAINER
enter_container="docker exec -i api-myebenefit-cms-01_db_1 bash"

$enter_container << 'EOF' 

cd /

#DB_NAME
db_name="db_myebenefit" 

#BACKUP_FOLDER  
#check pertama apakah folder untuk backup sudah ada atau belum 
if [ -d /backup ];
   then echo "folder ada" 
   else  
       mkdir backup
fi
       if [ -d /backup/$(date +%Yi) ];
          then echo "folder ada"
          else
              cd /backup
              mkdir $(date +%Y)
       fi       
              if [ -d /backup/$(date +%Y)/$(date +%m) ];
                 then echo "folder ada"
                 else
                     cd /backup/$(date +%Y)
                     mkdir $(date +%m)
              fi
backup_folder="/backup/$(date +%Y)/$(date +%m)" 
 
#RETENSI 
retensi="14"

#KELUAR CONTAINER
exit_container="exit"

#NAMA FILE BACKUP POSTGREE
backup="$backup_folder/$(date +%d-%m-%Y)-$db_name.bak"

#CHECK APAKAH FOLDER LOG SUDAH ADA  
if [ -d /backup/log ];
  then echo "folder ada"
  else 
    mkdir /backup/log
fi

#BACKUP DATABASE
if [ -f "$backup" ];
   then
    echo "backup $db_name-$(date +%d-%m-%Y) sudah ada" >> /backup/log/$db_name-$(date +%d-%m-%Y).log
     else
      pg_dump -U gomgom $db_name > $backup && echo "backup $db_name-$(date +%d-%m-%Y) berhasil" > /backup/log/$db_name-$(date +%d-%m-%Y).log 
fi 

#DELETE FILE BACKUP DB DAN LOG DI DALAM CONTAINER
find $backup_folder -type f -name "*.bak" -mtime +$retensi -exec rm -rf {} \;
#find /backup/compress -type f -name "*.zip" -mtime +7 -exec rm -rf {} \;
find /backup/log -type f -name "*.log" -mtime +$retensi -exec rm -rf {} \;

EOF

#$exit_container

#CHECK DAN COPY FILE DARI DALAM CONTAINER (+ CASE CHECK & COPY ULANG JIKA FILE H-1 GAGAL TERCOPY)

datemin1="$(date -d 'yesterday' +%d-%m-%Y)"
filemin1="$backup_folder/$datemin1-$db_name.bak"

if [ -f "$dest_path/$filemin1" ];
  then 
   echo "file backup $datemin1-$db_name.bak sudah ada"
  else 
   docker cp "${container_name}:${filemin1}" "${dest_path}" && echo "file $datemin1-$db_name.bak sudah dicopy ulang dan berhasil" >> /data/backup-db/log/$db_name-$(date +%d-%m-%Y).log

fi
     if [ -f "$dest_path/$(date +%d-%m-%Y)-$db_name.bak" ]
       then
        echo "copy $(date +%d-%m-%Y)-$db_name.bak sudah ada"
       else
        docker cp "${container_name}:${backup}" "${dest_path}" && echo "backup $db_name-$(date +%d-%m-%Y).bak berhasil" > /data/backup-db/log/$db_name-$(date +%d-%m-%Y).log
     fi 
  
#delete file backup db yang di directory root
find $dest_path -type f -mtime +14 -exec rm rf {} \;
