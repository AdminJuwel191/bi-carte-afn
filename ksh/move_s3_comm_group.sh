#!/bin/bash

#Input parameters
S3_BUCKET=$1
AFFILIATE_NETWORK=$2

if [ "$AFFILIATE_NETWORK" == "" ] || [ "$S3_BUCKET" == "" ]; then
	echo "Not all input parameters have been set, please set them to use the script"
	exit 1
fi;


# The script lists the files in the S3 location providede by the input parameters and replaces the - with / in the file name and stores them accordingly in the new S3 location
#For example if the file_name is CommunicationAds-Year=2020-Month=7-Day=29-Com_Group_CN_de_cmade01_CommunicationAds_20200727_20200729_Cuponation_verticalads_20200729_125212.csv.gz
#The script after replacing - with - it will store the file on location and rename it to 
#CommunicationAds/Year=2020/Month=7/Day=29/Com_Group_CN_de_cmade01_CommunicationAds_20200727_20200729_Cuponation_verticalads_20200729_125212.csv.gz
for f in $(aws s3 ls s3://$S3_BUCKET/commission-group/$AFFILIATE_NETWORK/delta/ | grep $AFFILIATE_NETWORK | awk '{print $4}'); do

	FILE_NAME="${f//-//}"
	aws s3 mv s3://$S3_BUCKET/commission-group/$AFFILIATE_NETWORK/delta/$f s3://$S3_BUCKET/commission-group/$AFFILIATE_NETWORK/$FILE_NAME
done
