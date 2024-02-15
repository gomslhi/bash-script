#!/bin/bash

#created by: gomgom silalahi
#dated: 20230128

  #path folder log
  #jika ada tambahan untuk log yang mau dihapus tinggal input path file log nya berada

folders=("/data/api-biometric/logs"
         "/data/api-briva/logs"
         "/data/api-edits/app/api-edits/application/logs")

  #command find dan hapus file yang lebih dari 8 hari (default 8 hari)

for folder in "${folders[@]}";
  do
 for file in "$folder"/*;
   do
     find $file -type f -mtime +8 -exec rm -rf {} \; && echo "file berhasil di hapus-$(date +%d-%m-%Y)" >> /data/source/script/log_retensi.log
 done
done
