#!/bin/bash

echo "user:"
whoami
echo "Aws-cli Version:"
aws --v
echo "Removing old file .. "
rm -f /home/Export/metadata/awin.json
echo "Get-table from CAtalog.. "
aws glue get-table --database-name aff_networks --name awin_ct_105_2 --output json > /home/Export/metadata/awin.json
echo "Change Location Parameter.. "
sed -i "/"Location"/c \"Location\":\""$1"\"," /home/Export/metadata/awin.json
echo "Remove UpdateTime line.. "
sed -i '/"UpdateTime"/c\ ' /home/Export/metadata/awin.json
echo "Remove last line.."
sed -i '$ d' /home/Export/metadata/awin.json
echo "Remove First like Table{.. "
sed -i '/"Table": {/c\ ' /home/Export/metadata/awin.json
echo "Update-table in catalog .."
aws glue update-table --database-name --output json aff_networks --table-input file:///home/Export/metadata/awin.json 
