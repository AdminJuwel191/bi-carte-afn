#!/bin/bash
for FILE_PATH in /home/Export/PHG/phg*; do
echo $FILE_PATH
filename=$(echo "$FILE_PATH" | sed "s/.*\///")
echo ""
echo $filename
echo ""
file=$(echo $filename | sed "s/_/\//g")
echo $file
path="s3://bi-pdi-archive/Invoices/PHG/$file"
aws s3 cp $FILE_PATH $path

done
