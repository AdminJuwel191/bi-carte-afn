TIMESTAMP=`date '+%Y%m%d_%H%M%S'`;
AFFILIATE_NETWORK=$1
MANIFEST_FILE_NAME=$2

for FILE_PATH_ORIGIN in /home/Export/oqu_test/*"${AFFILIATE_NETWORK}"*; 
do
    filename_origin=$(echo "$FILE_PATH_ORIGIN" | sed "s/.*\///")
    filename_origin_wo_whitespace=$(echo "$filename_origin" | sed "s/ /_/g")
    echo "$filename_origin_wo_whitespace"
	sed "s/^/$filename_origin;/" /home/Export/oqu_test/"$filename_origin" > /home/Export/oqu_test/INVOICES/"${AFFILIATE_NETWORK}"/"${filename_origin_wo_whitespace}"
done
NUM_FILES=`ls -l *"${AFFILIATE_NETWORK}"* | wc -l`
if [ $NUM_FILES -ne 0 ]; then

        DAY=$(date -d "$mdate" '+%d')
        MONTH=$(date -d "$mdate" '+%m')
        YEAR=$(date -d "$mdate" '+%Y')


echo "{\"entries\": [" > /home/Export/oqu_test/INVOICES/"${AFFILIATE_NETWORK}"/"${MANIFEST_FILE_NAME}"_manifest.manifest

        for FILE_PATH in /home/Export/oqu_test/INVOICES/"${AFFILIATE_NETWORK}"/*"${AFFILIATE_NETWORK}"*; do



        filename=$(echo "$FILE_PATH" | sed "s/.*\///")
        sed "s/^/$filename,/" "$FILE_PATH"
        echo "{\"url\":\"s3://bi-pdi-archive/Invoices/"${AFFILIATE_NETWORK}"/oqu_test/Year="${YEAR}"/Month="${MONTH}"/Day="${DAY}"/Datetime="${TIMESTAMP}"/"$filename"\", \"mandatory\":false}," >> /home/Export/oqu_test/INVOICES/"${AFFILIATE_NETWORK}"/"${MANIFEST_FILE_NAME}"_manifest.manifest
        done
sed -i '$ s/.$//' /home/Export/oqu_test/INVOICES/"${AFFILIATE_NETWORK}"/"${MANIFEST_FILE_NAME}"_manifest.manifest
echo "]}" >> /home/Export/oqu_test/INVOICES/"${AFFILIATE_NETWORK}"/"${MANIFEST_FILE_NAME}"_manifest.manifest


for FILE_PATH in /home/Export/oqu_test/INVOICES/"${AFFILIATE_NETWORK}"/*"${AFFILIATE_NETWORK}"*; do

        filename=$(echo "$FILE_PATH" | sed "s/.*\///")
        S3_LAKE_BUCKET="s3://bi-pdi-archive/Invoices/"${AFFILIATE_NETWORK}"/oqu_test/Year="${YEAR}"/Month="${MONTH}"/Day="${DAY}"/Datetime="${TIMESTAMP}"/"
echo
        aws s3 mv  $FILE_PATH $S3_LAKE_BUCKET
done
        S3_MANIFEST="s3://bi-pdi-archive/Invoices/manifest_files/test/"
        aws s3 mv  "${MANIFEST_FILE_NAME}"_manifest.manifest $S3_MANIFEST

fi
