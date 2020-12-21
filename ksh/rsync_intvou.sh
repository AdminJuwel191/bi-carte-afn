#!/bin/bash


SERVER=54.246.94.154
LOCAL_PATH=/home/voucher_rank
REMOTE_PATH=/root/Crawler/
RM_COMMAND="rm "$REMOTE_PATH"voucher_rank/*"

ssh $SERVER $RM_COMMAND
rsync -ravm -e ssh $LOCAL_PATH $SERVER:$REMOTE_PATH
