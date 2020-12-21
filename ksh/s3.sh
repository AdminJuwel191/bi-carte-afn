#!/bin/sh
TIMESTAMP=`date '+year=%Y/month=%m/day=%d/hour=%H'`;
for file in /home/Export/*shsus1*; do
filename=$(echo "$file" | rev | cut -d"." -f2-  | rev)
affnetwork_id=$(echo $(basename "$filename") | cut -d '_' -f 9)
awk -vc1="affnetwork_id" -vc2="currency" -vd1=$(echo $(basename "$filename") | cut -d '_' -f 9) -vd2=$(echo $(basename "$filename") | cut -d '_' -f 3) 'NR==1{$0=c1"|"$0}NR==1{$0=c2"|"$0}NR!=1{$1=d1"|"$1}NR!=1{$1=d2"|"$1}NF' /home/Export/$(basename "$file") > /home/Export/s3_final/$(basename "$file")
done
for file_path in /home/Export/s3_final/*shareasale*; do
awk '$1=$1' FS="," OFS="|" /home/Export/s3_final/$(basename $file_path)
filename1=$(echo "$file_path" | rev | cut -d"." -f2-  | rev)
affnetwork_id1=$(echo $(basename "$filename1") | cut -d '_' -f 9)
path="s3://bi-finance-prod/raw_transactions/API/ShareASale/affnetwork_id=$affnetwork_id1/$TIMESTAMP/$(basename $file_path)"
aws s3 mv $file_path "$path"
done
