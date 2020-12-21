NUM_FILES=`ls -l affnet * | wc -l`

if [ $NUM_FILES -ne 0 ]; then
for FILE_PATH in /home/Export/INVOICES/Pepperjam/affnet*; do
echo $FILE_PATH
filename=$(echo "$FILE_PATH" | sed "s/.*\///")
echo ""
echo $filename
echo ""
file=$(echo $filename | sed "s/_/\//g")
echo $file
path="s3://bi-pdi-archive/Invoices/Pepper Jam/$file"
aws s3 mv $FILE_PATH "$path"

done
fi

