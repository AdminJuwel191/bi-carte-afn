#!/bin/bash

for file in /home/Export/*Cuponation_affiliate_window*.js; do
# echo $(basename "$file")
country_iso="$(echo $(basename "$file") | cut -d '_' -f 2)"
transaction_source=="$(echo $(basename "$file") | cut -d '_' -f 1)"
affnetwork_id="$(echo $(basename "$file") | cut -d '_' -f 4)"
# transaction_source="$(echo $(basename "$file") | cut -d '_' -f 1)"

an="$(echo $(basename "$file") | cut -d '_' -f 5)"

days="$(echo $(basename "$file") | cut -d '_' -f 6)"

year="$(echo $(basename "$file") | cut -d '_' -f 7)"

month="$(echo $(basename "$file") | cut -d '_' -f 8)"

day="$(echo $(basename "$file") | cut -d '_' -f 9)"

daily_occurence="$(echo $(basename "$file") | cut -d '_' -f 10)"

file_name=$(basename "$file")
ext=".gz"

jq '.[] += {"FileName": "'"$file_name"'"}' "$file" >> /home/Export/AWIN/S3/"$file_name"
jq -c .[] /home/Export/AWIN/S3/"$file_name"  | gzip |aws s3 cp - s3://bi-pdi-prod/Transactions/aspasov/Affiliate_window/$days/$year/$month/$day/$daily_occurence/$country_iso/$affnetwork_id/"$file_name"$ext
done
