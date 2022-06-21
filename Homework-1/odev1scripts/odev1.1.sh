#!/bin/bash

DATE=$(date +%d-%m-%Y)
TIME=$(date "+%T")
BACKUP_DIR="/mnt"

for USER in $(cat /etc/passwd | grep '/home' | cut -d: -f1)
do
tar -czf ${BACKUP_DIR}/${USER}_${DATE}_${TIME}.tar.gz /home/${USER}
m5sum ${BACKUP_DIR}/${USER}_${DATE}_${TIME}.tar.gz >> ${BACKUP_DIR}/${USER}_${DATE}_${TIME}.tar.gz.md5.txt
done