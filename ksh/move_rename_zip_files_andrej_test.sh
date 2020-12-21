#test comment
TIMESTAMP=`date '+%Y%m%d_%H%M%S'`;
pattern=$1


for f in /home/Export/*${pattern}* ; do
if [ -f "$f" ];
	then  
		name=$(basename "$f")

		mdate=$(stat -c %y /home/Export/"${name}")

		DAY=$(date -d "$mdate" '+%d')
		MONTH=$(date -d "$mdate" '+%m')
		YEAR=$(date -d "$mdate" '+%Y')

		STOREDIR="s3://bi-pdi-archive/archive_files/andrej-test/"${YEAR}"/"${MONTH}"/"${DAY}"/"
		STOREDIRYEAR="s3://bi-pdi-archive/archive_files/andrej-test/"${YEAR}
		STOREDIRMONTH="s3://bi-pdi-archive/archive_files/andrej-test/"${YEAR}"/"${MONTH}
		STOREDIRDAY="s3://bi-pdi-archive/archive_files/andrej-test/"${YEAR}"/"${MONTH}"/"${DAY}

                STOREDIR2="/home/ArchiveS3/archive_files/andrej-test/"${YEAR}"/"${MONTH}"/"${DAY}"/"
                STOREDIRYEAR2="/home/ArchiveS3/archive_files/andrej-test/"${YEAR}
                STOREDIRMONTH2="/home/ArchiveS3/archive_files/andrej-test/"${YEAR}"/"${MONTH}
                STOREDIRDAY2="/home/ArchiveS3/archive_files/andrej-test/"${YEAR}"/"${MONTH}"/"${DAY}

		if [ -d ${STOREDIRDAY} ];
			then		
				aws s3 cp "$f" ${STOREDIR}"${name}"_${TIMESTAMP}
				gzip -f ${STOREDIR2}"${name}"_${TIMESTAMP}
			else
				if [ -d ${STOREDIRMONTH} ];
					then
						aws s3 cp "$f" ${STOREDIR}"${name}"_${TIMESTAMP}
						gzip -f ${STOREDIR2}"${name}"_${TIMESTAMP}
					else
						if [ -d ${STOREDIRYEAR} ];
							then
								aws s3 cp "$f" ${STOREDIR}"${name}"_${TIMESTAMP}
								gzip -f ${STOREDIR2}"${name}"_${TIMESTAMP}
							else
								aws s3 cp "$f" ${STOREDIR}"${name}"_${TIMESTAMP}
								gzip -f ${STOREDIR2}"${name}"_${TIMESTAMP}
						fi;
				fi;
		fi;
fi ;
done;
