
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

		STOREDIR="/home/ArchiveS3/archive_files/"${YEAR}"/"${MONTH}"/"${DAY}"/"
		STOREDIRYEAR="/home/ArchiveS3/archive_files/"${YEAR}
		STOREDIRMONTH="/home/ArchiveS3/archive_files/"${YEAR}"/"${MONTH}
		STOREDIRDAY="/home/ArchiveS3/archive_files/"${YEAR}"/"${MONTH}"/"${DAY}

		if [ -d ${STOREDIRDAY} ];
			then		
				mv "$f" ${STOREDIR}"${name}"_${TIMESTAMP}
				gzip -f ${STOREDIR}"${name}"_${TIMESTAMP}
			else
				if [ -d ${STOREDIRMONTH} ];
					then
						mkdir ${STOREDIRDAY}
						chmod 775 ${STOREDIRDAY}
						mv "$f" ${STOREDIR}"${name}"_${TIMESTAMP}
						gzip -f ${STOREDIR}"${name}"_${TIMESTAMP}
					else
						if [ -d ${STOREDIRYEAR} ];
							then
								mkdir ${STOREDIRMONTH}
								chmod 775 ${STOREDIRMONTH}
								mkdir ${STOREDIRDAY}
								chmod 775 ${STOREDIRDAY}
								mv "$f" ${STOREDIR}"${name}"_${TIMESTAMP}
								gzip -f ${STOREDIR}"${name}"_${TIMESTAMP}
							else
								mkdir ${STOREDIRYEAR}
								chmod 775 ${STOREDIRYEAR}
								mkdir ${STOREDIRMONTH}
								chmod 775 ${STOREDIRMONTH}
								mkdir ${STOREDIRDAY}
								chmod 775 ${STOREDIRDAY}
								mv "$f" ${STOREDIR}"${name}"_${TIMESTAMP}
								gzip -f ${STOREDIR}"${name}"_${TIMESTAMP}
						fi;
				fi;
		fi;
fi ;
done;
