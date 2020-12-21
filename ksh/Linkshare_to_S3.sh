#!/bin/bash

#number of files in the directory
NUM_FILES=`find /home/Export/Linkshare/ -maxdepth 1 -type f -name affnetwork* | wc -l`

if [ $NUM_FILES -gt 0 ]; then
	
	echo "In total there are $NUM_FILES files to be trasferred"


	for FILE_PATH in /home/Export/Linkshare/affnetwork*; do
	
	echo $FILE_PATH
	filename=$(echo "$FILE_PATH" | sed "s/.*\///")
	echo ""
	echo $filename
	echo ""
		file=$(echo $filename | sed "s/_/\//g")
	echo $file
	echo ""
		path="s3://bi-pdi-archive/Invoices/Linkshare/$file"
	aws s3 cp $FILE_PATH $path

	done
else
	echo "There are no files to be transferred"
	echo ""	
fi;
