#!/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

SUFIX=`date +%Y%m%d_%H%M%S`

cd /home/pentaho/data-integration/&&./kitchen.sh /rep:"pdi_repo_postgre" /job:"Main_Download_At" /dir:/ /user:admin /pass:admin /level:Detailed >/home/log/Main_Download_At_cron.log

mv /home/log/Main_Download_At_cron.log /home/log/Main_Download_At_cron_$SUFIX.log
