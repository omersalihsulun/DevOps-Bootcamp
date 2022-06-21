#!/bin/sh

Recipient = "omersalih.sulun@gmail.com"
df -Ph | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5,$1 }' | while read output;
do
echo $output
used=$(echo $output | awk '{print $1}' | sed s/%//g)
partition=$(echo $output | awk '{print $2}')
if [ $used -ge 90 ] 
then
echo "%$used kullanım oranı mevcut. $partition diski $(date) Tarihinde eşik değerini aştı." | mail -s "Disk Kullanım Uyarısı %$used kullanıma ulaştı!" $Recipient
fi
done