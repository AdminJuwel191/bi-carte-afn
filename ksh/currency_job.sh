#!/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

SUFIX=`date +%Y%m%d_%H%M%S`

cd /home/pentaho/data-integration/&&./kitchen.sh /rep:"pdi_repo_postgre" /job:"Currency_Rate_Job" /dir:/ /user:admin /pass:admin /level:Error >/home/log/Currency_Rate_Job_cron.log

mv /home/log/Currency_Rate_Job_cron.log /home/log/Currency_Rate_Job_cron_$SUFIX.log
