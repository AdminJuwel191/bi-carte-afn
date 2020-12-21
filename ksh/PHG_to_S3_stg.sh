#!/bin/bash
for FILE_PATH in /home/Export/PHG/Invoices_final/*phg*; do
	echo $FILE_PATH
	
	filename=$(echo "$FILE_PATH" | sed "s/.*\///")
	echo $filename
	
	TIMESTAMP=`date '+year=%Y/month=%m/day=%d/Hour=%H'`;
	echo $TIMESTAMP

	affnetwork="$(echo $(basename "$FILE_PATH") | cut -d '-' -f 1)"
	echo $affnetwork

	file=$(echo $filename | sed "s/_/\//g")
	echo $file
	path="s3://bi-pdi-archive/Invoices/PHG/$affnetwork/$TIMESTAMP/$file"
	aws s3 cp $FILE_PATH $path

done
