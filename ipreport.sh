#!/bin/bash

if [ -z "$1" ]; then
  echo "You must supply an email address"
  exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
FILE="$DIR/currentip"
HOSTNAME=`hostname`
EMAIL=$1
LOGLEVEL=2 # 0 = none, 1 = changes, 2 = all
LOGFILE="$DIR/log"
NOW=$(date +"%Y/%m/%d %T")
IP=`wget -q -O - checkip.net-me.net/plain`

if [[ $LOGGING -ge 2 ]]; then
  echo "$NOW : running" >> LOGFILE
fi

if [[ ! -e $FILE ]]; then
  echo $IP > $FILE
  if [[ $LOGGING -ge 1 ]]; then
    echo "$NOW : made new file $FILE" >> LOGFILE
  fi
elif [ "$(cat $FILE)" != "$IP" ]; then
  echo $IP > $FILE
  mailx -s "$HOSTNAME has a new IP!" $EMAIL <<< `cat $FILE`
  if [[ LOGGING -ge 1 ]]; then
    echo "$NOW : ip changed to $IP, sent email" >> LOGFILE
  fi
fi
