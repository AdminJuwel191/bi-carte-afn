#!/bin/bash

PATTERN=$1
ERROR_PATTERN="*Error*"
TIMESTAMP=`date '+%Y%m%d_%H%M%S'`

if [ "$PATTERN" == "" ]; then
        echo "The input parameter PATTERN has been set, please set it in order to use the script"
        exit 1
fi;

for f in /home/Export/*${PATTERN}* ; do
if [ -f "$f" ];
        then
                name=$(basename "$f")

                mdate=$(stat -c %y /home/Export/"${name}")

                DAY=$(date -d "$mdate" '+%d')
                MONTH=$(date -d "$mdate" '+%m')
                YEAR=$(date -d "$mdate" '+%Y')

                STOREDIR="s3://bi-pdi-archive/archive_files/"$PATTERN"/"${YEAR}"/"${MONTH}"/"${DAY}"/"
                S3_ERROR_FILES="s3://bi-pdi-prod/error-raw-transactions/"$PATTERN"/"${YEAR}"/"${MONTH}"/"${DAY}"/"

                        #Add timestamp at the end of the file befoer the file extension
                        f_n="${f/./_$TIMESTAMP.}"
                        #Rename the file with the new name
                        mv $f $f_n
                        
                        gzip -f "$f_n"


                        if [[ $f_n == $ERROR_PATTERN ]];
                        then
                                echo "Error file"
                                aws s3 mv "$f_n".gz $S3_ERROR_FILES
                        else
                                aws s3 mv "$f_n".gz $STOREDIR
                        fi;

fi ;
done;
