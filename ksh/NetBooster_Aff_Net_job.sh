#!/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

SUFIX=`date +%Y%m%d_%H%M%S`

cd /home/pentaho/data-integration/&&./kitchen.sh /rep:"pdi_repo_postgre" /job:"NetBost_Main_Download" /dir:/ /user:admin /pass:admin /level:Detailed >/home/log/NetBost_Main_Download_cron.log

mv /home/log/NetBost_Main_Download_cron.log /home/log/NetBost_Main_Download_cron_$SUFIX.log
