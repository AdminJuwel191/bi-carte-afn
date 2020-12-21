#!/bin/bash

#Copy files to PDI

PDI='root@54.171.88.82'
local_path='/home/Export'
remote_path='/mnt/www/bi_production/BI/api_data_import'


scp $PDI:$remote_path/csv-* $local_path
