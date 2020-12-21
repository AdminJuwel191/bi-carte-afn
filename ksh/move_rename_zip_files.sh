#!/bin/bash

TIMESTAMP=`date '+%Y%m%d_%H%M%S'`;
pattern=$1

error_pattern="*Error*"

for f in /home/Export/*${pattern}* ; do
if [ -f "$f" ];
	then  
		name=$(basename "$f")

		mdate=$(stat -c %y /home/Export/"${name}")

		DAY=$(date -d "$mdate" '+%d')
		MONTH=$(date -d "$mdate" '+%m')
		YEAR=$(date -d "$mdate" '+%Y')

		STOREDIR="s3://bi-pdi-archive/archive_files/"${YEAR}"/"${MONTH}"/"${DAY}"/"$pattern"/"
		S3_LAKE_BUCKET="s3://bi-pdi-prod/raw-transactions/"$pattern"/"${YEAR}"/"${MONTH}"/"${DAY}"/"
		S3_ERROR_FILES="s3://bi-pdi-prod/error-raw-transactions/"$pattern"/"${YEAR}"/"${MONTH}"/"${DAY}"/"
				
			gzip -f "$f" -S _${TIMESTAMP}.gz
	
			if [[ $f == $error_pattern ]];
			then
				echo "Error file"
				aws s3 mv "$f"_${TIMESTAMP}.gz $S3_ERROR_FILES
			else
				#aws s3 cp "$f"_${TIMESTAMP}.gz $S3_LAKE_BUCKET
				aws s3 mv "$f"_${TIMESTAMP}.gz $STOREDIR
				#mv "$f" ${STOREDIR}"${name}"_${TIMESTAMP}
			fi;
		
fi ;
done;
