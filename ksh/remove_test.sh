#!/bin/bash

NUM_FILES_1=`find /home/Export/Tradedoubler/ -maxdepth 1 -type f -name Tradedoubler* | wc -l`
echo $NUM_FILES_1
if [ $NUM_FILES_1 -gt 0 ]; then
	rm -rf /home/Export/Tradedoubler/Tradedoubler*
fi;

NUM_FILES_2=`find /home/Export/Publicis/ -maxdepth 1 -type f -name Publicis* | wc -l`
echo $NUM_FILES_2
if [ $NUM_FILES_2 -gt 0 ]; then
	rm -rf /home/Export/Publicis/Publicis*
fi;
