for file in /home/Export/*cmf*;do


TIMESTAMP=`date '+year=%Y/month=%m/day=%d/Hour=%H'`;
echo $TIMESTAMP

affnetwork="$(echo $(basename "$file") | cut -d '_' -f 4)"
echo $affnetwork

currency="$(echo $(basename "$file") | cut -d '_' -f 3)"
echo $currency

ext=".gz"


jq 'map(. +{affnetwork_id: "'"$affnetwork"'" , currency: "'"$currency"'"})' $file >> /home/Export/CommissionFactoryInvoices/$(basename "$file")

filename=$(basename "$file")
jq -c .[] /home/Export/CommissionFactoryInvoices/"$filename" | aws s3 cp - s3://bi-finance-prod/raw_transactions/API/Commission_Factory/affnetwork_id=$affnetwork/$TIMESTAMP/"$filename"
done
