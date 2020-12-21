#!/bin/bash

TIMESTAMP=`date '+%Y%m%d_%H%M%S'`;

NUM_FILES=`ls -l *affiliate_window* | wc -l`

if [ $NUM_FILES -ne 0 ]; then

	DAY=$(date -d "$mdate" '+%d')
	MONTH=$(date -d "$mdate" '+%m')
	YEAR=$(date -d "$mdate" '+%Y')


echo "{\"entries\": [" > /home/Export/commission_group/awin_commission_group.manifest

 for FILE_PATH in /home/Export/commission_group/*affiliate_window*; do
	mv "$FILE_PATH" "$FILE_PATH"_${TIMESTAMP}
done

	for FILE_PATH in /home/Export/commission_group/*affiliate_window*; do
	
	

	filename=$(echo "$FILE_PATH" | sed "s/.*\///")

	echo "{\"url\":\"s3://bi-pdi-prod/commission-group/Affiliate_window/Year="${YEAR}"/Month="${MONTH}"/Day="${DAY}"/"$filename"\", \"mandatory\":false}," >> /home/Export/commission_group/awin_commission_group.manifest

	done
sed -i '$ s/.$//' /home/Export/commission_group/awin_commission_group.manifest
echo "]}" >> /home/Export/commission_group/awin_commission_group.manifest


for FILE_PATH in /home/Export/commission_group/*affiliate_window*; do

        filename=$(echo "$FILE_PATH" | sed "s/.*\///")
	S3_LAKE_BUCKET="s3://bi-pdi-prod/commission-group/Affiliate_window/Year="${YEAR}"/Month="${MONTH}"/Day="${DAY}"/"
	
echo

	aws s3 mv  $FILE_PATH $S3_LAKE_BUCKET

        done
	S3_MANIFEST="s3://bi-pdi-prod/commission-group/manifest_files/"
	aws s3 mv  awin_commission_group.manifest $S3_MANIFEST

fi
