origin="s3://bi-pdi-archive/Invoices/Commission\ Junction/affnetwork-id=cjunl25/"
count=0
for path in $(aws s3 ls $origin);
do
 oldID=${path%/}
 newID=${myArray[$oldID]} #gets the newID
 if [[ "$newID" != "" ]]; then
   destination="$origin/$newID/$path"
   aws s3 cp "s3://$origin$path" /home/Export/DraganaCJ --recursive
   let count=count+1
   echo "transferred $count files"
 fi
done
