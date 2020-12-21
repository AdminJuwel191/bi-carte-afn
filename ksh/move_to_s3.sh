#!/bin/bash

#The script needs 3 input parameters to be set in the following order or otherwise it will not work
#Input parameters
#AFFILIATE_NETWORK=Tradedoubler
#FILE_BASE_PATH=/home/Export
#S3_BASE_PATH=s3://bi-pdi-archive/Invoices


#Input parameters
AFFILIATE_NETWORK=$1
FILE_BASE_PATH=$2
S3_BASE_PATH=$3

echo "Affiliate network is $AFFILIATE_NETWORK"
echo "File_base_path is $FILE_BASE_PATH"
echo "S3 base path is $S3_BASE_PATH"

if [ "$AFFILIATE_NETWORK" == "" ] || [ "$FILE_BASE_PATH" == "" ] || [ "$S3_BASE_PATH" == "" ]; then
	echo "Not all input parameters have been set, please set all three of them to use the script"
	exit 1
fi;

#pathe where we are searching for files and trannsfer then to S3
LOOP_PATH="$FILE_BASE_PATH/$AFFILIATE_NETWORK/$AFFILIATE_NETWORK*"

#number of files in the directory
NUM_FILES=`find "$FILE_BASE_PATH/$AFFILIATE_NETWORK/" -maxdepth 1 -type f -name "$AFFILIATE_NETWORK*" | wc -l`


if [ $NUM_FILES -gt 0 ]; then
	
	echo "In total there are $NUM_FILES files to be trasferred"

	for FILE_PATH in $LOOP_PATH; do

		FILE_NAME="$(basename -- $FILE_PATH)"
		S3_PATH="$S3_BASE_PATH/${FILE_NAME//_//}"
		
		aws s3 cp $FILE_PATH $S3_PATH

		NUM_FILES=$((NUM_FILES-1))
		
		if [ $NUM_FILES -eq 0 ]; then
			echo "All files have been moved to S3"
		else
			echo "There are $NUM_FILES files to be moved"
			echo ""
		fi;		
		
	done
else
	echo "There are no files to be transferred"
	echo ""	
fi;
