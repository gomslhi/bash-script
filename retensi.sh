#!/bin/bash


#source_file=/data/backup-db/ebas/2023/Okt/EBAS_BACKUP_FULL_2023_10_01.sql
#dest=/data/backup-db/~archived/2023/202310/ebas

source = /data/backup-db/ebas/
dest = /data/backup-db/~archived/$(date +%Y)/$(date +%Y%m)

#check folder dest sudah terbentuk atau blm 

if [ -d /data/backup-db/~archived/$(date +%Y)]
    then cd /$(date +%Y)
    else
        exit && echo "folder tahun belum terbentuk" >> /data/backup-db/ebas/log/log_cp_archived_ebas_$(date +%d-%m-%Y).log
fi 
    if [ -d /data/backup-db/~archived$(date +%Y)/$(date +%Y%m)]
        then 
            cd /$(date +%Y%m)
        else
        exit  && echo "folder tahun&bulan belum terbentuk" >> /data/backup-db/ebas/log/log_cp_archived_ebas_$(date +%d-%m-%Y).log
    fi
        if [ -d /data/backup-db/~archived$(date +%Y)/$(date +%Y%m)/ebas]
        then 
            mkdir ebas 
            cd ebas 
            array = ()
            while IFS = read -r -d $'\0\';
                do 
                    array+=("$REPLY")
            done << (find /data/backup-db/ebas/$(date +%Y)/ -type f -name "*01.sql")

echo pwd









