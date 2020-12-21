TIMESTAMP=`date '+%Y%m%d_%H%M%S'`;

pattern=$1

echo ${pattern}

for f in /home/Export/*${pattern}* ; do   
if [ -f "$f" ]; 
then  name=$(basename "$f")

mv "$f" /home/Archive/"${name}"_${TIMESTAMP}
gzip -f /home/Archive/"${name}"_${TIMESTAMP}
fi 
done; 
